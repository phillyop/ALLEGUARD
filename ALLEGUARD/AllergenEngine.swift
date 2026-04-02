import Foundation
import SwiftUI

enum AllergenEngine {

    static let allergenDictionary: [String: [String]] = [
        "Milk": [
            "milk", "whey", "casein", "caseinate", "lactose", "butter", "cream",
            "cheese", "skim milk", "milk solids", "milk powder", "milk protein",
            "dairy", "ghee", "buttermilk", "lactalbumin", "lactoglobulin"
        ],
        "Egg": [
                    "egg", "albumin", "ovalbumin", "egg white", "egg yolk", "globulin",
                    "mayonnaise", "meringue", "egg powder", "dried egg",
                    "egg solids", "ovomucin", "lysozyme"
                ],
        "Fish": [
            "fish", "salmon", "tuna", "cod", "anchovy", "sardine",
            "tilapia", "bass", "halibut", "mackerel", "trout", "haddock",
            "pollock", "mahi", "swordfish", "catfish", "herring", "snapper",
            "fish sauce", "worcestershire"
        ],
        "Shellfish": [
            "shellfish", "shrimp", "prawn", "crab", "lobster", "crayfish",
            "oyster", "clam", "scallop", "squid", "octopus", "abalone",
            "barnacle", "mussel", "clams", "langoustine"
        ],
        "Tree Nuts": [
                    "almond", "cashew", "walnut", "pecan", "hazelnut", "pistachio",
                    "macadamia", "brazil nut", "tree nut", "pine nut", "chestnut",
                    "praline", "marzipan", "nougat", "nut oil", "nut butter"
                ],
        "Peanuts": [
            "peanut", "peanuts", "groundnut", "groundnuts", "arachis",
            "peanut butter", "peanut oil", "monkey nuts", "mixed nuts",
            "beer nuts", "cacahuate", "earth nut"
        ],
        "Wheat": [
            "wheat", "semolina", "farina", "bulgur", "couscous", "wheat flour",
            "gluten", "spelt", "kamut", "einkorn", "emmer", "durum",
            "wheat starch", "wheat germ", "wheat bran", "triticale",
            "bread flour", "plain flour", "self raising flour"
        ],
        "Soy": [
            "soy", "soya", "soybean", "soy lecithin", "soy protein", "tofu",
            "edamame", "miso", "tempeh", "tamari", "soy sauce", "textured vegetable protein",
            "tvp", "soy milk", "soy oil", "soy flour", "natto"
        ],
        "Sesame": [
            "sesame", "tahini", "benne", "til", "gingelly", "sesame oil",
            "sesame seed", "sesame flour", "hummus", "halva"
        ]
    ]

    static let crossContactPhrases: [String] = [
        "may contain",
        "may contain traces of",
        "may contain trace amounts of",
        "processed in a facility with",
        "manufactured in a facility with",
        "made on shared equipment",
        "produced on shared equipment",
        "made in a facility that also processes",
        "manufactured on shared equipment",
        "not suitable for people with",
        "made in a factory handling"
    ]

    static let directContainsLeadIns: [String] = ["contains", "ingredients"]

    static let freeFromLeadIns: [String] = [
        "free from", "dairy free", "gluten free", "peanut free",
        "nut free", "soy free", "egg free", "sesame free", "vegan"
    ]

    // MARK: - Main entry point

    static func analyze(
        text: String,
        userAllergies: [String],
        customAllergen: String = "",
        allergenSensitivities: [String: String] = [:]
    ) -> AllergenAnalysisResult {

        let normalized = normalize(text)

        guard !normalized.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return AllergenAnalysisResult(
                verdict: .uncertain,
                matchedUserAllergens: [],
                cautionAllergens: [],
                infoOnlyAllergens: [],
                allergenOutcomes: [],
                matchedEvidence: [],
                crossContactWarnings: [],
                infoFlags: ["No readable text found"],
                normalizedText: normalized,
                confidenceScore: 0.15
            )
        }

        let directText = extractDirectIngredientZone(from: normalized)
        let crossText  = extractCrossContactZone(from: normalized)

        var outcomes: [AllergenOutcome] = []
        var allEvidence: [String] = []
        var allCrossWarnings: [String] = []
        var infoFlags: [String] = []

