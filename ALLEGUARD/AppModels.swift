import Foundation
import SwiftData

@Model
final class UserProfile {
    var name: String
    var allergies: [String]
    var customAllergen: String
    var sensitivityLevel: String                  // legacy global level — kept for migration
    var allergenSensitivities: [String: String]   // allergen name → SensitivityLevel.rawValue

    init(
        name: String = "",
        allergies: [String] = [],
        customAllergen: String = "",
        sensitivityLevel: String = "Strict",
        allergenSensitivities: [String: String] = [:]
    ) {
        self.name = name
        self.allergies = allergies
        self.customAllergen = customAllergen
        self.sensitivityLevel = sensitivityLevel
        self.allergenSensitivities = allergenSensitivities
    }
}

@Model
final class EmergencyContactEntity {
    var name: String
    var relationship: String
    var phone: String
    var notes: String
    var hasAsthmaHistory: Bool
    var isPrimary: Bool
    var sortOrder: Int

    init(
        name: String = "",
        relationship: String = "",
        phone: String = "",
        notes: String = "",
        hasAsthmaHistory: Bool = false,
        isPrimary: Bool = false,
        sortOrder: Int = 0
    ) {
        self.name = name
        self.relationship = relationship
        self.phone = phone
        self.notes = notes
        self.hasAsthmaHistory = hasAsthmaHistory
        self.isPrimary = isPrimary
        self.sortOrder = sortOrder
    }
}
