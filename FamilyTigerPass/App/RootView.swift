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
        .preferredColorScheme(.light)
        .task {
            Seed.bootstrap(context: modelContext)
            try? modelContext.save()
        }
    }
}

#Preview {
    PreviewHost {
        RootView()
    }
}
