import SwiftUI

struct MainAppView: View {
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor { trait in
            trait.userInterfaceStyle == .dark
                ? UIColor(red: 0.07, green: 0.07, blue: 0.09, alpha: 0.97)
                : UIColor(red: 0.98, green: 0.98, blue: 0.99, alpha: 0.95)
        }
        appearance.shadowColor = UIColor { trait in
            trait.userInterfaceStyle == .dark
                ? UIColor.white.withAlphaComponent(0.05)
                : UIColor.black.withAlphaComponent(0.05)
        }

        let normal = UIColor { trait in
            trait.userInterfaceStyle == .dark ? UIColor.systemGray : UIColor.systemGray2
        }
        let selected = UIColor { _ in UIColor(red: 0.10, green: 0.40, blue: 0.90, alpha: 1.0) }

        appearance.stackedLayoutAppearance.normal.iconColor = normal
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: normal,
            .font: UIFont.systemFont(ofSize: 10, weight: .medium)
        ]
        appearance.stackedLayoutAppearance.selected.iconColor = selected
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: selected,
            .font: UIFont.systemFont(ofSize: 10, weight: .semibold)
        ]

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }

    @EnvironmentObject var scanSession: ScanSessionStore

    var body: some View {
        TabView(selection: $scanSession.selectedTab) {
            NavigationStack {
                HomeDashboardView()
            }
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }
            .tag(0)

            NavigationStack {
                LiveScanView()
            }
            .tabItem {
                Image(systemName: "viewfinder")
                Text("Scan")
            }
            .tag(1)

            NavigationStack {
                HistoryView()
            }
            .tabItem {
                Image(systemName: "clock.fill")
                Text("History")
            }
            .tag(2)

            NavigationStack {
                ProfileSettingsView()
            }
            .tabItem {
                Image(systemName: "person.fill")
                Text("Profile")
            }
            .tag(3)
        }
        .tint(AGColor.primary)
    }
}
