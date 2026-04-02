import SwiftUI
import SwiftData
import PhotosUI
import AVFoundation
import UserNotifications

// MARK: - Theme

enum AGColor {
    // Backgrounds
    static let bg = Color(uiColor: UIColor { trait in
        trait.userInterfaceStyle == .dark
            ? UIColor(red: 0.06, green: 0.06, blue: 0.08, alpha: 1.0)
            : UIColor(red: 0.95, green: 0.96, blue: 0.98, alpha: 1.0)
    })
    static let card = Color(uiColor: UIColor { trait in
        trait.userInterfaceStyle == .dark
            ? UIColor(red: 0.11, green: 0.11, blue: 0.14, alpha: 1.0)
            : UIColor.white
    })
    static let cardSoft = Color(uiColor: .tertiarySystemBackground)
    static let scanBg = Color(red: 0.04, green: 0.04, blue: 0.07)

    // Brand
    static let primary = Color(red: 0.10, green: 0.40, blue: 0.90)
    static let primaryDark = Color(red: 0.07, green: 0.28, blue: 0.66)
    static let primarySoft = Color(uiColor: UIColor { trait in
        trait.userInterfaceStyle == .dark
            ? UIColor(red: 0.08, green: 0.16, blue: 0.30, alpha: 1.0)
            : UIColor(red: 0.91, green: 0.95, blue: 1.00, alpha: 1.0)
    })

    // Semantic
    static let success = Color(red: 0.07, green: 0.64, blue: 0.29)
    static let successSoft = Color(uiColor: UIColor { trait in
        trait.userInterfaceStyle == .dark
            ? UIColor(red: 0.06, green: 0.20, blue: 0.10, alpha: 1.0)
            : UIColor(red: 0.90, green: 0.97, blue: 0.93, alpha: 1.0)
    })
    static let warning = Color(red: 0.85, green: 0.47, blue: 0.03)
    static let warningSoft = Color(uiColor: UIColor { trait in
        trait.userInterfaceStyle == .dark
            ? UIColor(red: 0.24, green: 0.16, blue: 0.04, alpha: 1.0)
            : UIColor(red: 1.00, green: 0.95, blue: 0.86, alpha: 1.0)
    })
    static let danger = Color(red: 0.86, green: 0.15, blue: 0.15)
    static let dangerSoft = Color(uiColor: UIColor { trait in
        trait.userInterfaceStyle == .dark
            ? UIColor(red: 0.24, green: 0.08, blue: 0.08, alpha: 1.0)
            : UIColor(red: 0.99, green: 0.91, blue: 0.91, alpha: 1.0)
    })

    // Text
    static let darkText = Color(uiColor: .label)
    static let bodyText = Color(uiColor: .label)
    static let neutral = Color(uiColor: .secondaryLabel)
    static let hint = Color(uiColor: .tertiaryLabel)

    // Structural
    static let border = Color(uiColor: UIColor { trait in
        trait.userInterfaceStyle == .dark
            ? UIColor.white.withAlphaComponent(0.09)
            : UIColor.black.withAlphaComponent(0.07)
    })
    static let shadow = Color.black.opacity(0.08)
}

// MARK: - Models

struct AllergyOption: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let icon: String
}

struct EmergencyContact: Identifiable {
    let id = UUID()
    var name: String
    var relationship: String
    var phone: String
}

struct ScanHistoryItem: Identifiable {
    let id = UUID()
    var title: String
    var date: String
    var verdict: ScanVerdict
}

// MARK: - Sample Data

let allergyOptions: [AllergyOption] = [
    .init(name: "Milk", icon: "drop.fill"),
    .init(name: "Egg", icon: "circle.hexagongrid.fill"),
    .init(name: "Fish", icon: "fish.fill"),
    .init(name: "Shellfish", icon: "tortoise.fill"),
    .init(name: "Tree Nuts", icon: "leaf.fill"),
    .init(name: "Peanuts", icon: "bolt.fill"),
    .init(name: "Wheat", icon: "circle.grid.cross.fill"),
    .init(name: "Soy", icon: "square.grid.2x2.fill"),
    .init(name: "Sesame", icon: "seal.fill")
]

// MARK: - App Entry Demo

struct AllerGuardScreensDemoAppView: View {
    var body: some View {
        NavigationStack {
            ScreenMenuView()
        }
    }
}

// MARK: - Screen Menu

struct ScreenMenuView: View {
    var body: some View {
        List {
            Section("Core Screens") {
                NavigationLink("Splash") { SplashScreenView() }
                NavigationLink("Onboarding") { OnboardingPagerView() }
                NavigationLink("Allergy Setup") { AllergySetupView() }
                NavigationLink("Emergency Setup") { EmergencySetupView() }
                NavigationLink("Permissions") { PermissionsView() }
                NavigationLink("Home Dashboard") { HomeDashboardView() }
                NavigationLink("Live Scan") { LiveScanView() }
                NavigationLink("OCR Review") { OCRReviewView() }
                NavigationLink("Result") { ScanResultView() }
                NavigationLink("Product Lookup") { ProductLookupView() }
                NavigationLink("History") { HistoryView() }
                NavigationLink("Emergency Help") { EmergencyHelpView() }
                NavigationLink("Profile & Settings") { ProfileSettingsView() }
            }
        }
        .navigationTitle("AllerGuard iOS")
    }
}

// MARK: - Reusable Components

struct AGPrimaryButton: View {
    let title: String
    var icon: String? = nil
    var action: () -> Void = {}

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let icon {
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .semibold))
                }
                Text(title)
                    .font(.system(size: 17, weight: .semibold))
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(AGColor.primary)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}

struct CircleActionButton: View {
    let icon: String
    var size: CGFloat = 60
    var action: () -> Void = {}

    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: size * 0.32, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: size, height: size)
                .background(Color.white.opacity(0.12))
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white.opacity(0.16), lineWidth: 1))
        }
        .buttonStyle(.plain)
    }
}

struct AGSecondaryButton: View {
    let title: String
    var action: () -> Void = {}

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(AGColor.darkText)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 15)
                .background(AGColor.card)
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(AGColor.border, lineWidth: 1)
                )
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}

struct AGCard<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(18)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(AGColor.card)
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(AGColor.border, lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

// Compact label chip
struct AGSmallChip: View {
    let title: String
    var color: Color = AGColor.primary
    var softColor: Color = AGColor.primarySoft

    var body: some View {
        Text(title)
            .font(.system(size: 13, weight: .semibold))
            .foregroundStyle(color)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(softColor)
            .clipShape(Capsule())
    }
}

// Large selectable allergy chip
struct PillChip: View {
    let title: String
    let selected: Bool

    var body: some View {
        Text(title)
            .font(.system(size: 15, weight: .semibold))
            .foregroundStyle(selected ? .white : AGColor.darkText)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(selected ? AGColor.primary : AGColor.card)
            .overlay(
                Capsule()
                    .stroke(selected ? AGColor.primary : AGColor.border, lineWidth: 1)
            )
            .clipShape(Capsule())
    }
}

// Full-width verdict card with built-in confidence bar
struct AGVerdictCard: View {
    let verdict: ScanVerdict
    let detail: String
    var confidenceScore: Double? = nil

    private var bg: Color {
        switch verdict {
        case .unsafe:     return AGColor.danger
        case .caution:    return AGColor.warning
        case .looksClear: return AGColor.success
        case .uncertain:  return AGColor.neutral
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top, spacing: 14) {
                Image(systemName: verdict.icon)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(.white)

                VStack(alignment: .leading, spacing: 4) {
                    Text(verdict.rawValue)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(.white)
                    Text(detail)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.white.opacity(0.88))
                        .lineSpacing(2)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer()
            }
            .padding(20)

            if let score = confidenceScore {
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text("Confidence")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(.white.opacity(0.7))
                        Spacer()
                        Text("\(Int(score * 100))%")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(.white)
                    }
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 3)
                                .fill(Color.white.opacity(0.2))
                                .frame(height: 5)
                            RoundedRectangle(cornerRadius: 3)
                                .fill(Color.white.opacity(0.85))
                                .frame(width: geo.size.width * score, height: 5)
                        }
                    }
                    .frame(height: 5)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 18)
            }
        }
        .background(bg)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

// Legacy banner kept for EmergencyHelpView
struct VerdictBanner: View {
    let verdict: ScanVerdict
    let detail: String

    private var backgroundColor: Color {
        switch verdict {
        case .unsafe:     return AGColor.danger
        case .caution:    return AGColor.warning
        case .looksClear: return AGColor.success
        case .uncertain:  return AGColor.neutral
        }
    }

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: verdict.icon)
                .font(.system(size: 22, weight: .bold))
            VStack(alignment: .leading, spacing: 6) {
                Text(verdict.rawValue)
                    .font(.system(size: 20, weight: .bold))
                Text(detail)
                    .font(.system(size: 15, weight: .medium))
                    .opacity(0.92)
                    .lineSpacing(2)
            }
            Spacer()
        }
        .foregroundStyle(.white)
        .padding(18)
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

enum ToastStyle {
    case success, warning, info

    var backgroundColor: Color {
        switch self {
        case .success: return AGColor.success
        case .warning: return AGColor.warning
        case .info:    return AGColor.primary
        }
    }
    var icon: String {
        switch self {
        case .success: return "checkmark.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .info:    return "info.circle.fill"
        }
    }
}

struct AGToastBanner: View {
    let message: String
    let style: ToastStyle

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: style.icon)
                .font(.system(size: 16, weight: .bold))
            Text(message)
                .font(.system(size: 15, weight: .semibold))
                .lineLimit(2)
            Spacer()
        }
        .foregroundStyle(.white)
        .padding(.horizontal, 16)
        .padding(.vertical, 13)
        .background(style.backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

struct AGTextFieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 16, weight: .medium))
            .foregroundStyle(AGColor.darkText)
            .padding(.horizontal, 16)
            .padding(.vertical, 15)
            .background(AGColor.cardSoft)
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(AGColor.border, lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}

extension View {
    func agTextFieldStyle() -> some View {
        modifier(AGTextFieldStyle())
    }
}

// Premium settings row with icon pill
struct AGSettingsRow: View {
    let title: String
    let icon: String
    var iconColor: Color = AGColor.primary
    var iconBg: Color = AGColor.primarySoft
    var detail: String? = nil
    var dangerous: Bool = false

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(dangerous ? AGColor.danger : iconColor)
                .frame(width: 32, height: 32)
                .background(dangerous ? AGColor.dangerSoft : iconBg)
                .clipShape(RoundedRectangle(cornerRadius: 9, style: .continuous))

            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(dangerous ? AGColor.danger : AGColor.darkText)

            Spacer()

            if let detail {
                Text(detail)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(AGColor.neutral)
            }

            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(AGColor.hint)
        }
        .padding(.vertical, 11)
    }
}

// Legacy SettingsRow
struct SettingsRow: View {
    let title: String
    let icon: String

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(AGColor.primary)
                .frame(width: 28)
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(AGColor.darkText)
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(AGColor.neutral)
        }
        .padding(.vertical, 12)
    }
}

struct QuickActionCard: View {
    let icon: String
    let title: String
    let subtitle: String
    var accentColor: Color = AGColor.primary
    var accentSoft: Color = AGColor.primarySoft

    var body: some View {
        AGCard {
            VStack(alignment: .leading, spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(accentColor)
                    .frame(width: 44, height: 44)
                    .background(accentSoft)
                    .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))

                Spacer(minLength: 4)

                Text(title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(AGColor.darkText)

                Text(subtitle)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(AGColor.neutral)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 140)
        }
    }
}

struct AGSectionHeader: View {
    let title: String

    var body: some View {
        Text(title.uppercased())
            .font(.system(size: 11, weight: .semibold))
            .tracking(0.7)
            .foregroundStyle(AGColor.neutral)
            .padding(.top, 4)
    }
}

struct FlexibleChipLayout: View {
    let items: [(String, Bool)]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            let rows = createRows(items: items, maxPerRow: 3)
            ForEach(Array(rows.enumerated()), id: \.offset) { _, row in
                HStack(spacing: 8) {
                    ForEach(row, id: \.0) { item in
                        PillChip(title: item.0, selected: item.1)
                    }
                    Spacer(minLength: 0)
                }
            }
        }
    }

    private func createRows(items: [(String, Bool)], maxPerRow: Int) -> [[(String, Bool)]] {
        stride(from: 0, to: items.count, by: maxPerRow).map {
            Array(items[$0..<min($0 + maxPerRow, items.count)])
        }
    }
}

struct AGScanHelperCard: View {
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.white)
            Text(subtitle)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(.white.opacity(0.65))
                .lineSpacing(2)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.08))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(Color.white.opacity(0.10), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}

// Step progress bar for scan flow
struct AGStepProgress: View {
    let total: Int
    let current: Int

    var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<total, id: \.self) { i in
                Capsule()
                    .fill(i < current ? AGColor.primary : AGColor.border)
                    .frame(width: i < current ? 22 : 8, height: 5)
                    .animation(.spring(response: 0.3), value: current)
            }
        }
    }
}

// SectionTitle kept for onboarding screens
struct SectionTitle: View {
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 26, weight: .bold))
                .tracking(-0.4)
                .foregroundStyle(AGColor.darkText)
            Text(subtitle)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(AGColor.neutral)
                .lineSpacing(2)
        }
    }
}


// MARK: - Onboarding Flow Container

enum OnboardingStep {
    case splash, pager, allergySetup, emergencySetup, permissions
}

struct OnboardingFlowView: View {
    @Binding var hasCompletedOnboarding: Bool
    @State private var step: OnboardingStep = .splash

