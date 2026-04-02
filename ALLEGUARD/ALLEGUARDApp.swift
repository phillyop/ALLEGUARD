import SwiftUI
import SwiftData

@main
struct ALLEGUARDApp: App {
    @State private var scanSession = ScanSessionStore()
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    // Build a ModelContainer that destroys and recreates the store when the
    // schema has changed and SwiftData cannot auto-migrate.
    // Correct for dev-stage apps. Production apps should use VersionedSchema + MigrationPlan.
    static let sharedContainer: ModelContainer = {
        let schema = Schema([
            UserProfile.self,
            EmergencyContactEntity.self,
            ScanRecord.self
        ])
        let storeURL = URL.applicationSupportDirectory
            .appendingPathComponent("default.store")
        let config = ModelConfiguration(
            url: storeURL,
            allowsSave: true
        )
        do {
            return try ModelContainer(for: schema, configurations: [config])
        } catch {
            print("⚠️ SwiftData schema migration failed (\(error)). Wiping store and recreating.")
            let fm = FileManager.default
            // Remove all SQLite side-car files
            for ext in ["store", "store-shm", "store-wal"] {
                let url = URL.applicationSupportDirectory
                    .appendingPathComponent("default.\(ext)")
                if fm.fileExists(atPath: url.path) {
                    try? fm.removeItem(at: url)
                }
            }
            do {
                return try ModelContainer(for: schema, configurations: [config])
            } catch {
                fatalError("Cannot create ModelContainer after store wipe: \(error)")
            }
        }
    }()

    var body: some Scene {
        WindowGroup {
            if hasCompletedOnboarding {
                MainAppView()
                    .environmentObject(scanSession)
            } else {
                OnboardingFlowView(hasCompletedOnboarding: $hasCompletedOnboarding)
            }
        }
        .modelContainer(ALLEGUARDApp.sharedContainer)
    }
}
