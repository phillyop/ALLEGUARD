import Foundation
import SwiftData

@Model
final class ScanRecord {
    var createdAt: Date
    var extractedText: String
    var normalizedText: String
    var verdictRawValue: String
    var matchedAllergens: [String]       // Unsafe allergens
    var cautionAllergens: [String]       // Cross-contact allergens (Strict sensitivity)
    var infoOnlyAllergens: [String]      // Suppressed by Informational/Moderate sensitivity
    var matchedEvidence: [String]
    var crossContactWarnings: [String]
    var infoFlags: [String]
    var confidenceScore: Double
    var reactionRawValue: String         // ReactionLevel.rawValue, "" = not yet logged

    init(
        createdAt: Date = Date(),
        extractedText: String = "",
        normalizedText: String = "",
        verdictRawValue: String = "Uncertain",
        matchedAllergens: [String] = [],
        cautionAllergens: [String] = [],
        infoOnlyAllergens: [String] = [],
        matchedEvidence: [String] = [],
        crossContactWarnings: [String] = [],
        infoFlags: [String] = [],
        confidenceScore: Double = 0.0,
        reactionRawValue: String = ""
    ) {
        self.createdAt = createdAt
        self.extractedText = extractedText
        self.normalizedText = normalizedText
        self.verdictRawValue = verdictRawValue
        self.matchedAllergens = matchedAllergens
        self.cautionAllergens = cautionAllergens
        self.infoOnlyAllergens = infoOnlyAllergens
        self.matchedEvidence = matchedEvidence
        self.crossContactWarnings = crossContactWarnings
        self.infoFlags = infoFlags
        self.confidenceScore = confidenceScore
        self.reactionRawValue = reactionRawValue
    }

    var verdict: ScanVerdict {
        ScanVerdict(rawValue: verdictRawValue) ?? .uncertain
    }

    /// nil means the user hasn't logged a reaction yet
    var reaction: ReactionLevel? {
        ReactionLevel(rawValue: reactionRawValue)
    }
}
