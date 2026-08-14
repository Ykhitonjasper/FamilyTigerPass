import SwiftUI
import SwiftData

struct RootView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        ZStack {
            AppBackground()
            if hasCompletedOnboarding {
                MainTabView()
            } else {
                OnboardingScreen()
            }
        }
        .task {
            Seed.bootstrap(context: modelContext)
        }
    }
}

#Preview {
    PreviewHost {
        RootView()
    }
}
