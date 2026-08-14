import SwiftUI

struct TreatBudgetScreen: View {
    var prefillJSON: String? = nil
    @State private var dailyKcal = 1100.0
    @State private var treatPercentCap = 18.0
    @State private var kcalPerGram = 3.5
    @State private var output: TreatBudgetCalculator.Output?
    @State private var showSave = false
    @State private var computePulse = false

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
                                output = nil
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
                CTAButton(title: "Compute") { compute() }
                if let output {
                    ResultCard(title: CalculatorKind.treatBudget.title, rows: TreatBudgetCalculator.rows(output))
                    CTAButton(title: "Save to project", kind: .secondary) { showSave = true }
                }
            }
            .padding()
        }
        .background(AppBackground())
        .navigationTitle(CalculatorKind.treatBudget.title)
        .sensoryFeedback(.impact, trigger: computePulse)
        .sheet(isPresented: $showSave) {
            if let output {
                SaveLineItemSheet(
                    kind: .treatBudget,
                    summary: TreatBudgetCalculator.summary(output),
                    detailJSON: TreatBudgetCalculator.snapshot(input, output)
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

    private var input: TreatBudgetCalculator.Input {
        TreatBudgetCalculator.Input(dailyKcal: dailyKcal, treatPercentCap: treatPercentCap, kcalPerGram: kcalPerGram)
    }

    private func compute() {
        output = TreatBudgetCalculator.compute(input)
        computePulse.toggle()
    }

    private func apply(_ preset: Preset) { applyJSON(preset.detailJSON) }

    private func applyJSON(_ json: String) {
        guard let decoded = SnapshotJSON.decodeInputs(json, as: TreatBudgetCalculator.Input.self) else { return }
        dailyKcal = decoded.dailyKcal
        treatPercentCap = decoded.treatPercentCap
        kcalPerGram = decoded.kcalPerGram
        output = nil
    }
}

#Preview {
    PreviewHost {
        NavigationStack { TreatBudgetScreen() }
    }
}