    var body: some View {
        ZStack {
            switch step {
            case .splash:
                SplashScreenView(onFinished: { step = .pager })
                    .transition(.opacity)
            case .pager:
                NavigationStack {
                    OnboardingPagerView(onGetStarted: { step = .allergySetup })
                }
                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
            case .allergySetup:
                NavigationStack {
                    AllergySetupView(onboardingMode: true, onContinue: { step = .emergencySetup })
                }
                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
            case .emergencySetup:
                NavigationStack {
                    EmergencySetupView(onboardingMode: true, onContinue: { step = .permissions })
                }
                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
            case .permissions:
                NavigationStack {
                    PermissionsView(onComplete: { hasCompletedOnboarding = true })
                }
                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
            }
        }
        .animation(.easeInOut(duration: 0.35), value: step)
    }
}

// MARK: - 1 Splash

struct SplashScreenView: View {
    var onFinished: (() -> Void)? = nil

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [AGColor.primary, Color(red: 0.06, green: 0.24, blue: 0.56)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 18) {
                Image(systemName: "shield.lefthalf.filled.badge.checkmark")
                    .font(.system(size: 66, weight: .bold))
                    .foregroundStyle(.white)

                Text("AllerGuard")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundStyle(.white)

                Text("Scan smarter. Eat safer.")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(.white.opacity(0.92))

                ProgressView()
                    .tint(.white)
                    .padding(.top, 12)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            guard let onFinished else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                onFinished()
            }
        }
    }
}

// MARK: - 2 Onboarding

struct OnboardingPage: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let icon: String
}

struct OnboardingPagerView: View {
    var onGetStarted: (() -> Void)? = nil

    private let pages: [OnboardingPage] = [
        .init(title: "Scan labels fast", subtitle: "Use your camera to capture ingredient panels in seconds.", icon: "camera.viewfinder"),
        .init(title: "Detect what matters", subtitle: "Match ingredients against your own allergy profile.", icon: "text.magnifyingglass"),
        .init(title: "Get help quickly", subtitle: "Save emergency contacts and act fast when needed.", icon: "phone.badge.plus")
    ]

    @State private var index = 0

    var body: some View {
        ZStack {
            AGColor.bg.ignoresSafeArea()

            VStack(spacing: 26) {
                Spacer()

                TabView(selection: $index) {
                    ForEach(Array(pages.enumerated()), id: \.offset) { offset, page in
                        VStack(spacing: 24) {
                            Image(systemName: page.icon)
                                .font(.system(size: 56))
                                .foregroundStyle(AGColor.primary)
                                .frame(width: 120, height: 120)
                                .background(AGColor.primarySoft)
                                .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))

                            Text(page.title)
                                .font(.system(size: 30, weight: .bold))
                                .multilineTextAlignment(.center)
                                .foregroundStyle(AGColor.darkText)

                            Text(page.subtitle)
                                .font(.system(size: 17, weight: .medium))
                                .foregroundStyle(AGColor.neutral)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 28)
                        }
                        .tag(offset)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .frame(height: 420)

                VStack(spacing: 12) {
                    AGPrimaryButton(title: index == pages.count - 1 ? "Get Started" : "Continue", icon: "arrow.right") {
                        if index < pages.count - 1 {
                            index += 1
                        } else {
                            onGetStarted?()
                        }
                    }
                    if let onGetStarted {
                        AGSecondaryButton(title: "Skip setup") {
                            onGetStarted()
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 28)
            }
        }
        .navigationTitle("Welcome")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - 3 Allergy Setup

struct AllergySetupView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    var onboardingMode: Bool = false
    var onContinue: (() -> Void)? = nil

    @State private var name = ""
    @State private var selected = Set<String>()
    @State private var customAllergen = ""
    @State private var sensitivities: [String: SensitivityLevel] = [:]  // per-allergen
    @State private var customSensitivity: SensitivityLevel = .strict
    @State private var didLoad = false
    @State private var profile: UserProfile?

    @State private var showToast = false
    @State private var toastMessage = ""

    let columns = [GridItem(.flexible()), GridItem(.flexible())]

    // Allergens currently selected, sorted for stable display
    private var selectedSorted: [String] {
        allergyOptions.map(\.name).filter { selected.contains($0) }
    }

    var body: some View {
        ZStack(alignment: .top) {
            AGColor.bg.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    SectionTitle(
                        title: "Set your allergies",
                        subtitle: "Select your allergens, then set a sensitivity level for each one."
                    )

                    // Name — onboarding only
                    if onboardingMode {
                        AGCard {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Your name")
                                    .font(.headline)
                                    .foregroundStyle(AGColor.darkText)
                                TextField("Full name", text: $name)
                                    .agTextFieldStyle()
                                Text("Used to personalise the app. Optional.")
                                    .font(.footnote)
                                    .foregroundStyle(AGColor.neutral)
                            }
                        }
                    }

                    // Step 1 — pick allergens
                    AGCard {
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("Step 1 — Select allergens")
                                    .font(.headline)
                                    .foregroundStyle(AGColor.darkText)
                                Spacer()
                                if !selected.isEmpty {
                                    Text("\(selected.count) selected")
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundStyle(AGColor.primary)
                                }
                            }

                            LazyVGrid(columns: columns, spacing: 10) {
                                ForEach(allergyOptions) { option in
                                    Button {
                                        if selected.contains(option.name) {
                                            selected.remove(option.name)
                                            sensitivities.removeValue(forKey: option.name)
                                        } else {
                                            selected.insert(option.name)
                                            if sensitivities[option.name] == nil {
                                                sensitivities[option.name] = .strict
                                            }
                                        }
                                    } label: {
                                        HStack(spacing: 8) {
                                            Image(systemName: option.icon)
                                                .font(.system(size: 14, weight: .semibold))
                                            Text(option.name)
                                                .font(.system(size: 15, weight: .semibold))
                                            Spacer()
                                            if selected.contains(option.name) {
                                                Image(systemName: "checkmark")
                                                    .font(.system(size: 11, weight: .bold))
                                            }
                                        }
                                        .foregroundStyle(selected.contains(option.name) ? .white : AGColor.darkText)
                                        .padding(.horizontal, 14)
                                        .padding(.vertical, 14)
                                        .background(selected.contains(option.name) ? AGColor.primary : AGColor.cardSoft)
                                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                    }

                    // Custom allergen
                    AGCard {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Custom allergen")
                                .font(.headline)
                                .foregroundStyle(AGColor.darkText)
                            TextField("e.g. mustard, celery, lupin", text: $customAllergen)
                                .agTextFieldStyle()
                                .onChange(of: customAllergen) {
                                    // ensure sensitivity is set when user types
                                }
                        }
                    }

                    // Step 2 — per-allergen sensitivity (only shown once ≥1 allergen selected)
                    if !selectedSorted.isEmpty || !customAllergen.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            AGCard {
                                VStack(alignment: .leading, spacing: 0) {
                                    HStack {
                                        Text("Step 2 — Set sensitivity per allergen")
                                            .font(.headline)
                                            .foregroundStyle(AGColor.darkText)
                                        Spacer()
                                    }
                                    .padding(.bottom, 14)

                                    Text("Strict = any trace flagged · Moderate = direct match only · Informational = note only")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundStyle(AGColor.neutral)
                                        .padding(.bottom, 16)

                                    // Selected major allergens
                                    ForEach(selectedSorted, id: \.self) { allergen in
                                        AllergenSensitivityRow(
                                            allergen: allergen,
                                            sensitivity: Binding(
                                                get: { sensitivities[allergen] ?? .strict },
                                                set: { sensitivities[allergen] = $0 }
                                            )
                                        )
                                        if allergen != selectedSorted.last || !customAllergen.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                            Divider().overlay(AGColor.border)
                                        }
                                    }

                                    // Custom allergen row
                                    let trimmed = customAllergen.trimmingCharacters(in: .whitespacesAndNewlines)
                                    if !trimmed.isEmpty {
                                        AllergenSensitivityRow(
                                            allergen: trimmed.isEmpty ? "Custom" : trimmed,
                                            sensitivity: $customSensitivity
                                        )
                                    }
                                }
                            }
                        }
                    }

                    AGPrimaryButton(
                        title: onboardingMode ? "Save & Continue" : "Save Allergy Profile",
                        icon: onboardingMode ? "arrow.right" : "checkmark"
                    ) {
                        saveProfile()
                    }

                    if onboardingMode {
                        AGSecondaryButton(title: "Skip for now") {
                            onContinue?()
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 28)
            }

            if showToast {
                AGToastBanner(message: toastMessage, style: .success)
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .navigationTitle("Allergy Setup")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { loadProfileIfNeeded() }
        .animation(.easeInOut(duration: 0.25), value: showToast)
    }

    private func loadProfileIfNeeded() {
        guard !didLoad else { return }
        let p = AppDataManager.fetchOrCreateUserProfile(context: modelContext)
        profile = p
        name = p.name
        selected = Set(p.allergies)
        customAllergen = p.customAllergen

        // Load per-allergen sensitivities; fall back to global level for legacy data
        let fallback = SensitivityLevel(rawValue: p.sensitivityLevel) ?? .strict
        for allergen in p.allergies {
            let raw = p.allergenSensitivities[allergen]
            sensitivities[allergen] = SensitivityLevel(rawValue: raw ?? "") ?? fallback
        }
        let customTrimmed = p.customAllergen.trimmingCharacters(in: .whitespacesAndNewlines)
        if !customTrimmed.isEmpty {
            let raw = p.allergenSensitivities[customTrimmed]
            customSensitivity = SensitivityLevel(rawValue: raw ?? "") ?? fallback
        }
        didLoad = true
    }

    private func saveProfile() {
        guard let profile else { return }

        profile.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        profile.allergies = Array(selected).sorted()
        let customTrimmed = customAllergen.trimmingCharacters(in: .whitespacesAndNewlines)
        profile.customAllergen = customTrimmed

        // Build sensitivity dict
        var dict: [String: String] = [:]
        for allergen in selected {
            dict[allergen] = (sensitivities[allergen] ?? .strict).rawValue
        }
        if !customTrimmed.isEmpty {
            dict[customTrimmed] = customSensitivity.rawValue
        }
        profile.allergenSensitivities = dict

        // Keep legacy global level as the strictest selected
        let allLevels = dict.values.compactMap { SensitivityLevel(rawValue: $0) }
        if allLevels.contains(.strict) { profile.sensitivityLevel = SensitivityLevel.strict.rawValue }
        else if allLevels.contains(.moderate) { profile.sensitivityLevel = SensitivityLevel.moderate.rawValue }
        else if !allLevels.isEmpty { profile.sensitivityLevel = SensitivityLevel.informational.rawValue }

        AppDataManager.saveContext(modelContext)
        toastMessage = onboardingMode ? "Allergies saved!" : "Allergy profile saved"
        showToast = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
            if onboardingMode { onContinue?() } else { dismiss() }
        }
    }
}

// Single row: allergen name + segmented sensitivity picker
struct AllergenSensitivityRow: View {
    let allergen: String
    @Binding var sensitivity: SensitivityLevel

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(allergen)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(AGColor.darkText)
                Spacer()
                sensitivityBadge(sensitivity)
            }
            Picker("", selection: $sensitivity) {
                ForEach(SensitivityLevel.allCases) { level in
                    Text(level.rawValue).tag(level)
                }
            }
            .pickerStyle(.segmented)
        }
        .padding(.vertical, 12)
    }

    @ViewBuilder
    private func sensitivityBadge(_ level: SensitivityLevel) -> some View {
        let (color, soft): (Color, Color) = {
            switch level {
            case .strict:        return (AGColor.danger,  AGColor.dangerSoft)
            case .moderate:      return (AGColor.warning, AGColor.warningSoft)
            case .informational: return (AGColor.primary, AGColor.primarySoft)
            }
        }()
        AGSmallChip(title: level.rawValue, color: color, softColor: soft)
    }
}

// MARK: - 4 Emergency Setup

