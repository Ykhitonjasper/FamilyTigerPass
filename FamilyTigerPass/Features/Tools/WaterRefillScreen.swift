import SwiftUI

struct WaterRefillScreen: View {
    var prefillJSON: String? = nil
    @State private var weightKg = 28.0
    @State private var species: Species = .dog
    @State private var saveDraft: SaveDraft?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                PresetChipRow(presets: PresetCatalog.presets(for: .waterRefill)) { apply($0) }
                DecimalField(title: "Weight", value: $weightKg, suffix: "kg")
                VStack(alignment: .leading, spacing: 8) {
                    Text("Species")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(AppTheme.textSecondary)
                    Picker("Species", selection: $species) {
                        ForEach(Species.allCases) { item in
                            Text(item.label).tag(item)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                Text("A millilitre band for topping bowls. Heat and wet food will move the real number.")
                    .font(.footnote)
                    .foregroundStyle(AppTheme.textSecondary)
                Text(ToolHelp.text(for: .waterRefill))
                    .font(.footnote)
                    .foregroundStyle(AppTheme.textSecondary)
                ResultCard(
                    title: CalculatorKind.waterRefill.title,
                    rows: WaterRefillCalculator.rows(output),
                    takeaway: WaterRefillCalculator.summary(output)
                )
                CTAButton(title: "Save to project") { offerSave() }
            }
            .padding()
        }
        .background(AppBackground())
        .navigationTitle(CalculatorKind.waterRefill.title)
        .toolWorkbench()
        .saveToProject(draft: $saveDraft)
        .task {
            if let prefillJSON { applyJSON(prefillJSON) }
        }
    }

    private var input: WaterRefillCalculator.Input {
        WaterRefillCalculator.Input(weightKg: weightKg, species: species)
    }

    private var output: WaterRefillCalculator.Output { WaterRefillCalculator.compute(input) }

    private func offerSave() {
        KeyboardChrome.dismiss()
        saveDraft = SaveDraft(
            kind: .waterRefill,
            summary: WaterRefillCalculator.summary(output),
            detailJSON: WaterRefillCalculator.snapshot(input, output)
        )
    }

    private func apply(_ preset: Preset) { applyJSON(preset.detailJSON) }

    private func applyJSON(_ json: String) {
        guard let decoded = SnapshotJSON.decodeInputs(json, as: WaterRefillCalculator.Input.self) else { return }
        weightKg = decoded.weightKg
        species = decoded.species
    }
}

#Preview {
    PreviewHost {
        NavigationStack { WaterRefillScreen() }
    }
}
