import SwiftUI
import SwiftData

struct ProjectDetailScreen: View {
    let stableID: String
    @Query private var projects: [Project]

    init(stableID: String) {
        self.stableID = stableID
        let captured = stableID
        _projects = Query(filter: #Predicate<Project> { $0.stableID == captured })
    }

    var body: some View {
        Group {
            if let project = projects.first {
                List {
                    Section(project.summary) {
                        ForEach(project.lineItems.sorted(by: { $0.createdAt < $1.createdAt })) { item in
                            NavigationLink(value: LineItemLaunch(kind: item.kind, detailJSON: item.detailJSON)) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(item.title)
                                        .font(.headline)
                                        .foregroundStyle(AppTheme.textPrimary)
                                    Text(item.summary)
                                        .font(.subheadline)
                                        .foregroundStyle(AppTheme.textSecondary)
                                }
                                .padding(.vertical, 4)
                            }
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                .background(AppBackground())
                .navigationTitle(project.name)
            } else {
                ContentUnavailableView("Project missing", systemImage: "folder")
                    .background(AppBackground())
            }
        }
        .navigationDestination(for: LineItemLaunch.self) { launch in
            ToolRouter.screen(launch.kind, prefill: launch.detailJSON)
        }
    }
}

#Preview {
    PreviewHost {
        NavigationStack { ProjectDetailScreen(stableID: "proj-lion-kitchen") }
    }
}
