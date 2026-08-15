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
                ScrollView {
                    VStack(alignment: .leading, spacing: 14) {
                        ElevatedCard {
                            VStack(alignment: .leading, spacing: 6) {
                                Text(project.summary)
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(AppTheme.textPrimary)
                                Text("Tap a result to reopen the tool with the same numbers.")
                                    .font(.footnote)
                                    .foregroundStyle(AppTheme.textSecondary)
                            }
                        }
                        Text("Saved results · \(project.lineItems.count)")
                            .font(.title3.weight(.semibold))
                            .foregroundStyle(AppTheme.textPrimary)
                            .padding(.top, 4)
                        ForEach(project.lineItems.sorted(by: { $0.createdAt < $1.createdAt })) { item in
                            NavigationLink(value: LineItemLaunch(kind: item.kind, detailJSON: item.detailJSON)) {
                                ElevatedCard {
                                    HStack(alignment: .center, spacing: 12) {
                                        Image(systemName: item.kind.systemImage)
                                            .font(.title3)
                                            .foregroundStyle(AppTheme.accent)
                                            .frame(width: 28)
                                            .accessibilityHidden(true)
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(item.title)
                                                .font(.headline)
                                                .foregroundStyle(AppTheme.textPrimary)
                                            Text(item.summary)
                                                .font(.subheadline)
                                                .foregroundStyle(AppTheme.textSecondary)
                                        }
                                        Spacer(minLength: 8)
                                        Image(systemName: "chevron.right")
                                            .font(.caption.weight(.semibold))
                                            .foregroundStyle(AppTheme.textSecondary)
                                            .accessibilityHidden(true)
                                    }
                                }
                            }
                            .buttonStyle(.plain)
                            .accessibilityLabel("\(item.title), \(item.summary)")
                        }
                    }
                    .padding()
                }
                .background(AppBackground())
                .navigationTitle(project.name)
                .kitchenChrome()
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
