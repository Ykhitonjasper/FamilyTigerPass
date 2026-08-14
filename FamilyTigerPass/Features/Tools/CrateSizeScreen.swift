import SwiftUI

struct CrateSizeScreen: View {
    var prefillJSON: String? = nil
    @State private var bodyLengthCm = 78.0
    @State private var output: CrateSizeCalculator.Output?
    @State private var showSave = false
    @State private var computePulse = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                PresetChipRow(presets: PresetCatalog.presets(for: .crateSize)) { apply($0) }
                DecimalField(title: "Body length", value: $bodyLengthCm, suffix: "cm")
                Text("Maps nose-to-base-of-tail length to a common crate class. Measure on the floor, not the standing height.")
                    .font(.footnote)
                    .foregroundStyle(AppTheme.textSecondary)
                VStack(alignment: .leading, spacing: 6) {
                    ForEach(CrateChart.rows) { row in
                        Text(row.label)
                            .font(.caption.monospacedDigit())
                            .foregroundStyle(AppTheme.textMono)
                    }
                    Text(ToolHelp.text(for: .crateSize))
                        .font(.footnote)
                        .foregroundStyle(AppTheme.textSecondary)
                }
                CTAButton(title: "Compute") { compute() }
                if let output {
                    ResultCard(title: CalculatorKind.crateSize.title, rows: CrateSizeCalculator.rows(output))
                    CTAButton(title: "Save to project", kind: .secondary) { showSave = true }
                }
            }
            .padding()
        }
        .background(AppBackground())
        .navigationTitle(CalculatorKind.crateSize.title)
        .sensoryFeedback(.impact, trigger: computePulse)
        .sheet(isPresented: $showSave) {
            if let output {
                SaveLineItemSheet(
                    kind: .crateSize,
                    summary: CrateSizeCalculator.summary(output),
                    detailJSON: CrateSizeCalculator.snapshot(input, output)
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

    private var input: CrateSizeCalculator.Input {
        CrateSizeCalculator.Input(bodyLengthCm: bodyLengthCm)
    }

    private func compute() {
        output = CrateSizeCalculator.compute(input)
        computePulse.toggle()
    }

    private func apply(_ preset: Preset) { applyJSON(preset.detailJSON) }

    private func applyJSON(_ json: String) {
        guard let decoded = SnapshotJSON.decodeInputs(json, as: CrateSizeCalculator.Input.self) else { return }
        bodyLengthCm = decoded.bodyLengthCm
        output = nil
    }
}

#Preview {
    PreviewHost {
        NavigationStack { CrateSizeScreen() }
    }
}
