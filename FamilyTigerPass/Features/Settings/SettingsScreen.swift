import SwiftUI
import SwiftData

struct SettingsScreen: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.openURL) private var openURL
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @Query private var projects: [Project]
    @State private var confirmDelete = false
    @State private var deletePulse = false

    var body: some View {
        List {
            Section("About") {
                LabeledContent("App", value: AppTheme.displayName)
                LabeledContent("Version", value: version)
                Text("Works on this phone. Kitchen estimates stay here.")
                    .font(.footnote)
                    .foregroundStyle(AppTheme.textSecondary)
            }
            Section("Legal") {
                Button("Privacy") {
                    if let url = Legal.privacy { openURL(url) }
                }
                Button("Terms") {
                    if let url = Legal.terms { openURL(url) }
                }
            }
            Section("Data") {
                Button("Delete All Data", role: .destructive) {
                    confirmDelete = true
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(AppBackground())
        .navigationTitle("Settings")
        .sensoryFeedback(.warning, trigger: deletePulse)
        .confirmationDialog("Delete all projects and results?", isPresented: $confirmDelete, titleVisibility: .visible) {
            Button("Delete All Data", role: .destructive) {
                wipe()
            }
            Button("Cancel", role: .cancel) {}
        }
    }

    private var version: String {
        (Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String) ?? "1.0.0"
    }

    private func wipe() {
        for project in projects {
            modelContext.delete(project)
        }
        deletePulse.toggle()
        hasCompletedOnboarding = false
    }
}

#Preview {
    PreviewHost {
        NavigationStack { SettingsScreen() }
    }
}
