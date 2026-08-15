import SwiftUI

struct TravelKitScreen: View {
    var prefillJSON: String? = nil
    @State private var hoursAway = 9.0
    @State private var petCount = 3
    @State private var heatBand: HeatBand = .mild
    @State private var dailyFoodGramsPerPet = 210.0
    @State private var avgWeightKg = 14.0
    @State private var saveDraft: SaveDraft?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                PresetChipRow(presets: PresetCatalog.presets(for: .travelKit)) { apply($0) }
                DecimalField(title: "Hours away", value: $hoursAway, suffix: "h")
                IntStepperField(title: "Pets", value: $petCount, range: 1...8)
                VStack(alignment: .leading, spacing: 8) {
                    Text("Heat band")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(AppTheme.textSecondary)
                    Picker("Heat band", selection: $heatBand) {
                        ForEach(HeatBand.allCases) { item in
                            Text(item.label).tag(item)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                DecimalField(title: "Food / pet / day", value: $dailyFoodGramsPerPet, suffix: "g")
                DecimalField(title: "Avg weight", value: $avgWeightKg, suffix: "kg")
                Text("Scales a day of food and water down to the hours the house sits empty.")
                    .font(.footnote)
                    .foregroundStyle(AppTheme.textSecondary)
                Text(ToolHelp.text(for: .travelKit))
                    .font(.footnote)
                    .foregroundStyle(AppTheme.textSecondary)
                ResultCard(
                    title: CalculatorKind.travelKit.title,
                    rows: TravelKitCalculator.rows(output),
                    takeaway: TravelKitCalculator.summary(output)
                )
                CTAButton(title: "Save to project") { offerSave() }
            }
            .padding()
        }
        .background(AppBackground())
        .navigationTitle(CalculatorKind.travelKit.title)
        .toolWorkbench()
        .saveToProject(draft: $saveDraft)
        .task {
            if let prefillJSON { applyJSON(prefillJSON) }
        }
    }

    private var input: TravelKitCalculator.Input {
        TravelKitCalculator.Input(
            hoursAway: hoursAway,
            petCount: petCount,
            heatBand: heatBand,
            dailyFoodGramsPerPet: dailyFoodGramsPerPet,
            avgWeightKg: avgWeightKg
        )
    }

    private var output: TravelKitCalculator.Output { TravelKitCalculator.compute(input) }

    private func offerSave() {
        KeyboardChrome.dismiss()
        saveDraft = SaveDraft(
            kind: .travelKit,
            summary: TravelKitCalculator.summary(output),
            detailJSON: TravelKitCalculator.snapshot(input, output)
        )
    }

    private func apply(_ preset: Preset) { applyJSON(preset.detailJSON) }

    private func applyJSON(_ json: String) {
        guard let decoded = SnapshotJSON.decodeInputs(json, as: TravelKitCalculator.Input.self) else { return }
        hoursAway = decoded.hoursAway
        petCount = decoded.petCount
        heatBand = decoded.heatBand
        dailyFoodGramsPerPet = decoded.dailyFoodGramsPerPet
        avgWeightKg = decoded.avgWeightKg
    }
}

#Preview {
    PreviewHost {
        NavigationStack { TravelKitScreen() }
    }
}