struct EmergencySetupView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    var onboardingMode: Bool = false
    var onContinue: (() -> Void)? = nil

    @State private var contacts: [EmergencyContactEntity] = []
    @State private var editingContact: EmergencyContactEntity? = nil
    @State private var showAddSheet = false
    @State private var didLoad = false
    @State private var showToast = false
    @State private var deleteTarget: EmergencyContactEntity? = nil
    @State private var showDeleteAlert = false

    var body: some View {
        ZStack(alignment: .top) {
            AGColor.bg.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    SectionTitle(
                        title: "Emergency support",
                        subtitle: "Add trusted contacts who can be called during a reaction. The first is your primary."
                    )

                    // Contact list
                    if contacts.isEmpty {
                        AGCard {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("No contacts saved yet")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundStyle(AGColor.darkText)
                                Text("Add at least one person who can help you quickly during an allergic reaction.")
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundStyle(AGColor.neutral)
                                    .lineSpacing(2)
                            }
                        }
                    } else {
                        VStack(spacing: 10) {
                            ForEach(Array(contacts.enumerated()), id: \.element.persistentModelID) { index, contact in
                                ContactRowCard(
                                    contact: contact,
                                    isPrimary: index == 0,
                                    onEdit: { editingContact = contact },
                                    onDelete: {
                                        deleteTarget = contact
                                        showDeleteAlert = true
                                    }
                                )
                            }
                        }
                    }

                    // Add contact button
                    Button {
                        showAddSheet = true
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 16, weight: .semibold))
                            Text("Add emergency contact")
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .foregroundStyle(AGColor.primary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .background(AGColor.primarySoft)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .stroke(AGColor.primary.opacity(0.25), lineWidth: 1)
                        )
                    }
                    .buttonStyle(.plain)

                    if onboardingMode {
                        AGPrimaryButton(
                            title: contacts.isEmpty ? "Skip for now" : "Save & Continue",
                            icon: "arrow.right"
                        ) {
                            onContinue?()
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 28)
            }

            if showToast {
                AGToastBanner(message: "Contact saved", style: .success)
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .navigationTitle("Emergency Setup")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { loadContacts() }
        .animation(.easeInOut(duration: 0.25), value: showToast)
        .sheet(isPresented: $showAddSheet, onDismiss: { loadContacts() }) {
            ContactEditSheet(contact: nil, nextSortOrder: contacts.count) { _ in
                loadContacts()
                flashToast()
            }
        }
        .sheet(item: $editingContact, onDismiss: { loadContacts() }) { contact in
            ContactEditSheet(contact: contact, nextSortOrder: contact.sortOrder) { _ in
                loadContacts()
                flashToast()
            }
        }
        .alert("Remove contact?", isPresented: $showDeleteAlert) {
            Button("Remove", role: .destructive) {
                if let target = deleteTarget {
                    deleteContact(target)
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This contact will be permanently removed from your emergency list.")
        }
    }

    private func loadContacts() {
        contacts = AppDataManager.fetchAllContacts(context: modelContext)
    }

    private func deleteContact(_ contact: EmergencyContactEntity) {
        modelContext.delete(contact)
        AppDataManager.saveContext(modelContext)
        loadContacts()
    }

    private func flashToast() {
        showToast = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { showToast = false }
    }
}

// Card showing one contact in the list
struct ContactRowCard: View {
    let contact: EmergencyContactEntity
    let isPrimary: Bool
    let onEdit: () -> Void
    let onDelete: () -> Void

    var body: some View {
        AGCard {
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .top) {
                    // Initials avatar
                    ZStack {
                        Circle()
                            .fill(isPrimary ? AGColor.primary : AGColor.cardSoft)
                            .frame(width: 40, height: 40)
                        Text(initials)
                            .font(.system(size: 15, weight: .bold))
                            .foregroundStyle(isPrimary ? .white : AGColor.neutral)
                    }

                    VStack(alignment: .leading, spacing: 3) {
                        HStack(spacing: 8) {
                            Text(contact.name.isEmpty ? "Unnamed contact" : contact.name)
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundStyle(AGColor.darkText)
                            if isPrimary {
                                AGSmallChip(title: "Primary", color: AGColor.primary, softColor: AGColor.primarySoft)
                            }
                        }
                        if !contact.relationship.isEmpty {
                            Text(contact.relationship)
                                .font(.system(size: 13, weight: .medium))
                                .foregroundStyle(AGColor.neutral)
                        }
                        if !contact.phone.isEmpty {
                            Text(contact.phone)
                                .font(.system(size: 13, weight: .medium))
                                .foregroundStyle(AGColor.primary)
                        }
                    }

                    Spacer()

                    // Edit / delete menu
                    Menu {
                        Button { onEdit() } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                        Button(role: .destructive) { onDelete() } label: {
                            Label("Remove", systemImage: "trash")
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(AGColor.neutral)
                            .frame(width: 32, height: 32)
                    }
                }

                if !contact.notes.isEmpty {
                    Text(contact.notes)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(AGColor.neutral)
                        .lineSpacing(2)
                        .padding(.top, 2)
                }

                if contact.hasAsthmaHistory {
                    HStack(spacing: 6) {
                        Image(systemName: "lungs.fill")
                            .font(.system(size: 11))
                            .foregroundStyle(AGColor.warning)
                        Text("Asthma history noted")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(AGColor.warning)
                    }
                }
            }
        }
    }

    private var initials: String {
        let parts = contact.name.split(separator: " ").prefix(2)
        let result = parts.compactMap { $0.first.map { String($0) } }.joined().uppercased()
        return result.isEmpty ? "?" : result
    }
}

// Sheet for adding or editing a single contact
struct ContactEditSheet: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    let contact: EmergencyContactEntity?   // nil = new
    let nextSortOrder: Int
    let onSaved: (EmergencyContactEntity) -> Void

    @State private var fullName = ""
    @State private var relationship = ""
    @State private var phone = ""
    @State private var notes = ""
    @State private var hasAsthma = false
    @State private var showContactPicker = false

    var body: some View {
        NavigationStack {
            ZStack {
                AGColor.bg.ignoresSafeArea()
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {

                        // Import from Contacts
                        Button {
                            showContactPicker = true
                        } label: {
                            HStack(spacing: 10) {
                                Image(systemName: "person.crop.circle.badge.plus")
                                    .font(.system(size: 16, weight: .semibold))
                                Text("Import from Contacts")
                                    .font(.system(size: 16, weight: .semibold))
                            }
                            .foregroundStyle(AGColor.primary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(AGColor.primarySoft)
                            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .stroke(AGColor.primary.opacity(0.25), lineWidth: 1)
                            )
                        }
                        .buttonStyle(.plain)

                        AGCard {
                            VStack(alignment: .leading, spacing: 14) {
                                Text("Contact details")
                                    .font(.headline)
                                    .foregroundStyle(AGColor.darkText)

                                TextField("Full name", text: $fullName)
                                    .agTextFieldStyle()
                                TextField("Relationship (e.g. Mum, Friend)", text: $relationship)
                                    .agTextFieldStyle()
                                TextField("Phone number", text: $phone)
                                    .keyboardType(.phonePad)
                                    .agTextFieldStyle()
                            }
                        }

                        AGCard {
                            VStack(alignment: .leading, spacing: 14) {
                                Text("Medical notes")
                                    .font(.headline)
                                    .foregroundStyle(AGColor.darkText)
                                TextField("Emergency note (optional)", text: $notes, axis: .vertical)
                                    .lineLimit(4, reservesSpace: true)
                                    .agTextFieldStyle()
                                Toggle("Asthma history", isOn: $hasAsthma)
                                    .foregroundStyle(AGColor.bodyText)
                                    .tint(AGColor.primary)
                            }
                        }

                        AGPrimaryButton(title: contact == nil ? "Add Contact" : "Save Changes", icon: "checkmark") {
                            save()
                        }
                    }
                    .padding(.horizontal, 18)
                    .padding(.top, 14)
                    .padding(.bottom, 30)
                }
            }
            .navigationTitle(contact == nil ? "New Contact" : "Edit Contact")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundStyle(AGColor.primary)
                }
            }
            .onAppear { prefill() }
            .sheet(isPresented: $showContactPicker) {
                ContactPicker { name, pickedPhone in
                    // Only overwrite fields that came back non-empty
                    if !name.isEmpty       { fullName = name }
                    if !pickedPhone.isEmpty { phone = pickedPhone }
                }
                .ignoresSafeArea()
            }
        }
    }

    private func prefill() {
        guard let c = contact else { return }
        fullName = c.name
        relationship = c.relationship
        phone = c.phone
        notes = c.notes
        hasAsthma = c.hasAsthmaHistory
    }

    private func save() {
        let target: EmergencyContactEntity
        if let existing = contact {
            target = existing
        } else {
            target = EmergencyContactEntity(
                isPrimary: nextSortOrder == 0,
                sortOrder: nextSortOrder
            )
            modelContext.insert(target)
        }
        target.name = fullName.trimmingCharacters(in: .whitespacesAndNewlines)
        target.relationship = relationship.trimmingCharacters(in: .whitespacesAndNewlines)
        target.phone = phone.trimmingCharacters(in: .whitespacesAndNewlines)
        target.notes = notes.trimmingCharacters(in: .whitespacesAndNewlines)
        target.hasAsthmaHistory = hasAsthma
        AppDataManager.saveContext(modelContext)
        onSaved(target)
        dismiss()
    }
}
// MARK: - 5 Permissions

struct PermissionsView: View {
    var onComplete: (() -> Void)? = nil

    @State private var cameraGranted = false
    @State private var notificationsGranted = false
    @State private var isRequesting = false

    var body: some View {
        ZStack {
            AGColor.bg.ignoresSafeArea()

            VStack(spacing: 20) {
                Spacer()

                Image(systemName: "lock.shield.fill")
                    .font(.system(size: 58))
                    .foregroundStyle(AGColor.primary)
                    .frame(width: 120, height: 120)
                    .background(AGColor.primarySoft)
                    .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))

                Text("Enable what the app needs")
                    .font(.system(size: 28, weight: .bold))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(AGColor.darkText)

                AGCard {
                    VStack(alignment: .leading, spacing: 16) {
                        HStack(spacing: 12) {
                            Image(systemName: cameraGranted ? "checkmark.circle.fill" : "camera.fill")
                                .foregroundStyle(cameraGranted ? AGColor.success : AGColor.primary)
                            Text("Camera — to scan ingredient labels")
                                .font(.system(size: 17, weight: .medium))
                                .foregroundStyle(AGColor.darkText)
                        }

                        HStack(spacing: 12) {
                            Image(systemName: notificationsGranted ? "checkmark.circle.fill" : "bell.fill")
                                .foregroundStyle(notificationsGranted ? AGColor.success : AGColor.primary)
                            Text("Notifications — for helpful scan reminders")
                                .font(.system(size: 17, weight: .medium))
                                .foregroundStyle(AGColor.darkText)
                        }
                    }
                }
                .padding(.horizontal, 20)

                Spacer()

                VStack(spacing: 12) {
                    AGPrimaryButton(title: isRequesting ? "Requesting..." : "Grant Permissions", icon: "hand.tap.fill") {
                        requestPermissions()
                    }
                    .opacity(isRequesting ? 0.7 : 1.0)

                    AGSecondaryButton(title: "Skip for now") {
                        onComplete?()
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
        }
        .navigationTitle("Permissions")
    }

    private func requestPermissions() {
        isRequesting = true

        // Request camera permission
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                cameraGranted = granted
            }
        }

        // Request notification permission
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            DispatchQueue.main.async {
                notificationsGranted = granted
                isRequesting = false
                // Proceed after a short delay so status icons animate in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    onComplete?()
                }
            }
        }
    }
}

// MARK: - 6 Home Dashboard

struct HomeDashboardView: View {
    @EnvironmentObject var scanSession: ScanSessionStore
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \ScanRecord.createdAt, order: .reverse) private var records: [ScanRecord]

    private var currentProfile: UserProfile {
        AppDataManager.fetchOrCreateUserProfile(context: modelContext)
    }
    private var latestScan: ScanRecord? { records.first }

    private var allergenChips: [String] {
        let custom = currentProfile.customAllergen.trimmingCharacters(in: .whitespacesAndNewlines)
        return currentProfile.allergies + (custom.isEmpty ? [] : [custom])
    }

    private var profileIsReady: Bool {
        !allergenChips.isEmpty
    }

    let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        ZStack {
            AGColor.bg.ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    heroSection
                        .padding(.horizontal, 18)
                        .padding(.bottom, 18)

                    // Active check-in banner
                    if scanSession.checkInActive {
                        checkInBanner
                            .padding(.horizontal, 18)
                            .padding(.bottom, 14)
                    }

                    profileStatusStrip
                        .padding(.horizontal, 18)
                        .padding(.bottom, 20)

                    // Quick actions
                    VStack(alignment: .leading, spacing: 12) {
                        AGSectionHeader(title: "Quick actions")
                            .padding(.horizontal, 18)

                        LazyVGrid(columns: columns, spacing: 10) {
                            NavigationLink { LiveScanView() } label: {
                                QuickActionCard(icon: "camera.viewfinder", title: "Scan label", subtitle: "Photo OCR")
                            }.buttonStyle(.plain)

                            NavigationLink { ProductLookupView() } label: {
                                QuickActionCard(icon: "barcode.viewfinder", title: "Barcode", subtitle: "Product lookup")
                            }.buttonStyle(.plain)

                            NavigationLink { EmergencyHelpView() } label: {
                                QuickActionCard(
                                    icon: "phone.fill.badge.plus",
                                    title: "Emergency",
                                    subtitle: "Call contact",
                                    accentColor: AGColor.danger,
                                    accentSoft: AGColor.dangerSoft
                                )
                            }.buttonStyle(.plain)

                            NavigationLink { HistoryView() } label: {
                                QuickActionCard(icon: "clock.arrow.circlepath", title: "History", subtitle: "Past scans")
                            }.buttonStyle(.plain)
                        }
                        .padding(.horizontal, 18)
                    }
                    .padding(.bottom, 22)

                    // Last scan
                    VStack(alignment: .leading, spacing: 12) {
                        AGSectionHeader(title: "Last scan")
                            .padding(.horizontal, 18)
                        lastScanCard
                            .padding(.horizontal, 18)
                    }
                    .padding(.bottom, 28)
                }
                .padding(.top, 14)
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink { ProfileSettingsView() } label: {
                    Image(systemName: "person.crop.circle")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(AGColor.primary)
                }
            }
        }
    }

    // MARK: Check-in banner

    private var checkInBanner: some View {
        AGCard {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(AGColor.warningSoft)
                        .frame(width: 40, height: 40)
                    Image(systemName: "clock.badge.exclamationmark.fill")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(AGColor.warning)
                }

                VStack(alignment: .leading, spacing: 3) {
                    Text("Check-in active")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(AGColor.darkText)
                    Text(checkInTimeRemaining)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(AGColor.neutral)
                }

                Spacer()

                Button {
                    cancelActiveCheckIn()
                } label: {
                    Text("Cancel")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(AGColor.danger)
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var checkInTimeRemaining: String {
        guard let fireDate = scanSession.checkInFireDate else {
            return "\(scanSession.checkInContactName) will be notified soon."
        }
        let mins = Int(fireDate.timeIntervalSinceNow / 60)
        if mins <= 0 { return "Notification sent to \(scanSession.checkInContactName)." }
        return "\(scanSession.checkInContactName) notified in ~\(mins) min."
    }

    private func cancelActiveCheckIn() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(
            withIdentifiers: [ScanSessionStore.checkInNotificationID]
        )
        scanSession.checkInActive = false
        scanSession.checkInContactName = ""
        scanSession.checkInFireDate = nil
    }

    // MARK: Hero

    private var heroSection: some View {
        ZStack(alignment: .bottomLeading) {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(AGColor.primary)
                .frame(maxWidth: .infinity)
                .frame(height: 148)

            // Decorative circles
            Circle()
                .fill(Color.white.opacity(0.06))
                .frame(width: 160, height: 160)
                .offset(x: 220, y: -20)

            Circle()
                .fill(Color.white.opacity(0.04))
                .frame(width: 100, height: 100)
                .offset(x: 260, y: 30)

            VStack(alignment: .leading, spacing: 6) {
                Text(greetingText())
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.75))

                Text("Stay safe. Scan smarter.")
                    .font(.system(size: 26, weight: .bold))
                    .tracking(-0.4)
                    .foregroundStyle(.white)
                    .lineSpacing(2)

                NavigationLink { LiveScanView() } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "camera.viewfinder")
                            .font(.system(size: 12, weight: .semibold))
                        Text("Scan a label")
                            .font(.system(size: 13, weight: .semibold))
                    }
                    .foregroundStyle(AGColor.primary)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(Color.white)
                    .clipShape(Capsule())
                }
                .buttonStyle(.plain)
                .padding(.top, 4)
            }
            .padding(20)
        }
    }

    // MARK: Profile status strip

    private var profileStatusStrip: some View {
        AGCard {
            HStack(spacing: 12) {
                Image(systemName: profileIsReady ? "checkmark.shield.fill" : "exclamationmark.shield.fill")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(profileIsReady ? AGColor.success : AGColor.warning)

                VStack(alignment: .leading, spacing: 3) {
                    Text(profileIsReady ? "Profile ready" : "Profile incomplete")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(AGColor.darkText)

                    Text(profileStatusSubtitle)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(AGColor.neutral)
                }

                Spacer()

                NavigationLink { AllergySetupView() } label: {
                    Text(profileIsReady ? "Edit" : "Set up")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(AGColor.primary)
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var profileStatusSubtitle: String {
        let count = allergenChips.count
        let sensitivity = currentProfile.sensitivityLevel
        if count == 0 { return "Add your allergens to enable scanning" }
        return "\(count) allergen\(count == 1 ? "" : "s") · \(sensitivity)"
    }

    // MARK: Last scan card

    private var lastScanCard: some View {
        Group {
            if let scan = latestScan {
                NavigationLink {
                    ScanRecordDetailView(record: scan)
                } label: {
                    AGCard {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(alignment: .top) {
                                VStack(alignment: .leading, spacing: 3) {
                                    Text(formattedDate(scan.createdAt))
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundStyle(AGColor.darkText)
                                    Text("\(Int(scan.confidenceScore * 100))% confidence")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundStyle(AGColor.neutral)
                                }
                                Spacer()
                                verdictBadge(scan.verdict)
                            }

                            if !scan.matchedAllergens.isEmpty {
                                HStack(spacing: 6) {
                                    ForEach(scan.matchedAllergens.prefix(3), id: \.self) { a in
                                        AGSmallChip(
                                            title: a,
                                            color: AGColor.danger,
                                            softColor: AGColor.dangerSoft
                                        )
                                    }
                                    if scan.matchedAllergens.count > 3 {
                                        AGSmallChip(
                                            title: "+\(scan.matchedAllergens.count - 3) more",
                                            color: AGColor.neutral,
                                            softColor: AGColor.cardSoft
                                        )
                                    }
                                }
                            }

                            Text(previewText(scan.extractedText))
                                .font(.system(size: 13, weight: .medium))
                                .foregroundStyle(AGColor.neutral)
                                .lineLimit(2)
                        }
                    }
                }
                .buttonStyle(.plain)
            } else {
                AGCard {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("No scans yet")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(AGColor.darkText)
                        Text("Run a label scan — your verdict, matched allergens, and history will appear here.")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(AGColor.neutral)
                            .lineSpacing(2)
                    }
                }
            }
        }
    }

    private func verdictBadge(_ verdict: ScanVerdict) -> some View {
        Text(verdict.rawValue)
            .font(.system(size: 12, weight: .bold))
            .foregroundStyle(.white)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(verdict.color)
            .clipShape(Capsule())
    }

    private func greetingText() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Good morning"
        case 12..<17: return "Good afternoon"
        case 17..<22: return "Good evening"
        default: return "Welcome back"
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .short
        return f.string(from: date)
    }

    private func previewText(_ text: String) -> String {
        let t = text.trimmingCharacters(in: .whitespacesAndNewlines)
        return t.isEmpty ? "No extracted text available." : t
    }
}

