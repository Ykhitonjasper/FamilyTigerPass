import SwiftUI

struct TreatBudgetScreen: View {
    var prefillJSON: String? = nil
    @State private var dailyKcal = 1100.0
    @State private var treatPercentCap = 18.0
    @State private var kcalPerGram = 3.5
    @State private var saveDraft: SaveDraft?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                PresetChipRow(presets: PresetCatalog.presets(for: .treatBudget)) { apply($0) }
                DecimalField(title: "Daily kcal", value: $dailyKcal, suffix: "kcal")
                DecimalField(title: "Treat cap", value: $treatPercentCap, suffix: "%")
                DecimalField(title: "Kcal / gram", value: $kcalPerGram, suffix: "")
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(FoodDensity.rows) { row in
                            Button {
                                kcalPerGram = row.kcalPerGram
                            } label: {
                                Text(row.name)
                                    .font(.caption)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 6)
                                    .background(AppTheme.bgElevated, in: Capsule())
                            }
                            .buttonStyle(.plain)
                            .foregroundStyle(AppTheme.textPrimary)
                            .accessibilityLabel(row.name)
                        }
                    }
                }
                Text("Caps treats as a slice of the daily kcal band. Not a medication amount.")
                    .font(.footnote)
                    .foregroundStyle(AppTheme.textSecondary)
                Text(ToolHelp.text(for: .treatBudget))
                    .font(.footnote)
                    .foregroundStyle(AppTheme.textSecondary)
                ResultCard(
                    title: CalculatorKind.treatBudget.title,
                    rows: TreatBudgetCalculator.rows(output),
                    takeaway: TreatBudgetCalculator.summary(output)
                )
                CTAButton(title: "Save to project") { offerSave() }
            }
            .padding()
        }
        .background(AppBackground())
        .navigationTitle(CalculatorKind.treatBudget.title)
        .toolWorkbench()
        .saveToProject(draft: $saveDraft)
        .task {
            if let prefillJSON { applyJSON(prefillJSON) }
        }
    }

    private var input: TreatBudgetCalculator.Input {
        TreatBudgetCalculator.Input(dailyKcal: dailyKcal, treatPercentCap: treatPercentCap, kcalPerGram: kcalPerGram)
    }

    private var output: TreatBudgetCalculator.Output { TreatBudgetCalculator.compute(input) }

    private func offerSave() {
        KeyboardChrome.dismiss()
        saveDraft = SaveDraft(
            kind: .treatBudget,
            summary: TreatBudgetCalculator.summary(output),
            detailJSON: TreatBudgetCalculator.snapshot(input, output)
        )
    }

    private func apply(_ preset: Preset) { applyJSON(preset.detailJSON) }

    private func applyJSON(_ json: String) {
        guard let decoded = SnapshotJSON.decodeInputs(json, as: TreatBudgetCalculator.Input.self) else { return }
        dailyKcal = decoded.dailyKcal
        treatPercentCap = decoded.treatPercentCap
        kcalPerGram = decoded.kcalPerGram
    }
}

#Preview {
    PreviewHost {
        NavigationStack { TreatBudgetScreen() }
    }
}
