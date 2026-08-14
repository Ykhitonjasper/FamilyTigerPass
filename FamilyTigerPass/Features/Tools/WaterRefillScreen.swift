import SwiftUI

struct WaterRefillScreen: View {
    var prefillJSON: String? = nil
    @State private var weightKg = 28.0
    @State private var species: Species = .dog
    @State private var output: WaterRefillCalculator.Output?
    @State private var showSave = false
    @State private var computePulse = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                PresetChipRow(presets: PresetCatalog.presets(for: .waterRefill)) { apply($0) }
                DecimalField(title: "Weight", value: $weightKg, suffix: "kg")
                Picker("Species", selection: $species) {
                    ForEach(Species.allCases) { item in
                        Text(item.label).tag(item)
                    }
                }
                Text("A millilitre band for topping bowls. Heat and wet food will move the real number.")
                    .font(.footnote)
                    .foregroundStyle(AppTheme.textSecondary)
                Text(ToolHelp.text(for: .waterRefill))
                    .font(.footnote)
                    .foregroundStyle(AppTheme.textSecondary)
                CTAButton(title: "Compute") { compute() }
                if let output {
                    ResultCard(title: CalculatorKind.waterRefill.title, rows: WaterRefillCalculator.rows(output))
                    CTAButton(title: "Save to project", kind: .secondary) { showSave = true }
                }
            }
            .padding()
        }
        .background(AppBackground())
        .navigationTitle(CalculatorKind.waterRefill.title)
        .sensoryFeedback(.impact, trigger: computePulse)
        .sheet(isPresented: $showSave) {
            if let output {
                SaveLineItemSheet(
                    kind: .waterRefill,
                    summary: WaterRefillCalculator.summary(output),
                    detailJSON: WaterRefillCalculator.snapshot(input, output)
                )
            }
        }
        .task {
            if let prefillJSON {
                applyJSON(prefillJSON)
                compute()
            }
        }
    }

    private var input: WaterRefillCalculator.Input {
        WaterRefillCalculator.Input(weightKg: weightKg, species: species)
    }

    private func compute() {
        output = WaterRefillCalculator.compute(input)
        computePulse.toggle()
    }

    private func apply(_ preset: Preset) { applyJSON(preset.detailJSON) }

    private func applyJSON(_ json: String) {
        guard let decoded = SnapshotJSON.decodeInputs(json, as: WaterRefillCalculator.Input.self) else { return }
        weightKg = decoded.weightKg
        species = decoded.species
        output = nil
    }
}

#Preview {
    PreviewHost {
        NavigationStack { WaterRefillScreen() }
    }
}