// MARK: - 7 Live Scan

struct LiveScanView: View {
    @EnvironmentObject var scanSession: ScanSessionStore

    @State private var showPhotoPicker = false
    @State private var showCameraPicker = false
    @State private var showNoCameraAlert = false
    @State private var showSourceMenu = false
    @State private var goToOCRReview = false

    private var imageIsReady: Bool { scanSession.selectedImage != nil }

    var body: some View {
        ZStack {
            AGColor.scanBg.ignoresSafeArea()

            VStack(spacing: 0) {
                // Step progress
                HStack {
                    AGStepProgress(total: 3, current: 1)
                    Spacer()
                    Text("Step 1 of 3")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.5))
                }
                .padding(.horizontal, 22)
                .padding(.top, 10)
                .padding(.bottom, 18)

                Spacer()

                // Preview frame
                if let image = scanSession.selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 310, height: 230)
                        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 22, style: .continuous)
                                .stroke(AGColor.primary.opacity(0.8), lineWidth: 2)
                        )
                        .transition(.opacity.combined(with: .scale(scale: 0.96)))
                } else {
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .strokeBorder(Color.white.opacity(0.2),
                                      style: StrokeStyle(lineWidth: 1.5, dash: [10, 7]))
                        .frame(width: 310, height: 220)
                        .overlay {
                            VStack(spacing: 12) {
                                Image(systemName: "viewfinder")
                                    .font(.system(size: 36, weight: .light))
                                    .foregroundStyle(.white.opacity(0.3))
                                Text("Hold to choose source")
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundStyle(.white.opacity(0.3))
                            }
                        }
                        .onLongPressGesture(minimumDuration: 0.4) {
                            showSourceMenu = true
                        }
                }

                Spacer(minLength: 20)

                // Helper hint
                if scanSession.isProcessing {
                    ProgressView("Reading label…")
                        .tint(.white)
                        .foregroundStyle(.white.opacity(0.7))
                        .padding(.horizontal, 22)
                } else {
                    AGScanHelperCard(
                        title: imageIsReady ? "Ready to extract text" : "Take or choose a photo",
                        subtitle: imageIsReady
                            ? "Tap Extract text below to run OCR, then review before analysis."
                            : "Point your camera at the ingredient panel, or pick an existing photo."
                    )
                    .padding(.horizontal, 22)
                }

                Spacer()

                // Bottom action bar
                if imageIsReady {
                    HStack(spacing: 0) {
                        BottomBarButton(icon: "arrow.counterclockwise", label: "Reset") {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                scanSession.selectedImage = nil
                                scanSession.extractedText = ""
                                scanSession.analysisResult = nil
                            }
                        }
                        Spacer()
                        BottomBarButton(icon: "camera.fill", label: "Retake") {
                            openCamera()
                        }
                        Spacer()
                        BottomBarButton(icon: "photo.on.rectangle", label: "Library") {
                            showPhotoPicker = true
                        }
                        Spacer()
                        BottomBarButton(
                            icon: "text.viewfinder",
                            label: "Extract text",
                            isPrimary: true,
                            isDisabled: scanSession.isProcessing
                        ) {
                            runOCR()
                        }
                    }
                    .padding(.horizontal, 28)
                    .padding(.bottom, 32)
                } else {
                    HStack(spacing: 20) {
                        LargeSourceButton(icon: "camera.fill", label: "Camera") {
                            openCamera()
                        }
                        LargeSourceButton(icon: "photo.on.rectangle.fill", label: "Photo library") {
                            showPhotoPicker = true
                        }
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, 32)
                }
            }
        }
        .navigationTitle("Scan label")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .animation(.easeInOut(duration: 0.2), value: imageIsReady)
        .sheet(isPresented: $showPhotoPicker) {
            PhotoPicker { image in
                withAnimation { scanSession.selectedImage = image }
            }
        }
        .fullScreenCover(isPresented: $showCameraPicker) {
            CameraPicker { image in
                withAnimation { scanSession.selectedImage = image }
            }
            .ignoresSafeArea()
        }
        .alert("Camera unavailable", isPresented: $showNoCameraAlert) {
            Button("Use photo library") { showPhotoPicker = true }
            Button("OK", role: .cancel) {}
        } message: {
            Text("This device doesn't have a camera, or camera access hasn't been granted. You can still use a photo from your library.")
        }
        .confirmationDialog("Choose image source", isPresented: $showSourceMenu, titleVisibility: .visible) {
            Button("Camera") { openCamera() }
            Button("Photo library") { showPhotoPicker = true }
            Button("Cancel", role: .cancel) {}
        }
        .navigationDestination(isPresented: $goToOCRReview) {
            OCRReviewView()
        }
        .onAppear {
            scanSession.shouldReturnToScanRoot = false
        }
    }

    private func openCamera() {
        if CameraPicker.isAvailable {
            showCameraPicker = true
        } else {
            showNoCameraAlert = true
        }
    }

    private func runOCR() {
        guard let image = scanSession.selectedImage else { return }
        scanSession.isProcessing = true
        OCRService.recognizeText(from: image) { text in
            scanSession.extractedText = text
            scanSession.isProcessing = false
            goToOCRReview = true
        }
    }
}

// Large source button when no image loaded
struct LargeSourceButton: View {
    let icon: String
    let label: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 26, weight: .medium))
                    .foregroundStyle(.white)
                    .frame(width: 60, height: 60)
                    .background(Color.white.opacity(0.12))
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white.opacity(0.18), lineWidth: 1))
                Text(label)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.7))
            }
        }
        .buttonStyle(.plain)
        .frame(maxWidth: .infinity)
    }
}

// Bottom bar button for when image is already loaded
struct BottomBarButton: View {
    let icon: String
    let label: String
    var isPrimary: Bool = false
    var isDisabled: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 5) {
                Image(systemName: icon)
                    .font(.system(size: isPrimary ? 22 : 18, weight: .semibold))
                    .foregroundStyle(isPrimary ? AGColor.primary : .white)
                    .frame(width: isPrimary ? 64 : 48, height: isPrimary ? 64 : 48)
                    .background(isPrimary ? Color.white : Color.white.opacity(0.10))
                    .clipShape(Circle())
                    .overlay(
                        Circle().stroke(
                            isPrimary ? Color.clear : Color.white.opacity(0.15),
                            lineWidth: 1
                        )
                    )
                Text(label)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(.white.opacity(isPrimary ? 0.9 : 0.6))
            }
        }
        .buttonStyle(.plain)
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.35 : 1.0)
    }
}

// MARK: - 8 OCR Review

struct OCRReviewView: View {
    @EnvironmentObject var scanSession: ScanSessionStore
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            AGColor.bg.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    // Header + progress
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            VStack(alignment: .leading, spacing: 3) {
                                Text("Step 2 of 3")
                                    .font(.system(size: 11, weight: .semibold))
                                    .tracking(0.5)
                                    .foregroundStyle(AGColor.neutral)
                                Text("Review extracted text")
                                    .font(.system(size: 24, weight: .bold))
                                    .tracking(-0.3)
                                    .foregroundStyle(AGColor.darkText)
                            }
                            Spacer()
                        }
                        Text("Check OCR accuracy and edit anything before analysis.")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(AGColor.neutral)

                        AGStepProgress(total: 3, current: 2)
                            .padding(.top, 2)
                    }

                    // Image thumbnail (compact)
                    if let image = scanSession.selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity)
                            .frame(height: 160)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .stroke(AGColor.border, lineWidth: 1)
                            )
                    }

                    // Text editor card
                    AGCard {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                AGSectionHeader(title: "Extracted text")
                                Spacer()
                                if !scanSession.extractedText.isEmpty {
                                    Text("\(scanSession.extractedText.split(separator: " ").count) words")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundStyle(AGColor.neutral)
                                }
                            }

                            TextEditor(text: $scanSession.extractedText)
                                .font(.system(size: 15, weight: .regular))
                                .foregroundStyle(AGColor.darkText)
                                .frame(minHeight: 200)
                                .padding(12)
                                .background(AGColor.cardSoft)
                                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .stroke(AGColor.border, lineWidth: 1)
                                )
                        }
                    }

                    // Pre-analysis hint if text looks like it has allergens
                    if !scanSession.extractedText.isEmpty {
                        HStack(spacing: 10) {
                            Image(systemName: "info.circle.fill")
                                .font(.system(size: 14))
                                .foregroundStyle(AGColor.primary)
                            Text("Tap Analyze to check this text against your allergy profile.")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundStyle(AGColor.neutral)
                        }
                        .padding(14)
                        .background(AGColor.primarySoft)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    }

                    // Actions
                    VStack(spacing: 10) {
                        NavigationLink { ScanResultView() } label: {
                            HStack(spacing: 8) {
                                Image(systemName: "text.magnifyingglass")
                                    .font(.system(size: 16, weight: .semibold))
                                Text("Analyze")
                                    .font(.system(size: 17, weight: .semibold))
                            }
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                scanSession.extractedText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                                    ? AGColor.neutral
                                    : AGColor.primary
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        }
                        .buttonStyle(.plain)
                        .simultaneousGesture(TapGesture().onEnded { runAnalysis() })
                        .disabled(scanSession.extractedText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)

                        AGSecondaryButton(title: "Choose another photo") {
                            scanSession.selectedImage = nil
                            scanSession.extractedText = ""
                            dismiss()
                        }
                    }
                }
                .padding(.horizontal, 18)
                .padding(.top, 14)
                .padding(.bottom, 30)
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: scanSession.shouldReturnToScanRoot) {
            if scanSession.shouldReturnToScanRoot {
                scanSession.shouldReturnToScanRoot = false
                dismiss()
            }
        }
    }

    private func runAnalysis() {
        let profile = AppDataManager.fetchOrCreateUserProfile(context: modelContext)
        let result = AllergenEngine.analyze(
            text: scanSession.extractedText,
            userAllergies: profile.allergies,
            customAllergen: profile.customAllergen,
            allergenSensitivities: profile.allergenSensitivities
        )
        scanSession.analysisResult = result
        scanSession.isNewResult = true

        let record = ScanRecord(
            createdAt: Date(),
            extractedText: scanSession.extractedText,
            normalizedText: result.normalizedText,
            verdictRawValue: result.verdict.rawValue,
            matchedAllergens: result.matchedUserAllergens,
            cautionAllergens: result.cautionAllergens,
            infoOnlyAllergens: result.infoOnlyAllergens,
            matchedEvidence: result.matchedEvidence,
            crossContactWarnings: result.crossContactWarnings,
            infoFlags: result.infoFlags,
            confidenceScore: result.confidenceScore
        )
        modelContext.insert(record)
        try? modelContext.save()
    }
}

