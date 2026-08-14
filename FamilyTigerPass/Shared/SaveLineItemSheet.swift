import SwiftUI
import SwiftData

struct SaveLineItemSheet: View {
    let kind: CalculatorKind
    let summary: String
    let detailJSON: String
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \Project.name) private var projects: [Project]
    @State private var selectedID: String = ""
    @State private var newName: String = ""
    @State private var savePulse = false

    var body: some View {
        NavigationStack {
            Form {
                if !projects.isEmpty {
                    Picker("Project", selection: $selectedID) {
                        Text("New project").tag("")
                        ForEach(projects) { project in
                            Text(project.name).tag(project.stableID)
                        }
                    }
                }
                if selectedID.isEmpty {
                    TextField("New project name", text: $newName)
                }
                Section {
                    CTAButton(title: "Save") { save() }
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.clear)
                }
            }
            .scrollContentBackground(.hidden)
            .background(AppBackground())
            .navigationTitle("Save")
            .sensoryFeedback(.success, trigger: savePulse)
        }
        .onAppear {
            if selectedID.isEmpty, let first = projects.first {
                selectedID = first.stableID
            }
        }
    }

    private func save() {
        let project: Project
        if let match = projects.first(where: { $0.stableID == selectedID }), !selectedID.isEmpty {
            project = match
        } else {
            let name = newName.trimmingCharacters(in: .whitespacesAndNewlines)
            let resolved = name.isEmpty ? "Kitchen project" : name
            project = Project(
                stableID: "proj-\(Int(Date().timeIntervalSince1970))",
                name: resolved,
                summary: "Saved from \(kind.title)",
                createdAt: Date()
            )
            modelContext.insert(project)
        }
        let item = LineItem(
            stableID: "li-\(Int(Date().timeIntervalSince1970))",
            calculatorType: kind.rawValue,
            title: kind.title,
            summary: summary,
            detailJSON: detailJSON,
            createdAt: Date(),
            project: project
        )
        modelContext.insert(item)
        savePulse.toggle()
        dismiss()
    }
}

#Preview {
    PreviewHost {
        SaveLineItemSheet(
            kind: .treatBudget,
            summary: "2 treats/day · 48 kcal",
            detailJSON: "{}"
        )
    }
}
