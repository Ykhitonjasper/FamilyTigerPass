import SwiftUI

struct TravelKitScreen: View {
    var prefillJSON: String? = nil
    @State private var hoursAway = 9.0
    @State private var petCount = 3
    @State private var heatBand: HeatBand = .mild
    @State private var dailyFoodGramsPerPet = 210.0
    @State private var avgWeightKg = 14.0
    @State private var output: TravelKitCalculator.Output?
    @State private var showSave = false
    @State private var computePulse = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                PresetChipRow(presets: PresetCatalog.presets(for: .travelKit)) { apply($0) }
                DecimalField(title: "Hours away", value: $hoursAway, suffix: "h")
                IntStepperField(title: "Pets", value: $petCount, range: 1...8)
                Picker("Heat band", selection: $heatBand) {
                    ForEach(HeatBand.allCases) { item in
                        Text(item.label).tag(item)
                    }
                }
                DecimalField(title: "Food / pet / day", value: $dailyFoodGramsPerPet, suffix: "g")
                DecimalField(title: "Avg weight", value: $avgWeightKg, suffix: "kg")
                Text("Scales a day of food and water down to the hours the house sits empty.")
                    .font(.footnote)
                    .foregroundStyle(AppTheme.textSecondary)
                Text(ToolHelp.text(for: .travelKit))
                    .font(.footnote)
                    .foregroundStyle(AppTheme.textSecondary)
                CTAButton(title: "Compute") { compute() }
                if let output {
                    ResultCard(title: CalculatorKind.travelKit.title, rows: TravelKitCalculator.rows(output))
                    CTAButton(title: "Save to project", kind: .secondary) { showSave = true }
                }
            }
            .padding()
        }
        .background(AppBackground())
        .navigationTitle(CalculatorKind.travelKit.title)
        .sensoryFeedback(.impact, trigger: computePulse)
        .sheet(isPresented: $showSave) {
            if let output {
                SaveLineItemSheet(
                    kind: .travelKit,
                    summary: TravelKitCalculator.summary(output),
                    detailJSON: TravelKitCalculator.snapshot(input, output)
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

    private var input: TravelKitCalculator.Input {
        TravelKitCalculator.Input(
            hoursAway: hoursAway,
            petCount: petCount,
            heatBand: heatBand,
            dailyFoodGramsPerPet: dailyFoodGramsPerPet,
            avgWeightKg: avgWeightKg
        )
    }

    private func compute() {
        output = TravelKitCalculator.compute(input)
        computePulse.toggle()
    }

    private func apply(_ preset: Preset) { applyJSON(preset.detailJSON) }

    private func applyJSON(_ json: String) {
        guard let decoded = SnapshotJSON.decodeInputs(json, as: TravelKitCalculator.Input.self) else { return }
        hoursAway = decoded.hoursAway
        petCount = decoded.petCount
        heatBand = decoded.heatBand
        dailyFoodGramsPerPet = decoded.dailyFoodGramsPerPet
        avgWeightKg = decoded.avgWeightKg
        output = nil
    }
}

#Preview {
    PreviewHost {
        NavigationStack { TravelKitScreen() }
    }
}