// MARK: - Check-in Sheet

struct CheckInSheet: View {
    let verdict: ScanVerdict
    let matchedAllergens: [String]
    let contact: EmergencyContactEntity?
    let onScheduled: (Int) -> Void   // passes chosen minutes
    let onDismiss: () -> Void

    @State private var selectedMinutes: Int = 30

    private let delayOptions = [15, 30, 60]

    private var contactName: String {
        guard let c = contact, !c.name.isEmpty else { return "your emergency contact" }
        return c.name
    }

    private var hasPhone: Bool {
        guard let c = contact else { return false }
        return !c.phone.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private var verdictColor: Color {
        verdict == .unsafe ? AGColor.danger : AGColor.warning
    }

    private var verdictSoft: Color {
        verdict == .unsafe ? AGColor.dangerSoft : AGColor.warningSoft
    }

    var body: some View {
        ZStack {
            AGColor.bg.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {

                // Handle bar
                HStack {
                    Spacer()
                    RoundedRectangle(cornerRadius: 3)
                        .fill(AGColor.border)
                        .frame(width: 36, height: 4)
                    Spacer()
                }
                .padding(.top, 12)
                .padding(.bottom, 20)

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {

                        // Header
                        VStack(alignment: .leading, spacing: 6) {
                            HStack(spacing: 10) {
                                Image(systemName: verdict == .unsafe ? "exclamationmark.triangle.fill" : "exclamationmark.circle.fill")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundStyle(verdictColor)
                                Text("Eating this anyway?")
                                    .font(.system(size: 22, weight: .bold))
                                    .foregroundStyle(AGColor.darkText)
                            }
                            Text("Set up a check-in so \(contactName) is notified to follow up on you after you've eaten this.")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundStyle(AGColor.neutral)
                                .lineSpacing(2)
                        }

                        // Allergen reminder
                        if !matchedAllergens.isEmpty {
                            HStack(spacing: 8) {
                                ForEach(matchedAllergens.prefix(4), id: \.self) { a in
                                    AGSmallChip(title: a, color: verdictColor, softColor: verdictSoft)
                                }
                                if matchedAllergens.count > 4 {
                                    AGSmallChip(
                                        title: "+\(matchedAllergens.count - 4) more",
                                        color: AGColor.neutral,
                                        softColor: AGColor.cardSoft
                                    )
                                }
                            }
                        }

                        // Contact preview
                        AGCard {
                            HStack(spacing: 12) {
                                ZStack {
                                    Circle()
                                        .fill(AGColor.primarySoft)
                                        .frame(width: 40, height: 40)
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundStyle(AGColor.primary)
                                }

                                VStack(alignment: .leading, spacing: 3) {
                                    Text("Notifying")
                                        .font(.system(size: 11, weight: .semibold))
                                        .foregroundStyle(AGColor.neutral)
                                        .tracking(0.4)
                                    Text(contactName)
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundStyle(AGColor.darkText)
                                    if let c = contact, !c.relationship.isEmpty {
                                        Text(c.relationship)
                                            .font(.system(size: 13, weight: .medium))
                                            .foregroundStyle(AGColor.neutral)
                                    }
                                }

                                Spacer()

                                if !hasPhone {
                                    AGSmallChip(title: "No phone saved", color: AGColor.warning, softColor: AGColor.warningSoft)
                                }
                            }
                        }

                        // Check-in delay picker
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Check in after")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(AGColor.neutral)
                                .tracking(0.3)

                            HStack(spacing: 10) {
                                ForEach(delayOptions, id: \.self) { mins in
                                    Button {
                                        selectedMinutes = mins
                                    } label: {
                                        VStack(spacing: 4) {
                                            Text("\(mins)")
                                                .font(.system(size: 22, weight: .bold))
                                                .foregroundStyle(selectedMinutes == mins ? .white : AGColor.darkText)
                                            Text("min")
                                                .font(.system(size: 12, weight: .medium))
                                                .foregroundStyle(selectedMinutes == mins ? .white.opacity(0.8) : AGColor.neutral)
                                        }
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 14)
                                        .background(selectedMinutes == mins ? AGColor.primary : AGColor.card)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                                .stroke(selectedMinutes == mins ? AGColor.primary : AGColor.border, lineWidth: 1)
                                        )
                                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }

                        // What happens note
                        HStack(alignment: .top, spacing: 10) {
                            Image(systemName: "info.circle.fill")
                                .font(.system(size: 13))
                                .foregroundStyle(AGColor.primary)
                                .padding(.top, 2)
                            VStack(alignment: .leading, spacing: 4) {
                                Text("What happens")
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundStyle(AGColor.darkText)
                                Text("A notification will remind you to check in after \(selectedMinutes) minutes. An SMS will open pre-addressed to \(contactName) asking them to follow up on you.")
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundStyle(AGColor.neutral)
                                    .lineSpacing(2)
                            }
                        }
                        .padding(14)
                        .background(AGColor.primarySoft)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

                        // Actions
                        VStack(spacing: 10) {
                            AGPrimaryButton(
                                title: "Start \(selectedMinutes)-min check-in",
                                icon: "clock.badge.checkmark"
                            ) {
                                onScheduled(selectedMinutes)
                            }

                            AGSecondaryButton(title: "I won't eat this — cancel") {
                                onDismiss()
                            }
                        }
                        .padding(.bottom, 10)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
            }
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.hidden)
    }
}



// MARK: - 9 Result

struct ScanResultView: View {
    @EnvironmentObject var scanSession: ScanSessionStore
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var showToast = false
    @State private var showCheckIn = false
    @State private var checkInContact: EmergencyContactEntity? = nil
    @State private var checkInScheduledMinutes: Int? = nil

    private var result: AllergenAnalysisResult? { scanSession.analysisResult }

    private var shouldOfferCheckIn: Bool {
        result?.verdict == .unsafe || result?.verdict == .caution
    }

    var body: some View {
        ZStack(alignment: .top) {
            AGColor.bg.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 18) {

                    // Header + step
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            VStack(alignment: .leading, spacing: 3) {
                                Text("Step 3 of 3")
                                    .font(.system(size: 11, weight: .semibold))
                                    .tracking(0.5)
                                    .foregroundStyle(AGColor.neutral)
                                Text("Scan result")
                                    .font(.system(size: 24, weight: .bold))
                                    .tracking(-0.3)
                                    .foregroundStyle(AGColor.darkText)
                            }
                            Spacer()
                            Text(formattedNow())
                                .font(.system(size: 12, weight: .medium))
                                .foregroundStyle(AGColor.neutral)
                        }
                        AGStepProgress(total: 3, current: 3)
                    }

                    // Verdict
                    AGVerdictCard(
                        verdict: result?.verdict ?? .uncertain,
                        detail: verdictDetail(for: result),
                        confidenceScore: result?.confidenceScore
                    )

                    // Check-in card — shown for unsafe/caution
                    if shouldOfferCheckIn {
                        if let mins = checkInScheduledMinutes {
                            AGCard {
                                HStack(spacing: 14) {
                                    ZStack {
                                        Circle()
                                            .fill(AGColor.successSoft)
                                            .frame(width: 40, height: 40)
                                        Image(systemName: "clock.badge.checkmark.fill")
                                            .font(.system(size: 18, weight: .semibold))
                                            .foregroundStyle(AGColor.success)
                                    }
                                    VStack(alignment: .leading, spacing: 3) {
                                        Text("Check-in active")
                                            .font(.system(size: 15, weight: .semibold))
                                            .foregroundStyle(AGColor.darkText)
                                        Text("\(scanSession.checkInContactName) will be notified in \(mins) minutes.")
                                            .font(.system(size: 13, weight: .medium))
                                            .foregroundStyle(AGColor.neutral)
                                    }
                                    Spacer()
                                    Button { cancelCheckIn() } label: {
                                        Text("Cancel")
                                            .font(.system(size: 13, weight: .semibold))
                                            .foregroundStyle(AGColor.danger)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        } else {
                            Button { showCheckIn = true } label: {
                                HStack(spacing: 12) {
                                    ZStack {
                                        Circle()
                                            .fill(result?.verdict == .unsafe ? AGColor.dangerSoft : AGColor.warningSoft)
                                            .frame(width: 40, height: 40)
                                        Image(systemName: "person.crop.circle.badge.clock")
                                            .font(.system(size: 18, weight: .semibold))
                                            .foregroundStyle(result?.verdict == .unsafe ? AGColor.danger : AGColor.warning)
                                    }
                                    VStack(alignment: .leading, spacing: 3) {
                                        Text("Eating this anyway?")
                                            .font(.system(size: 15, weight: .semibold))
                                            .foregroundStyle(AGColor.darkText)
                                        Text("Set up a check-in with your emergency contact.")
                                            .font(.system(size: 13, weight: .medium))
                                            .foregroundStyle(AGColor.neutral)
                                    }
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 13, weight: .semibold))
                                        .foregroundStyle(AGColor.hint)
                                }
                                .padding(16)
                                .background(AGColor.card)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                                        .stroke(result?.verdict == .unsafe ? AGColor.danger.opacity(0.3) : AGColor.warning.opacity(0.3), lineWidth: 1)
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            }
                            .buttonStyle(.plain)
                        }
                    }

                    // Matched allergens — broken down by outcome
                    if let matched = result?.matchedUserAllergens, !matched.isEmpty {
                        AGCard {
                            VStack(alignment: .leading, spacing: 12) {
                                AGSectionHeader(title: "Matched allergens")
                                HStack(spacing: 8) {
                                    ForEach(matched, id: \.self) { a in
                                        AGSmallChip(title: a, color: AGColor.danger, softColor: AGColor.dangerSoft)
                                    }
                                }
                            }
                        }
                    }

                    // Caution allergens (cross-contact, Strict sensitivity)
                    if let caution = result?.cautionAllergens, !caution.isEmpty {
                        AGCard {
                            VStack(alignment: .leading, spacing: 12) {
                                AGSectionHeader(title: "Cross-contact risk")
                                HStack(spacing: 8) {
                                    ForEach(caution, id: \.self) { a in
                                        AGSmallChip(title: a, color: AGColor.warning, softColor: AGColor.warningSoft)
                                    }
                                }
                                Text("These allergens were found in cross-contact warnings, not the ingredients list.")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundStyle(AGColor.neutral)
                            }
                        }
                    }

                    // Info-only allergens (Informational sensitivity or Moderate cross-contact)
                    if let info = result?.infoOnlyAllergens, !info.isEmpty {
                        AGCard {
                            VStack(alignment: .leading, spacing: 12) {
                                AGSectionHeader(title: "Monitoring only")
                                HStack(spacing: 8) {
                                    ForEach(info, id: \.self) { a in
                                        AGSmallChip(title: a, color: AGColor.neutral, softColor: AGColor.cardSoft)
                                    }
                                }
                                Text("These allergens were detected but suppressed based on your sensitivity settings.")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundStyle(AGColor.neutral)
                            }
                        }
                    }

                    // Evidence
                    if let evidence = result?.matchedEvidence, !evidence.isEmpty {
                        AGCard {
                            VStack(alignment: .leading, spacing: 12) {
                                AGSectionHeader(title: "Evidence found")
                                VStack(alignment: .leading, spacing: 8) {
                                    ForEach(evidence, id: \.self) { item in
                                        HStack(alignment: .top, spacing: 10) {
                                            Circle().fill(AGColor.warning).frame(width: 7, height: 7).padding(.top, 5)
                                            Text(item).font(.system(size: 14, weight: .medium)).foregroundStyle(AGColor.darkText)
                                        }
                                    }
                                }
                            }
                        }
                    }

                    // Cross-contact
                    if let warnings = result?.crossContactWarnings, !warnings.isEmpty {
                        AGCard {
                            VStack(alignment: .leading, spacing: 12) {
                                AGSectionHeader(title: "Cross-contact warnings")
                                VStack(alignment: .leading, spacing: 8) {
                                    ForEach(warnings, id: \.self) { w in
                                        HStack(alignment: .top, spacing: 10) {
                                            Image(systemName: "exclamationmark.triangle.fill")
                                                .font(.system(size: 12)).foregroundStyle(AGColor.warning).padding(.top, 2)
                                            Text(w).font(.system(size: 14, weight: .medium)).foregroundStyle(AGColor.darkText)
                                        }
                                    }
                                }
                            }
                        }
                    }

                    // Info flags
                    if let flags = result?.infoFlags, !flags.isEmpty {
                        AGCard {
                            VStack(alignment: .leading, spacing: 12) {
                                AGSectionHeader(title: "Notes")
                                VStack(alignment: .leading, spacing: 8) {
                                    ForEach(flags, id: \.self) { flag in
                                        HStack(alignment: .top, spacing: 10) {
                                            Image(systemName: "info.circle.fill")
                                                .font(.system(size: 12)).foregroundStyle(AGColor.primary).padding(.top, 2)
                                            Text(flag).font(.system(size: 14, weight: .medium)).foregroundStyle(AGColor.darkText)
                                        }
                                    }
                                }
                            }
                        }
                    }

                    // Normalized text
                    if let text = result?.normalizedText, !text.isEmpty {
                        AGCard {
                            VStack(alignment: .leading, spacing: 8) {
                                AGSectionHeader(title: "Normalized text")
                                Text(text)
                                    .font(.system(size: 13, weight: .regular))
                                    .foregroundStyle(AGColor.neutral)
                                    .lineSpacing(2)
                            }
                        }
                    }

                    // CTA row
                    VStack(spacing: 10) {
                        AGPrimaryButton(title: "Scan another label", icon: "arrow.clockwise") {
                            restartScanFlow()
                        }
                        Button { goToHistory() } label: {
                            Text("View history")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundStyle(AGColor.darkText)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 15)
                                .background(AGColor.card)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                                        .stroke(AGColor.border, lineWidth: 1)
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 18)
                .padding(.top, 14)
                .padding(.bottom, 30)
            }

            if showToast {
                AGToastBanner(message: "Scan analyzed and saved", style: .success)
                    .padding(.horizontal, 18)
                    .padding(.top, 12)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            checkInContact = AppDataManager.fetchOrCreatePrimaryEmergencyContact(context: modelContext)
            if scanSession.isNewResult {
                scanSession.isNewResult = false
                showToast = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) { showToast = false }
            }
        }
        .animation(.easeInOut(duration: 0.25), value: showToast)
        .animation(.easeInOut(duration: 0.2), value: checkInScheduledMinutes)
        .sheet(isPresented: $showCheckIn) {
            CheckInSheet(
                verdict: result?.verdict ?? .caution,
                matchedAllergens: result?.matchedUserAllergens ?? [],
                contact: checkInContact,
                onScheduled: { mins in
                    scheduleCheckIn(minutes: mins)
                    showCheckIn = false
                },
                onDismiss: { showCheckIn = false }
            )
        }
    }

