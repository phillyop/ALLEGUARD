import Foundation
import SwiftUI

// MARK: - Reaction level (symptom log)

enum ReactionLevel: String, CaseIterable, Identifiable, Codable {
    case noReaction = "No reaction"
    case mild       = "Mild"
    case serious    = "Serious"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .noReaction: return "checkmark.circle.fill"
        case .mild:       return "exclamationmark.circle.fill"
        case .serious:    return "exclamationmark.triangle.fill"
        }
    }

    var color: Color {
        switch self {
        case .noReaction: return Color(red: 0.07, green: 0.64, blue: 0.29)
        case .mild:       return Color(red: 0.85, green: 0.47, blue: 0.03)
        case .serious:    return Color(red: 0.86, green: 0.15, blue: 0.15)
        }
    }

    var softColor: Color {
        switch self {
        case .noReaction: return Color(UIColor { t in t.userInterfaceStyle == .dark
            ? UIColor(red: 0.06, green: 0.20, blue: 0.10, alpha: 1) : UIColor(red: 0.90, green: 0.97, blue: 0.93, alpha: 1) })
        case .mild:       return Color(UIColor { t in t.userInterfaceStyle == .dark
            ? UIColor(red: 0.24, green: 0.16, blue: 0.04, alpha: 1) : UIColor(red: 1.00, green: 0.95, blue: 0.86, alpha: 1) })
        case .serious:    return Color(UIColor { t in t.userInterfaceStyle == .dark
            ? UIColor(red: 0.24, green: 0.08, blue: 0.08, alpha: 1) : UIColor(red: 0.99, green: 0.91, blue: 0.91, alpha: 1) })
        }
    }

    var description: String {
        switch self {
        case .noReaction: return "I ate this and felt fine."
        case .mild:       return "Minor symptoms — itching, discomfort, or stomach upset."
        case .serious:    return "Significant reaction — swelling, breathing difficulty, or severe symptoms."
        }
    }
}



enum ScanVerdict: String, CaseIterable, Codable {
    case unsafe     = "Unsafe"
    case caution    = "Caution"
    case looksClear = "Looks Clear"
    case uncertain  = "Uncertain"

    var color: Color {
        switch self {
        case .unsafe:     return Color(red: 0.86, green: 0.15, blue: 0.15)
        case .caution:    return Color(red: 0.85, green: 0.47, blue: 0.03)
        case .looksClear: return Color(red: 0.07, green: 0.64, blue: 0.29)
        case .uncertain:  return Color(UIColor.secondaryLabel)
        }
    }

    var icon: String {
        switch self {
        case .unsafe:     return "xmark.shield.fill"
        case .caution:    return "exclamationmark.triangle.fill"
        case .looksClear: return "checkmark.shield.fill"
        case .uncertain:  return "questionmark.circle.fill"
        }
    }
}

// MARK: - Sensitivity level

enum SensitivityLevel: String, CaseIterable, Identifiable {
    case strict        = "Strict"
    case moderate      = "Moderate"
    case informational = "Informational"
    var id: String { rawValue }
}

// MARK: - Analysis result types

struct AllergenOutcome {
    let allergen: String
    let sensitivity: String   // SensitivityLevel.rawValue
    let verdict: ScanVerdict
    let evidence: [String]
    let isCrossContact: Bool
}

struct AllergenAnalysisResult {
    let verdict: ScanVerdict
    let matchedUserAllergens: [String]
    let cautionAllergens: [String]
    let infoOnlyAllergens: [String]
    let allergenOutcomes: [AllergenOutcome]
    let matchedEvidence: [String]
    let crossContactWarnings: [String]
    let infoFlags: [String]
    let normalizedText: String
    let confidenceScore: Double
}
