import SwiftUI

@MainActor
final class AppCover: ObservableObject {
    static let revealDuration: TimeInterval = 0.2

    @Published private(set) var isCoverVisible = false

    func handleScenePhase(_ phase: ScenePhase) {
        switch phase {
        case .inactive, .background:
            showCover()
        case .active:
            liftCover()
        @unknown default:
            break
        }
    }

    func deactivateImmediately() {
        liftCover()
    }

    private func showCover() {
        var transaction = Transaction()
        transaction.disablesAnimations = true
        withTransaction(transaction) { isCoverVisible = true }
    }

    private func liftCover() {
        guard isCoverVisible else { return }
        let animation = UIAccessibility.isReduceMotionEnabled
            ? nil
            : Animation.easeInOut(duration: Self.revealDuration)
        withAnimation(animation) { isCoverVisible = false }
    }
}
