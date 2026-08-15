import SwiftUI

struct BagDaysScreen: View {
    var prefillJSON: String? = nil
    @State private var bagKg = 12.0
    @State private var dailyGrams = 640.0
    @State private var saveDraft: SaveDraft?

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
                ResultCard(
                    title: CalculatorKind.bagDays.title,
                    rows: BagDaysCalculator.rows(output),
                    takeaway: BagDaysCalculator.summary(output)
                )
                CTAButton(title: "Save to project") { offerSave() }
            }
            .padding()
        }
        .background(AppBackground())
        .navigationTitle(CalculatorKind.bagDays.title)
        .toolWorkbench()
        .saveToProject(draft: $saveDraft)
        .task {
            if let prefillJSON { applyJSON(prefillJSON) }
        }
    }

    private var input: BagDaysCalculator.Input {
        BagDaysCalculator.Input(bagKg: bagKg, dailyGrams: dailyGrams)
    }

    private var output: BagDaysCalculator.Output { BagDaysCalculator.compute(input, now: Date()) }

    private func offerSave() {
        KeyboardChrome.dismiss()
        saveDraft = SaveDraft(
            kind: .bagDays,
            summary: BagDaysCalculator.summary(output),
            detailJSON: BagDaysCalculator.snapshot(input, output)
        )
    }

    private func apply(_ preset: Preset) { applyJSON(preset.detailJSON) }

    private func applyJSON(_ json: String) {
        guard let decoded = SnapshotJSON.decodeInputs(json, as: BagDaysCalculator.Input.self) else { return }
        bagKg = decoded.bagKg
        dailyGrams = decoded.dailyGrams
    }
}

#Preview {
    PreviewHost {
        NavigationStack { BagDaysScreen() }
    }
}