        let customTrimmed = customAllergen.trimmingCharacters(in: .whitespacesAndNewlines)
        let allAllergens: [(name: String, isCustom: Bool)] =
            userAllergies.map { ($0, false) } +
            (customTrimmed.isEmpty ? [] : [(customTrimmed, true)])

        for (allergenName, isCustom) in allAllergens {
            let rawLevel = allergenSensitivities[allergenName] ?? "Strict"
            let level = SensitivityLevel(rawValue: rawLevel) ?? .strict

            let terms: [String] = isCustom
                ? [allergenName.lowercased()]
                : (allergenDictionary[allergenName] ?? [])

            if terms.isEmpty { continue }

            let freeFrom    = containsFreeFromClaim(for: allergenName, in: normalized, terms: terms)
            let directHit   = containsDirectContainsClaim(for: allergenName, in: normalized, terms: terms)

            var directEvidence: [String] = []
            var crossEvidence:  [String] = []

            for term in terms {
                if containsWholePhrase(term, in: directText) {
                    if !directEvidence.contains(term) { directEvidence.append(term) }
                }
            }
            if directEvidence.isEmpty && !directHit {
                for term in terms {
                    if containsWholePhrase(term, in: crossText) {
                        if !crossEvidence.contains(term) { crossEvidence.append(term) }
                    }
                }
            }

            let hasDirectMatch = !directEvidence.isEmpty || directHit
            let hasCrossMatch  = !crossEvidence.isEmpty

            if freeFrom {
                infoFlags.append("Free-from claim detected for \(allergenName)")
            }

            let allergenVerdict: ScanVerdict
            let isCrossContact: Bool

            switch level {
            case .strict:
                if hasDirectMatch {
                    allergenVerdict = .unsafe; isCrossContact = false
                } else if hasCrossMatch {
                    allergenVerdict = .caution; isCrossContact = true
                } else {
                    allergenVerdict = .looksClear; isCrossContact = false
                }
            case .moderate:
                if hasDirectMatch {
                    allergenVerdict = .unsafe; isCrossContact = false
                } else if hasCrossMatch {
                    allergenVerdict = .looksClear; isCrossContact = true
                    infoFlags.append("\(allergenName) — cross-contact noted (Moderate: not flagged as caution)")
                } else {
                    allergenVerdict = .looksClear; isCrossContact = false
                }
            case .informational:
                if hasDirectMatch || hasCrossMatch {
                    allergenVerdict = .looksClear
                    isCrossContact = hasCrossMatch && !hasDirectMatch
                    let matchType = hasDirectMatch ? "direct match" : "cross-contact"
                    infoFlags.append("\(allergenName) — \(matchType) detected (Informational: monitoring only)")
                } else {
                    allergenVerdict = .looksClear; isCrossContact = false
                }
            }

            let evidenceForAllergen = directEvidence + crossEvidence
            for e in evidenceForAllergen where !allEvidence.contains(e) {
                allEvidence.append(e)
            }

            if allergenVerdict == .caution {
                let w = "May contain or shared-facility risk involving \(allergenName)"
                if !allCrossWarnings.contains(w) { allCrossWarnings.append(w) }
            }
            if directHit && allergenVerdict == .unsafe {
                infoFlags.append("Direct contains statement detected for \(allergenName)")
            }

            if allergenVerdict != .looksClear || !evidenceForAllergen.isEmpty {
                outcomes.append(AllergenOutcome(
                    allergen: allergenName,
                    sensitivity: level.rawValue,
                    verdict: allergenVerdict,
                    evidence: evidenceForAllergen,
                    isCrossContact: isCrossContact
                ))
            }
        }

        // Global cross-contact phrases (only when strict/moderate allergens present)
        let hasStrictOrModerate = allAllergens.contains {
            let l = SensitivityLevel(rawValue: allergenSensitivities[$0.name] ?? "Strict") ?? .strict
            return l == .strict || l == .moderate
        }
        if hasStrictOrModerate {
            for phrase in crossContactPhrases where normalized.contains(phrase) && !allCrossWarnings.contains(phrase) {
                allCrossWarnings.append(phrase)
            }
        }

        let unsafeAllergens  = outcomes.filter { $0.verdict == .unsafe  }.map(\.allergen)
        let cautionAllergens = outcomes.filter { $0.verdict == .caution }.map(\.allergen)
        let infoAllergens    = outcomes.filter { $0.verdict == .looksClear && !$0.evidence.isEmpty }.map(\.allergen)

