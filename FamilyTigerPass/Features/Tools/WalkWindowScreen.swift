import SwiftUI

struct WalkWindowScreen: View {
    var prefillJSON: String? = nil
    @State private var weightKg = 12.0
    @State private var energyBand: EnergyBand = .moderate
    @State private var saveDraft: SaveDraft?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                PresetChipRow(presets: PresetCatalog.presets(for: .walkWindow)) { apply($0) }
                DecimalField(title: "Weight", value: $weightKg, suffix: "kg")
                VStack(alignment: .leading, spacing: 8) {
                    Text("Energy")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(AppTheme.textSecondary)
                    Picker("Energy", selection: $energyBand) {
                        ForEach(EnergyBand.allCases) { item in
                            Text(item.label).tag(item)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                Text("A minutes window for planning the day. This is not a walk diary and does not store completed walks.")
                    .font(.footnote)
                    .foregroundStyle(AppTheme.textSecondary)
                Text(ToolHelp.text(for: .walkWindow))
                    .font(.footnote)
                    .foregroundStyle(AppTheme.textSecondary)
                ResultCard(
                    title: CalculatorKind.walkWindow.title,
                    rows: WalkWindowCalculator.rows(output),
                    takeaway: WalkWindowCalculator.summary(output)
                )
                CTAButton(title: "Save to project") { offerSave() }
            }
            .padding()
        }
        .background(AppBackground())
        .navigationTitle(CalculatorKind.walkWindow.title)
        .toolWorkbench()
        .saveToProject(draft: $saveDraft)
        .task {
            if let prefillJSON { applyJSON(prefillJSON) }
        }
    }

    private var input: WalkWindowCalculator.Input {
        WalkWindowCalculator.Input(weightKg: weightKg, energyBand: energyBand)
    }

    private var output: WalkWindowCalculator.Output { WalkWindowCalculator.compute(input) }

    private func offerSave() {
        KeyboardChrome.dismiss()
        saveDraft = SaveDraft(
            kind: .walkWindow,
            summary: WalkWindowCalculator.summary(output),
            detailJSON: WalkWindowCalculator.snapshot(input, output)
        )
    }

    private func apply(_ preset: Preset) { applyJSON(preset.detailJSON) }

    private func applyJSON(_ json: String) {
        guard let decoded = SnapshotJSON.decodeInputs(json, as: WalkWindowCalculator.Input.self) else { return }
        weightKg = decoded.weightKg
        energyBand = decoded.energyBand
    }
}

#Preview {
    PreviewHost {
        NavigationStack { WalkWindowScreen() }
    }
}
