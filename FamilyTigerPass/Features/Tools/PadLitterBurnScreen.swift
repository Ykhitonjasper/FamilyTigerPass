import SwiftUI

struct PadLitterBurnScreen: View {
    var prefillJSON: String? = nil
    @State private var petCount = 2
    @State private var supplyKind: SupplyKind = .pads
    @State private var durationValue = 9.0
    @State private var durationUnit: DurationUnit = .hours
    @State private var output: PadLitterBurnCalculator.Output?
    @State private var showSave = false
    @State private var computePulse = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                PresetChipRow(presets: PresetCatalog.presets(for: .padLitterBurn)) { apply($0) }
                IntStepperField(title: "Pets", value: $petCount, range: 1...8)
                Picker("Supply", selection: $supplyKind) {
                    ForEach(SupplyKind.allCases) { item in
                        Text(item.label).tag(item)
                    }
                }
                DecimalField(title: "Duration", value: $durationValue, suffix: "")
                Picker("Unit", selection: $durationUnit) {
                    ForEach(DurationUnit.allCases) { item in
                        Text(item.label).tag(item)
                    }
                }
                Text("Pads scale with hours. Litter boxes scale with days. Switch the unit to match the trip.")
                    .font(.footnote)
                    .foregroundStyle(AppTheme.textSecondary)
                Text(ToolHelp.text(for: .padLitterBurn))
                    .font(.footnote)
                    .foregroundStyle(AppTheme.textSecondary)
                CTAButton(title: "Compute") { compute() }
                if let output {
                    ResultCard(title: CalculatorKind.padLitterBurn.title, rows: PadLitterBurnCalculator.rows(output))
                    CTAButton(title: "Save to project", kind: .secondary) { showSave = true }
                }
            }
            .padding()
        }
        .background(AppBackground())
        .navigationTitle(CalculatorKind.padLitterBurn.title)
        .sensoryFeedback(.impact, trigger: computePulse)
        .sheet(isPresented: $showSave) {
            if let output {
                SaveLineItemSheet(
                    kind: .padLitterBurn,
                    summary: PadLitterBurnCalculator.summary(output),
                    detailJSON: PadLitterBurnCalculator.snapshot(input, output)
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

    private var input: PadLitterBurnCalculator.Input {
        PadLitterBurnCalculator.Input(
            petCount: petCount,
            supplyKind: supplyKind,
            durationValue: durationValue,
            durationUnit: durationUnit
        )
    }

    private func compute() {
        output = PadLitterBurnCalculator.compute(input)
        computePulse.toggle()
    }

    private func apply(_ preset: Preset) { applyJSON(preset.detailJSON) }

    private func applyJSON(_ json: String) {
        guard let decoded = SnapshotJSON.decodeInputs(json, as: PadLitterBurnCalculator.Input.self) else { return }
        petCount = decoded.petCount
        supplyKind = decoded.supplyKind
        durationValue = decoded.durationValue
        durationUnit = decoded.durationUnit
        output = nil
    }
}

#Preview {
    PreviewHost {
        NavigationStack { PadLitterBurnScreen() }
    }
}
