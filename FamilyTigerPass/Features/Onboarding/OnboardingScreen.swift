import SwiftUI

struct OnboardingScreen: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var page = 0

    private let pages: [OnboardingPage.Model] = [
        .init(
            symbol: "fork.knife",
            title: "Kitchen math on one phone",
            bodyText: "Portions, bowls, and bag days for the dogs and cats at home. Not a live feeding log."
        ),
        .init(
            symbol: "folder",
            title: "Save into a household project",
            bodyText: "Park each result in a project so the next store run is one list."
        ),
        .init(
            symbol: "square.and.arrow.up",
            title: "Export before you go",
            bodyText: "PDF of the project. Estimates only — not veterinary advice, not for medication."
        ),
    ]

    var body: some View {
        ZStack {
            AppBackground()
            VStack(spacing: 0) {
                OnboardingPage(model: pages[page])
                    .id(page)
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .opacity))
                    .gesture(pageSwipe)
                dots
                    .padding(.bottom, 12)
                CTAButton(title: page == pages.count - 1 ? "Get started" : "Next") {
                    advance()
                }
                .padding(.horizontal)
                .padding(.bottom, 24)
            }
        }
        .sensoryFeedback(.selection, trigger: page)
    }

    private var dots: some View {
        HStack(spacing: 8) {
            ForEach(pages.indices, id: \.self) { index in
                Capsule()
                    .fill(index == page ? AppTheme.accent : AppTheme.hairline)
                    .frame(width: index == page ? 22 : 8, height: 8)
                    .accessibilityHidden(true)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Page \(page + 1) of \(pages.count)")
    }

    private var pageSwipe: some Gesture {
        DragGesture(minimumDistance: 24)
            .onEnded { value in
                if value.translation.width < -40 {
                    go(to: page + 1)
                } else if value.translation.width > 40 {
                    go(to: page - 1)
                }
            }
    }

    private func advance() {
        if page >= pages.count - 1 {
            hasCompletedOnboarding = true
        } else {
            go(to: page + 1)
        }
    }

    private func go(to next: Int) {
        guard pages.indices.contains(next), next != page else { return }
        withAnimation(.easeInOut(duration: 0.25)) {
            page = next
        }
    }
}

private struct OnboardingPage: View {
    struct Model: Hashable {
        let symbol: String
        let title: String
        let bodyText: String
    }

    let model: Model

    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: model.symbol)
                .font(.system(size: 48))
                .foregroundStyle(AppTheme.accent)
                .accessibilityHidden(true)
            Text(AppTheme.displayName)
                .font(.caption.weight(.semibold))
                .foregroundStyle(AppTheme.textMono)
            Text(model.title)
                .font(.title2.weight(.semibold))
                .foregroundStyle(AppTheme.textPrimary)
                .multilineTextAlignment(.center)
            Text(model.bodyText)
                .font(.body)
                .foregroundStyle(AppTheme.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 28)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .contentShape(Rectangle())
    }
}

#Preview {
    OnboardingScreen()
}
