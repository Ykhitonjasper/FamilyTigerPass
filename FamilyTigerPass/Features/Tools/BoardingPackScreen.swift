import SwiftUI

struct BoardingPackScreen: View {
    var prefillJSON: String? = nil
    @State private var nights = 3
    @State private var petCount = 2
    @State private var mealsPerDay = 2
    @State private var dailyGramsPerPet = 220.0
    @State private var saveDraft: SaveDraft?

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
                ResultCard(
                    title: CalculatorKind.boardingPack.title,
                    rows: BoardingPackCalculator.rows(output),
                    takeaway: BoardingPackCalculator.summary(output)
                )
                CTAButton(title: "Save to project") { offerSave() }
            }
            .padding()
        }
        .background(AppBackground())
        .navigationTitle(CalculatorKind.boardingPack.title)
        .toolWorkbench()
        .saveToProject(draft: $saveDraft)
        .task {
            if let prefillJSON { applyJSON(prefillJSON) }
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

    private var output: BoardingPackCalculator.Output { BoardingPackCalculator.compute(input) }

    private func offerSave() {
        KeyboardChrome.dismiss()
        saveDraft = SaveDraft(
            kind: .boardingPack,
            summary: BoardingPackCalculator.summary(output),
            detailJSON: BoardingPackCalculator.snapshot(input, output)
        )
    }

    private func apply(_ preset: Preset) { applyJSON(preset.detailJSON) }

    private func applyJSON(_ json: String) {
        guard let decoded = SnapshotJSON.decodeInputs(json, as: BoardingPackCalculator.Input.self) else { return }
        nights = decoded.nights
        petCount = decoded.petCount
        mealsPerDay = decoded.mealsPerDay
        dailyGramsPerPet = decoded.dailyGramsPerPet
    }
}

#Preview {
    PreviewHost {
        NavigationStack { BoardingPackScreen() }
    }
}
