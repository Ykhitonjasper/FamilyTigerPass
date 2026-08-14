import SwiftUI
import SwiftData

struct ProjectsScreen: View {
    @Query(sort: \Project.name) private var projects: [Project]

    var body: some View {
        List {
            ForEach(projects) { project in
                NavigationLink(value: ProjectNav(stableID: project.stableID)) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(project.name)
                            .font(.headline)
                            .foregroundStyle(AppTheme.textPrimary)
                        Text(project.summary)
                            .font(.subheadline)
                            .foregroundStyle(AppTheme.textSecondary)
                        Text("\(project.lineItems.count) saved")
                            .font(.caption)
                            .foregroundStyle(AppTheme.textMono)
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(AppBackground())
        .navigationTitle("Projects")
        .navigationDestination(for: ProjectNav.self) { nav in
            ProjectDetailScreen(stableID: nav.stableID)
        }
        .navigationDestination(for: LineItemLaunch.self) { launch in
            ToolRouter.screen(launch.kind, prefill: launch.detailJSON)
        }
    }
}

#Preview {
    PreviewHost {
        NavigationStack { ProjectsScreen() }
    }
}