    // MARK: - Check-in logic

    private func scheduleCheckIn(minutes: Int) {
        let contactName = checkInContact?.name.isEmpty == false
            ? checkInContact!.name : "your emergency contact"

        let content = UNMutableNotificationContent()
        content.title = "Check-in reminder"
        content.body = "It\'s been \(minutes) minutes since you ate something risky. How are you feeling? Tap to follow up with \(contactName)."
        content.sound = .default
        content.interruptionLevel = .timeSensitive

        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: TimeInterval(minutes * 60), repeats: false
        )
        UNUserNotificationCenter.current().add(
            UNNotificationRequest(identifier: ScanSessionStore.checkInNotificationID, content: content, trigger: trigger)
        )

        if let phone = checkInContact?.phone.trimmingCharacters(in: .whitespacesAndNewlines), !phone.isEmpty {
            let digits = phone.filter { $0.isNumber || $0 == "+" }
            let allergenList = result?.matchedUserAllergens.joined(separator: ", ") ?? "a risky product"
            let body = "Hi \(contactName), I just ate something that may contain \(allergenList). Can you check on me in \(minutes) minutes? — AllerGuard"
            let encoded = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            if let url = URL(string: "sms:\(digits)&body=\(encoded)") {
                UIApplication.shared.open(url)
            }
        }

        scanSession.checkInActive = true
        scanSession.checkInContactName = contactName
        scanSession.checkInFireDate = Date().addingTimeInterval(TimeInterval(minutes * 60))
        checkInScheduledMinutes = minutes
    }

    private func cancelCheckIn() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(
            withIdentifiers: [ScanSessionStore.checkInNotificationID]
        )
        scanSession.checkInActive = false
        scanSession.checkInContactName = ""
        scanSession.checkInFireDate = nil
        checkInScheduledMinutes = nil
    }

    private func verdictDetail(for result: AllergenAnalysisResult?) -> String {
        guard let result else { return "No analysis result is available." }
        switch result.verdict {
        case .unsafe:
            return result.matchedUserAllergens.isEmpty
                ? "Potential allergen risk detected."
                : "Direct match found for: \(result.matchedUserAllergens.joined(separator: ", "))."
        case .caution: return "No direct match found, but warning language suggests cross-contact risk."
        case .looksClear: return "No direct allergen match or warning phrase detected."
        case .uncertain: return "The app could not confidently analyze this label."
        }
    }

    private func formattedNow() -> String {
        let f = DateFormatter(); f.dateStyle = .none; f.timeStyle = .short
        return f.string(from: Date())
    }

    private func restartScanFlow() {
        scanSession.selectedImage = nil; scanSession.extractedText = ""
        scanSession.analysisResult = nil; scanSession.shouldReturnToScanRoot = true
        dismiss()
    }

    private func goToHistory() {
        scanSession.shouldReturnToScanRoot = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { scanSession.selectedTab = 2 }
    }
}

// MARK: - 10 Product Lookup

struct ProductLookupView: View {
    @State private var query = ""

    var body: some View {
        ZStack {
            AGColor.bg.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    SectionTitle(
                        title: "Find a product",
                        subtitle: "Search by barcode or product name when the item is already known in the database."
                    )

                    AGCard {
                        VStack(spacing: 12) {
                            HStack(spacing: 10) {
                                Image(systemName: "magnifyingglass")
                                    .foregroundStyle(AGColor.neutral)

                                TextField("Search product", text: $query)
                                    .font(.system(size: 17, weight: .medium))
                                    .foregroundStyle(AGColor.darkText)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 16)
                            .background(AGColor.cardSoft)
                            .overlay(
                                RoundedRectangle(cornerRadius: 18, style: .continuous)
                                    .stroke(AGColor.border, lineWidth: 1)
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))

                            AGPrimaryButton(title: "Scan Barcode", icon: "barcode.viewfinder")
                        }
                    }

                    VStack(spacing: 14) {
                        ProductRowCard(name: "Choco Crunch Cereal", brand: "Kello", subtitle: "Contains peanut and soy")
                        ProductRowCard(name: "Sea Salt Rice Cakes", brand: "PureFoods", subtitle: "No major allergen match found")
                        ProductRowCard(name: "Sesame Breadsticks", brand: "Baker's Oven", subtitle: "Contains wheat and sesame")
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 28)
            }
        }
        .navigationTitle("Product Lookup")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ProductRowCard: View {
    let name: String
    let brand: String
    let subtitle: String

    var body: some View {
        AGCard {
            VStack(alignment: .leading, spacing: 8) {
                Text(name)
                    .font(.headline)
                    .foregroundStyle(AGColor.darkText)

                Text(brand)
                    .font(.subheadline)
                    .foregroundStyle(AGColor.neutral)

                Text(subtitle)
                    .font(.footnote)
                    .foregroundStyle(AGColor.bodyText)
            }
        }
    }
}

// MARK: - 11 History

// Date range preset options
enum HistoryDateRange: String, CaseIterable, Identifiable {
    case all   = "All time"
    case today = "Today"
    case week  = "This week"
    case month = "This month"
    case custom = "Custom"
    var id: String { rawValue }
}

struct HistoryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \ScanRecord.createdAt, order: .reverse) private var records: [ScanRecord]

    @State private var searchText: String = ""
    @State private var verdictFilter: ScanVerdict? = nil
    @State private var dateRange: HistoryDateRange = .all
    @State private var customStart: Date = Calendar.current.startOfDay(for: Date())
    @State private var customEnd: Date = Date()
    @State private var showCustomDateSheet = false
    @State private var showSearchBar = false

    var filteredRecords: [ScanRecord] {
        records.filter(byVerdict).filter(byDate).filter(bySearch)
    }

    var hasActiveFilters: Bool {
        !searchText.isEmpty || verdictFilter != nil || dateRange != .all
    }

    var body: some View {
        ZStack {
            AGColor.bg.ignoresSafeArea()
            VStack(spacing: 0) {

                // Search bar
                if showSearchBar {
                    HStack(spacing: 10) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundStyle(AGColor.neutral)
                        TextField("Search ingredients, allergens…", text: $searchText)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(AGColor.darkText)
                            .autocorrectionDisabled()
                        if !searchText.isEmpty {
                            Button { searchText = "" } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.system(size: 15))
                                    .foregroundStyle(AGColor.neutral)
                            }.buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 14).padding(.vertical, 12)
                    .background(AGColor.card)
                    .overlay(RoundedRectangle(cornerRadius: 14, style: .continuous).stroke(AGColor.border, lineWidth: 1))
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    .padding(.horizontal, 18).padding(.top, 10).padding(.bottom, 6)
                    .transition(.move(edge: .top).combined(with: .opacity))
                }

                ScrollView {
                    VStack(alignment: .leading, spacing: 14) {

                        // Stats strip
                        if !records.isEmpty {
                            let unsafe  = records.filter { $0.verdict == .unsafe }.count
                            let caution = records.filter { $0.verdict == .caution }.count
                            let clear   = records.filter { $0.verdict == .looksClear }.count
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    StatPill(label: "Total",   value: "\(records.count)", color: AGColor.primary, soft: AGColor.primarySoft)
                                    StatPill(label: "Unsafe",  value: "\(unsafe)",         color: AGColor.danger,  soft: AGColor.dangerSoft)
                                    StatPill(label: "Caution", value: "\(caution)",        color: AGColor.warning, soft: AGColor.warningSoft)
                                    StatPill(label: "Clear",   value: "\(clear)",          color: AGColor.success, soft: AGColor.successSoft)
                                }.padding(.horizontal, 18)
                            }
                        }

                        // Date range pills
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(HistoryDateRange.allCases) { range in
                                    Button {
                                        if range == .custom { showCustomDateSheet = true }
                                        else { dateRange = range }
                                    } label: {
                                        Text(range.rawValue)
                                            .font(.system(size: 13, weight: .semibold))
                                            .foregroundStyle(dateRange == range ? .white : AGColor.darkText)
                                            .padding(.horizontal, 14).padding(.vertical, 8)
                                            .background(dateRange == range ? AGColor.primary : AGColor.card)
                                            .overlay(Capsule().stroke(dateRange == range ? AGColor.primary : AGColor.border, lineWidth: 1))
                                            .clipShape(Capsule())
                                    }.buttonStyle(.plain)
                                }
                            }.padding(.horizontal, 18)
                        }

                        // Verdict filter chips
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                Button { verdictFilter = nil } label: {
                                    verdictChip("All results", selected: verdictFilter == nil, color: AGColor.primary)
                                }
                                ForEach(ScanVerdict.allCases, id: \.self) { v in
                                    Button { verdictFilter = v } label: {
                                        verdictChip(v.rawValue, selected: verdictFilter == v, color: v.color)
                                    }
                                }
                            }.padding(.horizontal, 18)
                        }

                        // Active filter summary
                        if hasActiveFilters {
                            HStack {
                                Image(systemName: "line.3.horizontal.decrease.circle.fill")
                                    .font(.system(size: 13)).foregroundStyle(AGColor.primary)
                                Text(activeFilterSummary)
                                    .font(.system(size: 13, weight: .medium)).foregroundStyle(AGColor.neutral)
                                Spacer()
                                Button { clearAllFilters() } label: {
                                    Text("Clear").font(.system(size: 13, weight: .semibold)).foregroundStyle(AGColor.primary)
                                }.buttonStyle(.plain)
                            }.padding(.horizontal, 18)
                        }

                        // Results
                        if records.isEmpty {
                            AGCard {
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("No scans yet")
                                        .font(.system(size: 15, weight: .semibold)).foregroundStyle(AGColor.darkText)
                                    Text("Run a label scan and your results will appear here.")
                                        .font(.system(size: 13, weight: .medium)).foregroundStyle(AGColor.neutral).lineSpacing(2)
                                    NavigationLink { LiveScanView() } label: {
                                        Text("Start a scan")
                                            .font(.system(size: 15, weight: .semibold)).foregroundStyle(.white)
                                            .padding(.horizontal, 16).padding(.vertical, 10)
                                            .background(AGColor.primary)
                                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                                    }.buttonStyle(.plain).padding(.top, 4)
                                }
                            }.padding(.horizontal, 18)
                        } else if filteredRecords.isEmpty {
                            AGCard {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("No matching scans")
                                        .font(.system(size: 15, weight: .semibold)).foregroundStyle(AGColor.darkText)
                                    Text("Try adjusting your search or filter.")
                                        .font(.system(size: 13, weight: .medium)).foregroundStyle(AGColor.neutral).lineSpacing(2)
                                    Button { clearAllFilters() } label: {
                                        Text("Clear filters").font(.system(size: 14, weight: .semibold)).foregroundStyle(AGColor.primary)
                                    }.buttonStyle(.plain).padding(.top, 2)
                                }
                            }.padding(.horizontal, 18)
                        } else {
                            VStack(spacing: 10) {
                                ForEach(filteredRecords) { record in
                                    NavigationLink { ScanRecordDetailView(record: record) } label: {
                                        HistoryRowCard(record: record, searchText: searchText)
                                    }
                                    .buttonStyle(.plain)
                                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                        Button(role: .destructive) { deleteRecord(record) } label: {
                                            Label("Delete", systemImage: "trash")
                                        }
                                    }
                                }
                            }.padding(.horizontal, 18)
                        }
                    }
                    .padding(.top, 14).padding(.bottom, 30)
                }
            }
        }
        .navigationTitle("History")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        showSearchBar.toggle()
                        if !showSearchBar { searchText = "" }
                    }
                } label: {
                    Image(systemName: showSearchBar ? "xmark" : "magnifyingglass")
                        .font(.system(size: 16, weight: .medium)).foregroundStyle(AGColor.primary)
                }
            }
        }
        .animation(.easeInOut(duration: 0.2), value: showSearchBar)
        .sheet(isPresented: $showCustomDateSheet) {
            CustomDateRangeSheet(start: $customStart, end: $customEnd) {
                dateRange = .custom
                showCustomDateSheet = false
            }
        }
    }

    // MARK: - Filter logic

    private func byVerdict(_ r: ScanRecord) -> Bool {
        guard let f = verdictFilter else { return true }
        return r.verdict == f
    }

    private func byDate(_ r: ScanRecord) -> Bool {
        let cal = Calendar.current
        let now = Date()
        switch dateRange {
        case .all:   return true
        case .today: return cal.isDateInToday(r.createdAt)
        case .week:
            guard let s = cal.date(byAdding: .day, value: -6, to: cal.startOfDay(for: now)) else { return true }
            return r.createdAt >= s
        case .month:
            guard let s = cal.date(byAdding: .month, value: -1, to: now) else { return true }
            return r.createdAt >= s
        case .custom:
            let s = cal.startOfDay(for: customStart)
            let e = cal.date(byAdding: .day, value: 1, to: cal.startOfDay(for: customEnd)) ?? customEnd
            return r.createdAt >= s && r.createdAt < e
        }
    }

    private func bySearch(_ r: ScanRecord) -> Bool {
        let q = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !q.isEmpty else { return true }
        if r.extractedText.lowercased().contains(q) { return true }
        if r.matchedAllergens.contains(where: { $0.lowercased().contains(q) }) { return true }
        if r.cautionAllergens.contains(where: { $0.lowercased().contains(q) }) { return true }
        if r.matchedEvidence.contains(where: { $0.lowercased().contains(q) }) { return true }
        return false
    }

    private var activeFilterSummary: String {
        var parts: [String] = []
        if !searchText.isEmpty { parts.append("\"\(searchText)\"") }
        if let v = verdictFilter { parts.append(v.rawValue) }
        if dateRange != .all { parts.append(dateRange.rawValue) }
        return "\(filteredRecords.count) result\(filteredRecords.count == 1 ? "" : "s") · \(parts.joined(separator: " · "))"
    }

    private func clearAllFilters() {
        searchText = ""; verdictFilter = nil; dateRange = .all
    }

    @ViewBuilder
    private func verdictChip(_ title: String, selected: Bool, color: Color) -> some View {
        Text(title)
            .font(.system(size: 13, weight: .semibold))
            .foregroundStyle(selected ? color : AGColor.neutral)
            .padding(.horizontal, 12).padding(.vertical, 7)
            .background(selected ? color.opacity(0.12) : AGColor.card)
            .overlay(Capsule().stroke(selected ? color.opacity(0.4) : AGColor.border, lineWidth: 1))
            .clipShape(Capsule())
    }

    private func deleteRecord(_ record: ScanRecord) {
        modelContext.delete(record)
        try? modelContext.save()
    }
}

