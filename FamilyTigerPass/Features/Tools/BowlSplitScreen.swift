import SwiftUI

struct BowlSplitScreen: View {
    var prefillJSON: String? = nil
    @State private var dailyGrams = 640.0
    @State private var mealsPerDay = 2
    @State private var petCount = 3
    @State private var output: BowlSplitCalculator.Output?
    @State private var showSave = false
    @State private var computePulse = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                PresetChipRow(presets: PresetCatalog.presets(for: .bowlSplit)) { apply($0) }
                DecimalField(title: "Daily food", value: $dailyGrams, suffix: "g")
                IntStepperField(title: "Meals / day", value: $mealsPerDay, range: 1...6)
                IntStepperField(title: "Pets sharing", value: $petCount, range: 1...8)
                Text("Splits one household bag across bowls so breakfast does not empty the tin.")
                    .font(.footnote)
                    .foregroundStyle(AppTheme.textSecondary)
                Text(ToolHelp.text(for: .bowlSplit))
                    .font(.footnote)
                    .foregroundStyle(AppTheme.textSecondary)
                CTAButton(title: "Compute") { compute() }
                if let output {
                    ResultCard(title: CalculatorKind.bowlSplit.title, rows: BowlSplitCalculator.rows(output))
                    CTAButton(title: "Save to project", kind: .secondary) { showSave = true }
                }
            }
            .padding()
        }
        .background(AppBackground())
        .navigationTitle(CalculatorKind.bowlSplit.title)
        .sensoryFeedback(.impact, trigger: computePulse)
        .sheet(isPresented: $showSave) {
            if let output {
                SaveLineItemSheet(
                    kind: .bowlSplit,
                    summary: BowlSplitCalculator.summary(output),
                    detailJSON: BowlSplitCalculator.snapshot(input, output)
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

    private var input: BowlSplitCalculator.Input {
        BowlSplitCalculator.Input(dailyGrams: dailyGrams, mealsPerDay: mealsPerDay, petCount: petCount)
    }

    private func compute() {
        output = BowlSplitCalculator.compute(input)
        computePulse.toggle()
    }

    private func apply(_ preset: Preset) { applyJSON(preset.detailJSON) }

    private func applyJSON(_ json: String) {
        guard let decoded = SnapshotJSON.decodeInputs(json, as: BowlSplitCalculator.Input.self) else { return }
        dailyGrams = decoded.dailyGrams
        mealsPerDay = decoded.mealsPerDay
        petCount = decoded.petCount
        output = nil
    }
}

#Preview {
    PreviewHost {
        NavigationStack { BowlSplitScreen() }
    }
}
