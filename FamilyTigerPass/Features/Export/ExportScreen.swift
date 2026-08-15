import SwiftUI
import SwiftData

struct ExportScreen: View {
    @Query(sort: \Project.createdAt) private var projects: [Project]

    var body: some View {
        Group {
            if projects.isEmpty {
                ContentUnavailableView(
                    "Nothing to export",
                    systemImage: "square.and.arrow.up",
                    description: Text("Save a calculator result into a project first.")
                )
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        ForEach(projects) { project in
                            ElevatedCard {
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("\(project.name) · \(project.lineItems.count) results")
                                        .font(.headline)
                                        .foregroundStyle(AppTheme.textPrimary)
                                    Text(project.summary)
                                        .font(.subheadline)
                                        .foregroundStyle(AppTheme.textSecondary)
                                    ForEach(project.lineItems.sorted(by: { $0.createdAt < $1.createdAt }).prefix(4)) { item in
                                        HStack {
                                            Text(item.title)
                                                .foregroundStyle(AppTheme.textPrimary)
                                            Spacer()
                                            Text(item.summary)
                                                .font(.caption)
                                                .foregroundStyle(AppTheme.textMono)
                                                .lineLimit(1)
                                        }
                                    }
                                    ShareLink(
                                        item: PDFFile(data: ProjectPDF.make(project: project), name: "\(project.name).pdf"),
                                        preview: SharePreview("\(project.name) PDF")
                                    ) {
                                        Label("Share PDF", systemImage: "doc.richtext")
                                    }
                                    ShareLink(item: ProjectText.make(project: project)) {
                                        Label("Share text", systemImage: "doc.plaintext")
                                    }
                                    ShareLink(
                                        item: CSVFile(data: ProjectCSV.make(project: project), name: "\(project.name).csv"),
                                        preview: SharePreview("\(project.name) CSV")
                                    ) {
                                        Label("Share CSV", systemImage: "tablecells")
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .background(AppBackground())
        .navigationTitle("Export")
        .kitchenChrome()
        .tint(AppTheme.accent)
    }
}

private struct PDFFile: Transferable {
    let data: Data
    let name: String

    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(exportedContentType: .pdf) { file in
            file.data
        }
        .suggestedFileName { file in
            file.name
        }
    }
}

private struct CSVFile: Transferable {
    let data: Data
    let name: String

    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(exportedContentType: .commaSeparatedText) { file in
            file.data
        }
        .suggestedFileName { file in
            file.name
        }
    }
}

#Preview {
    PreviewHost {
        NavigationStack { ExportScreen() }
    }
}
