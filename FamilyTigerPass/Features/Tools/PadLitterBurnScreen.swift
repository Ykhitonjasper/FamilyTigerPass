import SwiftUI

struct PadLitterBurnScreen: View {
    var prefillJSON: String? = nil
    @State private var petCount = 2
    @State private var supplyKind: SupplyKind = .pads
    @State private var durationValue = 9.0
    @State private var durationUnit: DurationUnit = .hours
    @State private var saveDraft: SaveDraft?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                PresetChipRow(presets: PresetCatalog.presets(for: .padLitterBurn)) { apply($0) }
                IntStepperField(title: "Pets", value: $petCount, range: 1...8)
                VStack(alignment: .leading, spacing: 8) {
                    Text("Supply")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(AppTheme.textSecondary)
                    Picker("Supply", selection: $supplyKind) {
                        ForEach(SupplyKind.allCases) { item in
                            Text(item.label).tag(item)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                DecimalField(title: "Duration", value: $durationValue, suffix: "")
                VStack(alignment: .leading, spacing: 8) {
                    Text("Unit")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(AppTheme.textSecondary)
                    Picker("Unit", selection: $durationUnit) {
                        ForEach(DurationUnit.allCases) { item in
                            Text(item.label).tag(item)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                Text("Pads scale with hours. Litter boxes scale with days. Switch the unit to match the trip.")
                    .font(.footnote)
                    .foregroundStyle(AppTheme.textSecondary)
                Text(ToolHelp.text(for: .padLitterBurn))
                    .font(.footnote)
                    .foregroundStyle(AppTheme.textSecondary)
                ResultCard(
                    title: CalculatorKind.padLitterBurn.title,
                    rows: PadLitterBurnCalculator.rows(output),
                    takeaway: PadLitterBurnCalculator.summary(output)
                )
                CTAButton(title: "Save to project") { offerSave() }
            }
            .padding()
        }
        .background(AppBackground())
        .navigationTitle(CalculatorKind.padLitterBurn.title)
        .toolWorkbench()
        .saveToProject(draft: $saveDraft)
        .task {
            if let prefillJSON { applyJSON(prefillJSON) }
        }
    }

    private var input: PadLitterBurnCalculator.Input {
        PadLitterBurnCalculator.Input(
            petCount: petCount,
            supplyKind: supplyKind,
            durationValue: durationValue,
            durationUnit: durationUnit
        )
    }

    private var output: PadLitterBurnCalculator.Output { PadLitterBurnCalculator.compute(input) }

    private func offerSave() {
        KeyboardChrome.dismiss()
        saveDraft = SaveDraft(
            kind: .padLitterBurn,
            summary: PadLitterBurnCalculator.summary(output),
            detailJSON: PadLitterBurnCalculator.snapshot(input, output)
        )
    }

    private func apply(_ preset: Preset) { applyJSON(preset.detailJSON) }

    private func applyJSON(_ json: String) {
        guard let decoded = SnapshotJSON.decodeInputs(json, as: PadLitterBurnCalculator.Input.self) else { return }
        petCount = decoded.petCount
        supplyKind = decoded.supplyKind
        durationValue = decoded.durationValue
        durationUnit = decoded.durationUnit
    }
}

#Preview {
    PreviewHost {
        NavigationStack { PadLitterBurnScreen() }
    }
}