// MARK: - History supporting views

struct StatPill: View {
    let label: String; let value: String; let color: Color; let soft: Color
    var body: some View {
        HStack(spacing: 6) {
            Text(value).font(.system(size: 16, weight: .bold)).foregroundStyle(color)
            Text(label).font(.system(size: 12, weight: .medium)).foregroundStyle(color.opacity(0.7))
        }
        .padding(.horizontal, 14).padding(.vertical, 8)
        .background(soft).clipShape(Capsule())
    }
}

struct HistoryRowCard: View {
    let record: ScanRecord
    let searchText: String

    private var allergenDisplay: [String] {
        Array((record.matchedAllergens.prefix(3) + record.cautionAllergens.prefix(2)).prefix(4))
    }

    var body: some View {
        AGCard {
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 3) {
                        Text(fmtDate(record.createdAt))
                            .font(.system(size: 14, weight: .semibold)).foregroundStyle(AGColor.darkText)
                        Text(fmtTime(record.createdAt))
                            .font(.system(size: 12, weight: .medium)).foregroundStyle(AGColor.hint)
                    }
                    Spacer()
                    Text(record.verdict.rawValue)
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(record.verdict.color)
                        .padding(.horizontal, 10).padding(.vertical, 5)
                        .background(record.verdict.color.opacity(0.12)).clipShape(Capsule())
                }
                if !allergenDisplay.isEmpty {
                    HStack(spacing: 6) {
                        ForEach(allergenDisplay, id: \.self) { a in
                            let unsafe = record.matchedAllergens.contains(a)
                            AGSmallChip(title: a,
                                color: unsafe ? AGColor.danger : AGColor.warning,
                                softColor: unsafe ? AGColor.dangerSoft : AGColor.warningSoft)
                        }
                        let total = record.matchedAllergens.count + record.cautionAllergens.count
                        if total > 4 {
                            AGSmallChip(title: "+\(total-4)", color: AGColor.neutral, softColor: AGColor.cardSoft)
                        }
                    }
                }
                let preview = record.extractedText.trimmingCharacters(in: .whitespacesAndNewlines)
                if !preview.isEmpty {
                    HighlightedText(text: preview, highlight: searchText)
                        .font(.system(size: 13)).foregroundStyle(AGColor.neutral).lineLimit(2)
                }
                HStack(spacing: 8) {
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 2).fill(AGColor.border).frame(height: 3)
                            RoundedRectangle(cornerRadius: 2)
                                .fill(record.verdict.color.opacity(0.6))
                                .frame(width: geo.size.width * record.confidenceScore, height: 3)
                        }
                    }.frame(height: 3)
                    Text("\(Int(record.confidenceScore * 100))%")
                        .font(.system(size: 11, weight: .semibold)).foregroundStyle(AGColor.hint)
                        .frame(width: 28, alignment: .trailing)
                }
            }
        }
    }

    private func fmtDate(_ d: Date) -> String {
        let f = DateFormatter(); f.dateStyle = .medium; f.timeStyle = .none; return f.string(from: d)
    }
    private func fmtTime(_ d: Date) -> String {
        let f = DateFormatter(); f.dateStyle = .none; f.timeStyle = .short; return f.string(from: d)
    }
}

struct HighlightedText: View {
    let text: String
    let highlight: String

    var body: some View {
        Text(buildAttributed())
            .lineLimit(2)
    }

    private func buildAttributed() -> AttributedString {
        var result = AttributedString(text)
        let q = highlight.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !q.isEmpty else { return result }

        let base = text
        var offset = base.startIndex

        while let range = base.range(of: q, options: .caseInsensitive, range: offset..<base.endIndex) {
            // Calculate offset in original string
            let startDist = base.distance(from: base.startIndex, to: range.lowerBound)
            let length    = base.distance(from: range.lowerBound, to: range.upperBound)

            let attrStart = result.index(result.startIndex, offsetByCharacters: startDist)
            let attrEnd   = result.index(attrStart, offsetByCharacters: length)
            let attrRange = attrStart..<attrEnd

            result[attrRange].inlinePresentationIntent = .stronglyEmphasized
            result[attrRange].foregroundColor = Color(red: 0.10, green: 0.40, blue: 0.90)

            offset = range.upperBound
        }
        return result
    }
}

struct CustomDateRangeSheet: View {
    @Binding var start: Date
    @Binding var end: Date
    let onApply: () -> Void

    var body: some View {
        NavigationStack {
            ZStack {
                AGColor.bg.ignoresSafeArea()
                VStack(alignment: .leading, spacing: 20) {
                    AGCard {
                        VStack(alignment: .leading, spacing: 16) {
                            VStack(alignment: .leading, spacing: 6) {
                                AGSectionHeader(title: "From")
                                DatePicker("", selection: $start, in: ...end, displayedComponents: .date)
                                    .datePickerStyle(.graphical).tint(AGColor.primary).labelsHidden()
                            }
                            Divider().overlay(AGColor.border)
                            VStack(alignment: .leading, spacing: 6) {
                                AGSectionHeader(title: "To")
                                DatePicker("", selection: $end, in: start..., displayedComponents: .date)
                                    .datePickerStyle(.graphical).tint(AGColor.primary).labelsHidden()
                            }
                        }
                    }
                    AGPrimaryButton(title: "Apply date range", icon: "checkmark") { onApply() }
                }
                .padding(.horizontal, 18).padding(.top, 14)
            }
            .navigationTitle("Custom range").navigationBarTitleDisplayMode(.inline)
        }
        .presentationDetents([.large])
    }
}
// MARK: - Scan Record Detail

struct ScanRecordDetailView: View {
    let record: ScanRecord

    var body: some View {
        ZStack {
            AGColor.bg.ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {

                    // Header
                    VStack(alignment: .leading, spacing: 6) {
                        Text(formattedDate(record.createdAt))
                            .font(.system(size: 11, weight: .semibold))
                            .tracking(0.5)
                            .foregroundStyle(AGColor.neutral)
                        Text("Saved scan")
                            .font(.system(size: 24, weight: .bold))
                            .tracking(-0.3)
                            .foregroundStyle(AGColor.darkText)
                    }

                    // Verdict
                    AGVerdictCard(
                        verdict: record.verdict,
                        detail: verdictDetail(for: record.verdict),
                        confidenceScore: record.confidenceScore
                    )

                    // Unsafe allergens
                    if !record.matchedAllergens.isEmpty {
                        AGCard {
                            VStack(alignment: .leading, spacing: 12) {
                                AGSectionHeader(title: "Matched allergens")
                                HStack(spacing: 8) {
                                    ForEach(record.matchedAllergens, id: \.self) { a in
                                        AGSmallChip(title: a, color: AGColor.danger, softColor: AGColor.dangerSoft)
                                    }
                                }
                            }
                        }
                    }

                    // Caution allergens
                    if !record.cautionAllergens.isEmpty {
                        AGCard {
                            VStack(alignment: .leading, spacing: 12) {
                                AGSectionHeader(title: "Cross-contact risk")
                                HStack(spacing: 8) {
                                    ForEach(record.cautionAllergens, id: \.self) { a in
                                        AGSmallChip(title: a, color: AGColor.warning, softColor: AGColor.warningSoft)
                                    }
                                }
                                Text("Found in cross-contact warnings, not the ingredients list.")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundStyle(AGColor.neutral)
                            }
                        }
                    }

                    // Info-only allergens
                    if !record.infoOnlyAllergens.isEmpty {
                        AGCard {
                            VStack(alignment: .leading, spacing: 12) {
                                AGSectionHeader(title: "Monitoring only")
                                HStack(spacing: 8) {
                                    ForEach(record.infoOnlyAllergens, id: \.self) { a in
                                        AGSmallChip(title: a, color: AGColor.neutral, softColor: AGColor.cardSoft)
                                    }
                                }
                                Text("Detected but suppressed by your sensitivity settings.")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundStyle(AGColor.neutral)
                            }
                        }
                    }

                    // Evidence
                    if !record.matchedEvidence.isEmpty {
                        AGCard {
                            VStack(alignment: .leading, spacing: 12) {
                                AGSectionHeader(title: "Evidence found")
                                VStack(alignment: .leading, spacing: 8) {
                                    ForEach(record.matchedEvidence, id: \.self) { item in
                                        HStack(alignment: .top, spacing: 10) {
                                            Circle().fill(AGColor.warning).frame(width: 7, height: 7).padding(.top, 5)
                                            Text(item).font(.system(size: 14, weight: .medium)).foregroundStyle(AGColor.darkText)
                                        }
                                    }
                                }
                            }
                        }
                    }

                    // Cross-contact warnings
                    if !record.crossContactWarnings.isEmpty {
                        AGCard {
                            VStack(alignment: .leading, spacing: 12) {
                                AGSectionHeader(title: "Cross-contact warnings")
                                VStack(alignment: .leading, spacing: 8) {
                                    ForEach(record.crossContactWarnings, id: \.self) { w in
                                        HStack(alignment: .top, spacing: 10) {
                                            Image(systemName: "exclamationmark.triangle.fill")
                                                .font(.system(size: 12)).foregroundStyle(AGColor.warning).padding(.top, 2)
                                            Text(w).font(.system(size: 14, weight: .medium)).foregroundStyle(AGColor.darkText)
                                        }
                                    }
                                }
                            }
                        }
                    }

                    // Info flags
                    if !record.infoFlags.isEmpty {
                        AGCard {
                            VStack(alignment: .leading, spacing: 12) {
                                AGSectionHeader(title: "Notes")
                                VStack(alignment: .leading, spacing: 8) {
                                    ForEach(record.infoFlags, id: \.self) { flag in
                                        HStack(alignment: .top, spacing: 10) {
                                            Image(systemName: "info.circle.fill")
                                                .font(.system(size: 12)).foregroundStyle(AGColor.primary).padding(.top, 2)
                                            Text(flag).font(.system(size: 14, weight: .medium)).foregroundStyle(AGColor.darkText)
                                        }
                                    }
                                }
                            }
                        }
                    }

                    // Extracted text
                    if !record.extractedText.isEmpty {
                        AGCard {
                            VStack(alignment: .leading, spacing: 8) {
                                AGSectionHeader(title: "Extracted text")
                                Text(record.extractedText)
                                    .font(.system(size: 13, weight: .regular))
                                    .foregroundStyle(AGColor.neutral)
                                    .lineSpacing(2)
                            }
                        }
                    }
                }
                .padding(.horizontal, 18)
                .padding(.top, 14)
                .padding(.bottom, 30)
            }
        }
        .navigationTitle("Saved result")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func formattedDate(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .short
        return f.string(from: date)
    }

    private func verdictDetail(for verdict: ScanVerdict) -> String {
        switch verdict {
        case .unsafe:        return "This saved scan included direct ingredient matches."
        case .caution:       return "This saved scan included cross-contact or warning language."
        case .looksClear:    return "No direct match or warning phrase was detected."
        case .uncertain:     return "This saved scan could not be analyzed confidently."
        }
    }
}

// MARK: - 12 Emergency Help

struct EmergencyHelpView: View {
    @Environment(\.modelContext) private var modelContext

    @State private var contact: EmergencyContactEntity?
    @State private var showNoContactAlert = false
    @State private var showNoPhoneAlert = false

    private var contactName: String {
        guard let contact, !contact.name.isEmpty else { return "No contact saved" }
        return contact.name
    }

