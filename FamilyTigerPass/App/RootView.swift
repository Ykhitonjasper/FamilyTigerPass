import SwiftData
import SwiftUI

struct RootView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @Environment(\.modelContext) private var modelContext
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let dependencies: AppDependencies
    @State private var launch: AppLaunch
    @StateObject private var appCover = AppCover()

    @MainActor
    init(dependencies: AppDependencies, launch: AppLaunch? = nil) {
        self.dependencies = dependencies
        _launch = State(initialValue: launch ?? AppLaunch(dependencies: dependencies))
    }

    var body: some View {
        ZStack {
            if let webView = displayedWeb {
                coveredWebView(webView)
                    .scaleEffect(webSettleScale)
            } else if case .native = launch.phase {
                coveredNative
            } else {
                AppTheme.bgBase.ignoresSafeArea()
            }
        }
        .overlay {
            loaderOverlay
        }
        .preferredColorScheme(.light)
        .tint(AppTheme.accent)
        .sensoryFeedback(.impact(weight: .medium), trigger: launch.loaderProgress >= 1)
        .task {
            Seed.bootstrap(context: modelContext)
            try? modelContext.save()
            await launch.start()
        }
    }

    private var webSettleScale: CGFloat {
        guard launch.phase.isLoading || launch.coverOpacity > 0.02 else { return 1 }
        return 1 + CGFloat(launch.coverOpacity) * 0.018
    }

    private var displayedWeb: WebViewController? {
        if case .web(let webView) = launch.phase { return webView }
        return launch.pendingWeb
    }

    private var revealAnimation: Animation? {
        guard !reduceMotion else { return nil }
        return .timingCurve(0.16, 1.0, 0.3, 1.0, duration: revealDuration)
    }

    private var revealDuration: TimeInterval {
        switch launch.coverStyle {
        case .scrim: return Timeouts.warmScrimMax
        case .warm: return Timeouts.warmRevealCrossfade
        case .branded, .invisible: return Timeouts.revealCrossfade
        }
    }

    @ViewBuilder
    private var loaderOverlay: some View {
        let veil = launch.coverOpacity
        Group {
            switch launch.phase {
            case .loading:
                switch launch.coverStyle {
                case .branded:
                    BrandedSplash(progress: launch.loaderProgress, veil: veil)
                case .warm:
                    WarmOverlay(progress: launch.loaderProgress, veil: veil)
                case .scrim:
                    WarmScrim(progress: launch.loaderProgress, veil: veil)
                case .invisible:
                    Color.clear
                }
            default:
                EmptyView()
            }
        }
        .animation(revealAnimation, value: veil)
    }

    private var coveredNative: some View {
        ZStack {
            nativeShell
            if appCover.isCoverVisible {
                FamilyTigerPassCover()
                    .transition(.opacity)
            }
        }
        .onChange(of: scenePhase) { _, phase in
            appCover.handleScenePhase(phase)
        }
    }

    @ViewBuilder
    private var nativeShell: some View {
        ZStack {
            AppBackground()
            if hasCompletedOnboarding {
                MainTabView()
            } else {
                OnboardingScreen()
            }
        }
    }

    private func coveredWebView(_ webView: WebViewController) -> some View {
        ZStack {
            WebViewScreen(webView: webView)

            if appCover.isCoverVisible {
                FamilyTigerPassCover()
                    .transition(.opacity)
            }
        }
        .ignoresSafeArea()
        .animation(revealAnimation, value: launch.coverOpacity)
        .onDisappear {
            appCover.deactivateImmediately()
        }
        .onChange(of: scenePhase) { _, phase in
            appCover.handleScenePhase(phase)
        }
    }
}

#Preview {
    PreviewHost {
        RootView(dependencies: AppDependencies(), launch: .previewNative())
    }
}
