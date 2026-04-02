import Foundation
import UIKit
import SwiftUI
import Combine
import SwiftData

@MainActor
final class ScanSessionStore: ObservableObject {
    @Published var selectedImage: UIImage?
    @Published var extractedText: String = ""
    @Published var isProcessing: Bool = false
    @Published var analysisResult: AllergenAnalysisResult?
    @Published var shouldReturnToScanRoot: Bool = false

    // Set true only when a fresh analysis just ran; consumed once by ScanResultView
    @Published var isNewResult: Bool = false

    // Drives tab selection in MainAppView — 0=Home 1=Scan 2=History 3=Profile
    @Published var selectedTab: Int = 0

    // Active check-in state — shown as a banner on Home while pending
    @Published var checkInActive: Bool = false
    @Published var checkInContactName: String = ""
    @Published var checkInFireDate: Date? = nil
    static let checkInNotificationID = "allerguard.checkin"

    // The PersistentIdentifier of the ScanRecord linked to the active check-in.
    // Used to present the reaction log sheet when the check-in expires.
    @Published var pendingReactionRecordID: PersistentIdentifier? = nil
}