    private var contactRelationship: String {
        guard let contact, !contact.relationship.isEmpty else { return "" }
        return contact.relationship
    }

    private var contactPhone: String {
        guard let contact, !contact.phone.isEmpty else { return "" }
        return contact.phone
    }

    private var hasContact: Bool {
        guard let contact else { return false }
        return !contact.name.isEmpty || !contact.phone.isEmpty
    }

    private var hasPhone: Bool {
        guard let contact else { return false }
        return !contact.phone.isEmpty
    }

    private var medicalNoteText: String {
        guard let contact else { return "No medical notes saved." }

        var parts: [String] = []

        if !contact.notes.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            parts.append(contact.notes)
        }

        if contact.hasAsthmaHistory {
            parts.append("Asthma history: Yes.")
        }

        if !contact.name.isEmpty {
            let rel = contact.relationship.isEmpty ? "Primary contact" : contact.relationship
            parts.append("\(rel): \(contact.name).")
        }

        return parts.isEmpty ? "No medical notes saved." : parts.joined(separator: " ")
    }

    var body: some View {
        ZStack {
            AGColor.bg.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    SectionTitle(
                        title: "Emergency help",
                        subtitle: "Fast action for allergic reactions. Tap to call or message your saved contact directly."
                    )

                    VerdictBanner(
                        verdict: .caution,
                        detail: "If symptoms are serious, use prescribed medication and seek immediate medical help."
                    )

                    // Contact card
                    AGCard {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Image(systemName: "person.crop.circle.fill")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundStyle(AGColor.primary)
                                Text("Primary contact")
                                    .font(.headline)
                                    .foregroundStyle(AGColor.darkText)
                            }

                            if hasContact {
                                Text(contactName)
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundStyle(AGColor.darkText)

                                if !contactRelationship.isEmpty {
                                    Text(contactRelationship)
                                        .font(.subheadline)
                                        .foregroundStyle(AGColor.neutral)
                                }

                                if !contactPhone.isEmpty {
                                    Text(contactPhone)
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundStyle(AGColor.primary)
                                }
                            } else {
                                Text("No emergency contact saved yet.")
                                    .font(.subheadline)
                                    .foregroundStyle(AGColor.neutral)

                                NavigationLink {
                                    EmergencySetupView()
                                } label: {
                                    Text("Add emergency contact →")
                                        .font(.system(size: 15, weight: .semibold))
                                        .foregroundStyle(AGColor.primary)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }

                    // Action buttons
                    VStack(spacing: 14) {
                        AGPrimaryButton(title: "Call \(hasContact ? contactName : "Primary Contact")", icon: "phone.fill") {
                            callContact()
                        }
                        .opacity(hasPhone ? 1.0 : 0.55)

                        AGPrimaryButton(title: "Send SMS Alert", icon: "message.fill") {
                            sendSMS()
                        }
                        .opacity(hasPhone ? 1.0 : 0.55)

                        AGSecondaryButton(title: "Call Emergency Services (112 / 911)") {
                            callEmergencyServices()
                        }
                    }

                    // Medical note
                    AGCard {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Image(systemName: "cross.case.fill")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(AGColor.danger)
                                Text("Saved medical note")
                                    .font(.headline)
                                    .foregroundStyle(AGColor.darkText)
                            }

                            Text(medicalNoteText)
                                .font(.subheadline)
                                .foregroundStyle(AGColor.neutral)
                                .lineSpacing(2)
                        }
                    }

                    // First response steps
                    AGCard {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("First response steps")
                                .font(.headline)
                                .foregroundStyle(AGColor.darkText)

                            Text("1. Stop eating the food.\n2. Use prescribed medication if advised by a clinician.\n3. Contact emergency services if breathing trouble, swelling, or severe symptoms begin.")
                                .font(.subheadline)
                                .foregroundStyle(AGColor.neutral)
                                .lineSpacing(3)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 28)
            }
        }
        .navigationTitle("Emergency Help")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            contact = AppDataManager.fetchOrCreatePrimaryEmergencyContact(context: modelContext)
        }
        .alert("No phone number saved", isPresented: $showNoPhoneAlert) {
            Button("OK", role: .cancel) {}
            Button("Add Contact") {}
        } message: {
            Text("Go to Emergency Setup in your profile to add a phone number for your primary contact.")
        }
    }

    // MARK: - Actions

    private func callContact() {
        guard hasPhone else {
            showNoPhoneAlert = true
            return
        }
        let digits = contactPhone.filter { $0.isNumber || $0 == "+" }
        if let url = URL(string: "tel://\(digits)") {
            UIApplication.shared.open(url)
        }
    }

    private func sendSMS() {
        guard hasPhone else {
            showNoPhoneAlert = true
            return
        }
        let digits = contactPhone.filter { $0.isNumber || $0 == "+" }
        let body = "ALLERGEN ALERT: I may be having an allergic reaction. Please check on me immediately."
        let encodedBody = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        if let url = URL(string: "sms:\(digits)&body=\(encodedBody)") {
            UIApplication.shared.open(url)
        }
    }

    private func callEmergencyServices() {
        // Try 112 first (international), fallback to 911
        if let url = URL(string: "tel://112") {
            UIApplication.shared.open(url)
        }
    }
}

// MARK: - 13 Profile & Settings

struct ProfileSettingsView: View {
    @Environment(\.modelContext) private var modelContext

    @State private var notificationsEnabled = true
    @State private var currentProfile: UserProfile?
    @State private var currentContact: EmergencyContactEntity?
    @State private var showClearAlert = false
    @State private var editingName = false
    @State private var nameInput = ""

    private var allergenChips: [String] {
        guard let p = currentProfile else { return [] }
        let custom = p.customAllergen.trimmingCharacters(in: .whitespacesAndNewlines)
        return p.allergies + (custom.isEmpty ? [] : [custom])
    }

    private func sensitivityFor(_ allergen: String) -> SensitivityLevel {
        guard let p = currentProfile else { return .strict }
        let raw = p.allergenSensitivities[allergen]
        return SensitivityLevel(rawValue: raw ?? "") ?? .strict
    }

    private func colorFor(_ level: SensitivityLevel) -> (Color, Color) {
        switch level {
        case .strict:        return (AGColor.danger,  AGColor.dangerSoft)
        case .moderate:      return (AGColor.warning, AGColor.warningSoft)
        case .informational: return (AGColor.primary, AGColor.primarySoft)
        }
    }

    private var sensitivityText: String {
        currentProfile?.sensitivityLevel.isEmpty == false
            ? (currentProfile?.sensitivityLevel ?? "Not set")
            : "Not set"
    }

    private var contactSummary: String {
        let all = AppDataManager.fetchAllContacts(context: modelContext)
        guard !all.isEmpty else { return "Not set" }
        let primary = all.first
        let name = primary?.name ?? ""
        let extra = all.count > 1 ? " +\(all.count - 1) more" : ""
        return name.isEmpty ? "Not set" : "\(name)\(extra)"
    }

    var body: some View {
        ZStack {
            AGColor.bg.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    profileHeader
                        .padding(.bottom, 22)

                    VStack(alignment: .leading, spacing: 20) {
                        // Allergen chips section — per-allergen sensitivity
                        VStack(alignment: .leading, spacing: 12) {
                            AGSectionHeader(title: "Your allergens")
                            AGCard {
                                VStack(alignment: .leading, spacing: 0) {
                                    if allergenChips.isEmpty {
                                        Text("No allergens saved yet")
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundStyle(AGColor.neutral)
                                            .padding(.bottom, 14)
                                    } else {
                                        ForEach(allergenChips, id: \.self) { allergen in
                                            let level = sensitivityFor(allergen)
                                            let (color, soft) = colorFor(level)
                                            HStack {
                                                Text(allergen)
                                                    .font(.system(size: 15, weight: .semibold))
                                                    .foregroundStyle(AGColor.darkText)
                                                Spacer()
                                                AGSmallChip(title: level.rawValue, color: color, softColor: soft)
                                            }
                                            .padding(.vertical, 10)
                                            if allergen != allergenChips.last {
                                                Divider().overlay(AGColor.border)
                                            }
                                        }
                                        Divider().overlay(AGColor.border)
                                            .padding(.top, 4)
                                    }
                                    HStack {
                                        Spacer()
                                        NavigationLink { AllergySetupView() } label: {
                                            Text("Edit allergens & sensitivity")
                                                .font(.system(size: 14, weight: .semibold))
                                                .foregroundStyle(AGColor.primary)
                                        }
                                        .buttonStyle(.plain)
                                    }
                                    .padding(.top, 10)
                                }
                            }
                        }

                        // Settings
                        VStack(alignment: .leading, spacing: 12) {
                            AGSectionHeader(title: "Settings")
                            AGCard {
                                VStack(spacing: 0) {
                                    NavigationLink { AllergySetupView() } label: {
                                        AGSettingsRow(title: "Edit allergy profile", icon: "person.crop.circle.badge.checkmark")
                                    }
                                    .buttonStyle(.plain)

                                    Divider().overlay(AGColor.border)

                                    NavigationLink { EmergencySetupView() } label: {
                                        AGSettingsRow(
                                            title: "Emergency contact",
                                            icon: "heart.text.square.fill",
                                            detail: contactSummary.isEmpty ? nil : contactSummary
                                        )
                                    }
                                    .buttonStyle(.plain)

                                    Divider().overlay(AGColor.border)

                                    AGSettingsRow(
                                        title: "Notifications",
                                        icon: "bell.fill",
                                        detail: notificationsEnabled ? "On" : "Off"
                                    )
                                    .overlay(alignment: .trailing) {
                                        Toggle("", isOn: $notificationsEnabled)
                                            .tint(AGColor.primary)
                                            .labelsHidden()
                                            .padding(.trailing, 0)
                                    }

                                    Divider().overlay(AGColor.border)

                                    NavigationLink { HistoryView() } label: {
                                        AGSettingsRow(title: "Scan history", icon: "clock.arrow.circlepath")
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }

                        // Privacy note
                        VStack(alignment: .leading, spacing: 12) {
                            AGSectionHeader(title: "Privacy")
                            AGCard {
                                HStack(spacing: 12) {
                                    Image(systemName: "lock.fill")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundStyle(AGColor.success)
                                    Text("All data stays on-device. Nothing is sent to a server.")
                                        .font(.system(size: 13, weight: .medium))
                                        .foregroundStyle(AGColor.neutral)
                                }
                            }
                        }

                        // Danger zone
                        VStack(alignment: .leading, spacing: 12) {
                            AGSectionHeader(title: "Danger zone")
                            AGCard {
                                Button {
                                    showClearAlert = true
                                } label: {
                                    AGSettingsRow(
                                        title: "Clear all data",
                                        icon: "trash.fill",
                                        dangerous: true
                                    )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .padding(.horizontal, 18)
                    .padding(.bottom, 30)
                }
            }
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            currentProfile = AppDataManager.fetchOrCreateUserProfile(context: modelContext)
            currentContact = AppDataManager.fetchOrCreatePrimaryEmergencyContact(context: modelContext)
            nameInput = currentProfile?.name ?? ""
        }
        .alert("Clear all data?", isPresented: $showClearAlert) {
            Button("Clear", role: .destructive) { }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("This will permanently delete your allergy profile, emergency contact, and all scan history.")
        }
    }

    private var profileHeader: some View {
        ZStack(alignment: .bottomLeading) {
            Rectangle()
                .fill(AGColor.primary)
                .frame(maxWidth: .infinity)
                .ignoresSafeArea(edges: .top)

            // Decorative circles
            Circle()
                .fill(Color.white.opacity(0.06))
                .frame(width: 140)
                .offset(x: 280, y: -10)

            HStack(spacing: 16) {
                // Avatar — tappable to edit name
                Button {
                    editingName = true
                } label: {
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.15))
                            .frame(width: 56, height: 56)
                        Text(profileInitials())
                            .font(.system(size: 20, weight: .bold))
                            .foregroundStyle(.white)

                        // Edit pencil badge
                        Image(systemName: "pencil")
                            .font(.system(size: 9, weight: .bold))
                            .foregroundStyle(AGColor.primary)
                            .frame(width: 18, height: 18)
                            .background(Color.white)
                            .clipShape(Circle())
                            .offset(x: 18, y: 18)
                    }
                }
                .buttonStyle(.plain)

                VStack(alignment: .leading, spacing: 4) {
                    // Inline name field or display
                    if editingName {
                        TextField("Your name", text: $nameInput)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(.white)
                            .tint(.white)
                            .submitLabel(.done)
                            .onSubmit { saveName() }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(Color.white.opacity(0.15))
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
                            )
                    } else {
                        Button {
                            editingName = true
                        } label: {
                            Text(nameInput.isEmpty ? "Tap to add your name" : nameInput)
                                .font(.system(size: 18, weight: .bold))
                                .foregroundStyle(nameInput.isEmpty ? .white.opacity(0.5) : .white)
                        }
                        .buttonStyle(.plain)
                    }

                    Text("\(allergenChips.count) allergen\(allergenChips.count == 1 ? "" : "s") · \(sensitivityText)")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(.white.opacity(0.75))
                }

                Spacer()

                // Done / Edit button
                if editingName {
                    Button {
                        saveName()
                    } label: {
                        Text("Done")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 7)
                            .background(Color.white.opacity(0.18))
                            .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 22)
            .animation(.easeInOut(duration: 0.2), value: editingName)
        }
    }

    private func saveName() {
        guard let profile = currentProfile else { return }
        profile.name = nameInput.trimmingCharacters(in: .whitespacesAndNewlines)
        AppDataManager.saveContext(modelContext)
        editingName = false
    }

    private func profileInitials() -> String {
        let name = nameInput.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !name.isEmpty else { return "AG" }
        let parts = name.split(separator: " ").prefix(2)
        return parts.compactMap { $0.first.map { String($0) } }.joined().uppercased()
    }
}
