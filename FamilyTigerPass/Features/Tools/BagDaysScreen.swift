import SwiftUI

struct BagDaysScreen: View {
    var prefillJSON: String? = nil
    @State private var bagKg = 12.0
    @State private var dailyGrams = 640.0
    @State private var output: BagDaysCalculator.Output?
    @State private var showSave = false
    @State private var computePulse = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                PresetChipRow(presets: PresetCatalog.presets(for: .bagDays)) { apply($0) }
                DecimalField(title: "Bag size", value: $bagKg, suffix: "kg")
                DecimalField(title: "Daily use", value: $dailyGrams, suffix: "g")
                Text("Counts down how many days the open bag covers at the current household grams.")
                    .font(.footnote)
                    .foregroundStyle(AppTheme.textSecondary)
                Text(ToolHelp.text(for: .bagDays))
                    .font(.footnote)
                    .foregroundStyle(AppTheme.textSecondary)
                CTAButton(title: "Compute") { compute() }
                if let output {
                    ResultCard(title: CalculatorKind.bagDays.title, rows: BagDaysCalculator.rows(output))
                    CTAButton(title: "Save to project", kind: .secondary) { showSave = true }
                }
            }
            .padding()
        }
        .background(AppBackground())
        .navigationTitle(CalculatorKind.bagDays.title)
        .sensoryFeedback(.impact, trigger: computePulse)
        .sheet(isPresented: $showSave) {
            if let output {
                SaveLineItemSheet(
                    kind: .bagDays,
                    summary: BagDaysCalculator.summary(output),
                    detailJSON: BagDaysCalculator.snapshot(input, output)
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

    private var input: BagDaysCalculator.Input {
        BagDaysCalculator.Input(bagKg: bagKg, dailyGrams: dailyGrams)
    }

    private func compute() {
        output = BagDaysCalculator.compute(input)
        computePulse.toggle()
    }

    private func apply(_ preset: Preset) { applyJSON(preset.detailJSON) }

    private func applyJSON(_ json: String) {
        guard let decoded = SnapshotJSON.decodeInputs(json, as: BagDaysCalculator.Input.self) else { return }
        bagKg = decoded.bagKg
        dailyGrams = decoded.dailyGrams
        output = nil
    }
}

#Preview {
    PreviewHost {
        NavigationStack { BagDaysScreen() }
    }
}
