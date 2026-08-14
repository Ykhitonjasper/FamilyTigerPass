import SwiftUI

struct BoardingPackScreen: View {
    var prefillJSON: String? = nil
    @State private var nights = 3
    @State private var petCount = 2
    @State private var mealsPerDay = 2
    @State private var dailyGramsPerPet = 220.0
    @State private var output: BoardingPackCalculator.Output?
    @State private var showSave = false
    @State private var computePulse = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                PresetChipRow(presets: PresetCatalog.presets(for: .boardingPack)) { apply($0) }
                IntStepperField(title: "Nights", value: $nights, range: 1...21)
                IntStepperField(title: "Pets", value: $petCount, range: 1...8)
                IntStepperField(title: "Meals / day", value: $mealsPerDay, range: 1...6)
                DecimalField(title: "Grams / pet / day", value: $dailyGramsPerPet, suffix: "g")
                Text("Counts meals and adds a 15% spare so the bag is not empty on the last morning.")
                    .font(.footnote)
                    .foregroundStyle(AppTheme.textSecondary)
                Text(ToolHelp.text(for: .boardingPack))
                    .font(.footnote)
                    .foregroundStyle(AppTheme.textSecondary)
                CTAButton(title: "Compute") { compute() }
                if let output {
                    ResultCard(title: CalculatorKind.boardingPack.title, rows: BoardingPackCalculator.rows(output))
                    CTAButton(title: "Save to project", kind: .secondary) { showSave = true }
                }
            }
            .padding()
        }
        .background(AppBackground())
        .navigationTitle(CalculatorKind.boardingPack.title)
        .sensoryFeedback(.impact, trigger: computePulse)
        .sheet(isPresented: $showSave) {
            if let output {
                SaveLineItemSheet(
                    kind: .boardingPack,
                    summary: BoardingPackCalculator.summary(output),
                    detailJSON: BoardingPackCalculator.snapshot(input, output)
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

    private var input: BoardingPackCalculator.Input {
        BoardingPackCalculator.Input(
            nights: nights,
            petCount: petCount,
            mealsPerDay: mealsPerDay,
            dailyGramsPerPet: dailyGramsPerPet
        )
    }

    private func compute() {
        output = BoardingPackCalculator.compute(input)
        computePulse.toggle()
    }

    private func apply(_ preset: Preset) { applyJSON(preset.detailJSON) }

    private func applyJSON(_ json: String) {
        guard let decoded = SnapshotJSON.decodeInputs(json, as: BoardingPackCalculator.Input.self) else { return }
        nights = decoded.nights
        petCount = decoded.petCount
        mealsPerDay = decoded.mealsPerDay
        dailyGramsPerPet = decoded.dailyGramsPerPet
        output = nil
    }
}

#Preview {
    PreviewHost {
        NavigationStack { BoardingPackScreen() }
    }
}
