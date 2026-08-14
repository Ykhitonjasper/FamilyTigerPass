import SwiftUI

struct MainTabView: View {
    @AppStorage("mainTab") private var mainTab = 0

    var body: some View {
        TabView(selection: $mainTab) {
            NavigationStack {
                ToolsHubScreen()
            }
            .tabItem { Label("Tools", systemImage: "wrench.and.screwdriver") }
            .tag(0)

            NavigationStack {
                ProjectsScreen()
            }
            .tabItem { Label("Projects", systemImage: "folder") }
            .tag(1)

            NavigationStack {
                ExportScreen()
            }
            .tabItem { Label("Export", systemImage: "square.and.arrow.up") }
            .tag(2)

            NavigationStack {
                SettingsScreen()
            }
            .tabItem { Label("Settings", systemImage: "gearshape") }
            .tag(3)
        }
        .tint(AppTheme.accent)
        .onAppear { applyLaunchTab() }
    }

    private func applyLaunchTab() {
        let args = ProcessInfo.processInfo.arguments
        if let idx = args.firstIndex(of: "-mainTab"), args.indices.contains(idx + 1), let value = Int(args[idx + 1]) {
            mainTab = value
        }
    }
}

#Preview {
    PreviewHost {
        MainTabView()
    }
}
