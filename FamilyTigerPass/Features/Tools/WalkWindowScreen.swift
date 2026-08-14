import SwiftUI

struct WalkWindowScreen: View {
    var prefillJSON: String? = nil
    @State private var weightKg = 12.0
    @State private var energyBand: EnergyBand = .moderate
    @State private var output: WalkWindowCalculator.Output?
    @State private var showSave = false
    @State private var computePulse = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                PresetChipRow(presets: PresetCatalog.presets(for: .walkWindow)) { apply($0) }
                DecimalField(title: "Weight", value: $weightKg, suffix: "kg")
                Picker("Energy", selection: $energyBand) {
                    ForEach(EnergyBand.allCases) { item in
                        Text(item.label).tag(item)
                    }
                }
                Text("A minutes window for planning the day. This is not a walk diary and does not store completed walks.")
                    .font(.footnote)
                    .foregroundStyle(AppTheme.textSecondary)
                Text(ToolHelp.text(for: .walkWindow))
                    .font(.footnote)
                    .foregroundStyle(AppTheme.textSecondary)
                CTAButton(title: "Compute") { compute() }
                if let output {
                    ResultCard(title: CalculatorKind.walkWindow.title, rows: WalkWindowCalculator.rows(output))
                    CTAButton(title: "Save to project", kind: .secondary) { showSave = true }
                }
            }
            .padding()
        }
        .background(AppBackground())
        .navigationTitle(CalculatorKind.walkWindow.title)
        .sensoryFeedback(.impact, trigger: computePulse)
        .sheet(isPresented: $showSave) {
            if let output {
                SaveLineItemSheet(
                    kind: .walkWindow,
                    summary: WalkWindowCalculator.summary(output),
                    detailJSON: WalkWindowCalculator.snapshot(input, output)
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

    private var input: WalkWindowCalculator.Input {
        WalkWindowCalculator.Input(weightKg: weightKg, energyBand: energyBand)
    }

    private func compute() {
        output = WalkWindowCalculator.compute(input)
        computePulse.toggle()
    }

    private func apply(_ preset: Preset) { applyJSON(preset.detailJSON) }

    private func applyJSON(_ json: String) {
        guard let decoded = SnapshotJSON.decodeInputs(json, as: WalkWindowCalculator.Input.self) else { return }
        weightKg = decoded.weightKg
        energyBand = decoded.energyBand
        output = nil
    }
}

#Preview {
    PreviewHost {
        NavigationStack { WalkWindowScreen() }
    }
}
