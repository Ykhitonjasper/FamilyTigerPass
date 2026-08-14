import SwiftUI
import SwiftData

struct ExportScreen: View {
    @Query(sort: \Project.name) private var projects: [Project]

    var body: some View {
        List {
            ForEach(projects) { project in
                Section(project.name) {
                    ShareLink(
                        item: PDFFile(data: ProjectPDF.make(project: project), name: "\(project.stableID).pdf"),
                        preview: SharePreview("\(project.name) PDF")
                    ) {
                        Label("PDF", systemImage: "doc.richtext")
                    }
                    ShareLink(
                        item: ProjectText.make(project: project)
                    ) {
                        Label("Text", systemImage: "doc.plaintext")
                    }
                    ShareLink(
                        item: CSVFile(data: ProjectCSV.make(project: project), name: "\(project.stableID).csv"),
                        preview: SharePreview("\(project.name) CSV")
                    ) {
                        Label("CSV", systemImage: "tablecells")
                    }
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(AppBackground())
        .navigationTitle("Export")
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
