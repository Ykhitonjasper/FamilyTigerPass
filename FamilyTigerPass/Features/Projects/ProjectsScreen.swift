import SwiftUI
import SwiftData

struct ProjectsScreen: View {
    @Query(sort: \Project.createdAt) private var projects: [Project]

    var body: some View {
        Group {
            if projects.isEmpty {
                ContentUnavailableView(
                    "No household projects",
                    systemImage: "folder",
                    description: Text("Run a tool and save it here. Lion Kitchen and Weekend Cabin appear on first launch.")
                )
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(projects) { project in
                            NavigationLink(value: ProjectNav(stableID: project.stableID)) {
                                ElevatedCard {
                                    VStack(alignment: .leading, spacing: 6) {
                                        HStack {
                                            Text(project.name)
                                                .font(.headline)
                                                .foregroundStyle(AppTheme.textPrimary)
                                            Spacer()
                                            Text("\(project.lineItems.count)")
                                                .font(.caption.monospacedDigit())
                                                .foregroundStyle(AppTheme.textMono)
                                        }
                                        Text(project.summary)
                                            .font(.subheadline)
                                            .foregroundStyle(AppTheme.textSecondary)
                                        Text(itemLine(project))
                                            .font(.caption)
                                            .foregroundStyle(AppTheme.textMono)
                                    }
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding()
                }
            }
        }
        .background(AppBackground())
        .navigationTitle("Projects")
        .kitchenChrome()
        .navigationDestination(for: ProjectNav.self) { nav in
            ProjectDetailScreen(stableID: nav.stableID)
        }
        .navigationDestination(for: LineItemLaunch.self) { launch in
            ToolRouter.screen(launch.kind, prefill: launch.detailJSON)
        }
    }

    private func itemLine(_ project: Project) -> String {
        let items = project.lineItems.sorted(by: { $0.createdAt < $1.createdAt })
        let names = items.prefix(3).map(\.title).joined(separator: " · ")
        if items.count > 3 {
            return "\(items.count) saved · \(names)…"
        }
        return "\(items.count) saved · \(names)"
    }
}

#Preview {
    PreviewHost {
        NavigationStack { ProjectsScreen() }
    }
}
