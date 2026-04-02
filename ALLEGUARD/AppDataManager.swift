import Foundation
import SwiftData

@MainActor
final class AppDataManager {

    static func fetchOrCreateUserProfile(context: ModelContext) -> UserProfile {
        let descriptor = FetchDescriptor<UserProfile>()
        let profiles = (try? context.fetch(descriptor)) ?? []

        // Always return the first existing profile regardless of content.
        // The previous "meaningful profile" preference silently created a second
        // profile whenever the user cleared their allergies.
        if let existing = profiles.first {
            // Clean up any duplicate profiles that may have accumulated
            if profiles.count > 1 {
                profiles.dropFirst().forEach { context.delete($0) }
                saveContext(context)
            }
            return existing
        }

        let newProfile = UserProfile()
        context.insert(newProfile)
        saveContext(context)
        return newProfile
    }

    static func fetchOrCreatePrimaryEmergencyContact(context: ModelContext) -> EmergencyContactEntity {
        let descriptor = FetchDescriptor<EmergencyContactEntity>()
        let contacts = (try? context.fetch(descriptor)) ?? []

        // Prefer existing primary
        if let primary = contacts.first(where: { $0.isPrimary }) {
            return primary
        }

        // Fallback: first meaningful contact, mark it primary
        if let meaningful = contacts.first(where: {
            !$0.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
            !$0.phone.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }) {
            meaningful.isPrimary = true
            saveContext(context)
            return meaningful
        }

        if let existing = contacts.first {
            existing.isPrimary = true
            saveContext(context)
            return existing
        }

        let newContact = EmergencyContactEntity(isPrimary: true, sortOrder: 0)
        context.insert(newContact)
        saveContext(context)
        return newContact
    }

    static func fetchAllContacts(context: ModelContext) -> [EmergencyContactEntity] {
        let descriptor = FetchDescriptor<EmergencyContactEntity>(
            sortBy: [SortDescriptor(\.sortOrder)]
        )
        return (try? context.fetch(descriptor)) ?? []
    }

    static func saveContext(_ context: ModelContext) {
        do {
            try context.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
}
