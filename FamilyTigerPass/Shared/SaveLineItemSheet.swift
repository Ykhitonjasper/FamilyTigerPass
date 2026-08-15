import SwiftUI
import SwiftData

struct SaveDraft: Identifiable {
    let id = UUID()
    let kind: CalculatorKind
    let summary: String
    let detailJSON: String
}

extension View {
    func saveToProject(draft: Binding<SaveDraft?>) -> some View {
        sheet(item: draft) { item in
            SaveLineItemSheet(
                kind: item.kind,
                summary: item.summary,
                detailJSON: item.detailJSON
            )
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
        }
    }
}

struct SaveLineItemSheet: View {
    let kind: CalculatorKind
    let summary: String
    let detailJSON: String
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \Project.createdAt) private var projects: [Project]
    @State private var selectedID: String = ""
    @State private var newName: String = ""
    @State private var savePulse = false
    @State private var didSave = false

    var body: some View {
        NavigationStack {
            Form {
                Section("This result") {
                    Text(kind.title)
                        .font(.headline)
                    Text(summary)
                        .foregroundStyle(AppTheme.textSecondary)
                }
                if !projects.isEmpty {
                    Picker("Project", selection: $selectedID) {
                        Text("New project").tag("")
                        ForEach(projects) { project in
                            Text("\(project.name) · \(project.lineItems.count)").tag(project.stableID)
                        }
                    }
                }
                if selectedID.isEmpty {
                    TextField("New project name", text: $newName)
                }
                Section {
                    Button(didSave ? "Saved" : "Save") { save() }
                        .disabled(didSave)
                }
            }
            .scrollContentBackground(.hidden)
            .background(AppBackground())
            .navigationTitle("Save")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
            .sensoryFeedback(.success, trigger: savePulse)
        }
        .onAppear {
            if selectedID.isEmpty {
                selectedID = projects.first(where: { $0.stableID == "proj-lion-kitchen" })?.stableID
                    ?? projects.first?.stableID
                    ?? ""
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
        try? modelContext.save()
        savePulse.toggle()
        didSave = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            dismiss()
        }
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
