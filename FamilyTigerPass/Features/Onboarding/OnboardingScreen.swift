import SwiftUI

struct OnboardingScreen: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var page = 0

    var body: some View {
        ZStack {
            AppBackground()
            VStack(spacing: 0) {
                TabView(selection: $page) {
                    OnboardingPage(
                        symbol: "fork.knife",
                        title: "Kitchen math on one phone",
                        bodyText: "Portions, bowls, and bag days for the dogs and cats at home. Not a live feeding log."
                    )
                    .tag(0)
                    OnboardingPage(
                        symbol: "folder",
                        title: "Save into a household project",
                        bodyText: "Park each result in a project so the next store run is one list."
                    )
                    .tag(1)
                    OnboardingPage(
                        symbol: "square.and.arrow.up",
                        title: "Export before you go",
                        bodyText: "PDF of the project. Estimates only — not veterinary advice, not for medication."
                    )
                    .tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .indexViewStyle(.page(backgroundDisplayMode: .always))

                CTAButton(title: page == 2 ? "Get started" : "Next") {
                    if page == 2 {
                        hasCompletedOnboarding = true
                    } else {
                        page += 1
                    }
                }
                .padding()
            }
        }
    }
}

private struct OnboardingPage: View {
    let symbol: String
    let title: String
    let bodyText: String

    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: symbol)
                .font(.system(size: 48))
                .foregroundStyle(AppTheme.accent)
                .accessibilityHidden(true)
            Text(AppTheme.displayName)
                .font(.caption.weight(.semibold))
                .foregroundStyle(AppTheme.textMono)
            Text(title)
                .font(.title2.weight(.semibold))
                .foregroundStyle(AppTheme.textPrimary)
                .multilineTextAlignment(.center)
            Text(bodyText)
                .font(.body)
                .foregroundStyle(AppTheme.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 28)
            Spacer()
        }
    }
}

#Preview {
    OnboardingScreen()
}