        let overallVerdict: ScanVerdict
        if !unsafeAllergens.isEmpty {
            overallVerdict = .unsafe
        } else if !cautionAllergens.isEmpty || !allCrossWarnings.isEmpty {
            overallVerdict = .caution
        } else {
            overallVerdict = .looksClear
        }

        return AllergenAnalysisResult(
            verdict: overallVerdict,
            matchedUserAllergens: unsafeAllergens,
            cautionAllergens: cautionAllergens,
            infoOnlyAllergens: infoAllergens,
            allergenOutcomes: outcomes,
            matchedEvidence: allEvidence,
            crossContactWarnings: allCrossWarnings,
            infoFlags: Array(Set(infoFlags)).sorted(),
            normalizedText: normalized,
            confidenceScore: calculateConfidence(
                normalizedText: normalized,
                matchedAllergens: unsafeAllergens,
                cautionAllergens: cautionAllergens,
                infoFlags: infoFlags
            )
        )
    }

    // MARK: - Helpers

    static func normalize(_ text: String) -> String {
        text.lowercased()
            .replacingOccurrences(of: "\n", with: " ")
            .replacingOccurrences(of: "\t", with: " ")
            .replacingOccurrences(of: ",",  with: " , ")
            .replacingOccurrences(of: ".",  with: " . ")
            .replacingOccurrences(of: "(",  with: " ")
            .replacingOccurrences(of: ")",  with: " ")
            .replacingOccurrences(of: ":",  with: " : ")
            .replacingOccurrences(of: ";",  with: " ; ")
            .replacingOccurrences(of: "/",  with: " / ")
            .components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }
            .joined(separator: " ")
    }

    static func extractDirectIngredientZone(from text: String) -> String {
        guard let range = text.range(of: "ingredients") else { return text }
        return String(text[range.lowerBound...])
    }

    static func extractCrossContactZone(from text: String) -> String {
        crossContactPhrases.compactMap { phrase -> String? in
            guard let range = text.range(of: phrase) else { return nil }
            return String(text[range.lowerBound...])
        }.joined(separator: " ")
    }

    static func containsWholePhrase(_ phrase: String, in text: String) -> Bool {
        let escaped = NSRegularExpression.escapedPattern(for: phrase.lowercased())
        let pattern = "(?<![a-z])" + escaped + "(?![a-z])"
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return false }
        return regex.firstMatch(in: text, range: NSRange(text.startIndex..., in: text)) != nil
    }

    static func containsDirectContainsClaim(for allergen: String, in text: String, terms: [String]) -> Bool {
        for leadIn in directContainsLeadIns {
            for term in terms where containsWholePhrase("\(leadIn) \(term)", in: text) { return true }
        }
        return containsWholePhrase("contains \(allergen.lowercased())", in: text)
    }

    static func containsFreeFromClaim(for allergen: String, in text: String, terms: [String]) -> Bool {
        let lowered = allergen.lowercased()
        for leadIn in freeFromLeadIns where containsWholePhrase("\(leadIn) \(lowered)", in: text) { return true }
        if containsWholePhrase("\(lowered) free", in: text) { return true }
        for term in terms where containsWholePhrase("free from \(term)", in: text) { return true }
        return false
    }

    static func calculateConfidence(
        normalizedText: String,
        matchedAllergens: [String],      // Unsafe — Strict direct matches
        cautionAllergens: [String],      // Caution — Strict cross-contact
        infoFlags: [String]
    ) -> Double {
        var score = 0.45

        // Text quality signals — independent of allergen matches
        if normalizedText.count > 40 { score += 0.10 }
        if normalizedText.contains("ingredients") { score += 0.15 }

        // Only Strict/Moderate matches that actually contributed to the
        // verdict boost the score. Informational matches are suppressed in
        // the verdict and must not inflate confidence either.
        if !matchedAllergens.isEmpty { score += 0.20 }
        if !cautionAllergens.isEmpty { score += 0.08 }

        // Direct "contains X" statement is strong evidence
        if infoFlags.contains(where: { $0.contains("Direct contains statement") }) {
            score += 0.10
        }

        return min(max(score, 0.0), 0.99)
    }
}
