import SwiftUI

struct KcalBandScreen: View {
    var prefillJSON: String? = nil
    @State private var weightKg = 28.0
    @State private var lifeStage: LifeStage = .adult
    @State private var bcsBand: BCSBand = .ideal
    @State private var output: KcalBandCalculator.Output?
    @State private var showSave = false
    @State private var computePulse = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                PresetChipRow(presets: PresetCatalog.presets(for: .kcalBand)) { apply($0) }
                DecimalField(title: "Weight", value: $weightKg, suffix: "kg")
                Picker("Life stage", selection: $lifeStage) {
                    ForEach(LifeStage.allCases) { item in
                        Text(item.label).tag(item)
                    }
                }
                Picker("Body condition", selection: $bcsBand) {
                    ForEach(BCSBand.allCases) { item in
                        Text(item.label).tag(item)
                    }
                }
                Text("Uses a resting-energy band, then life stage and body condition. Kitchen planning only.")
                    .font(.footnote)
                    .foregroundStyle(AppTheme.textSecondary)
                breedRow
                CTAButton(title: "Compute") { compute() }
                if let output {
                    ResultCard(title: CalculatorKind.kcalBand.title, rows: KcalBandCalculator.rows(output))
                    CTAButton(title: "Save to project", kind: .secondary) { showSave = true }
                }
            }
            .padding()
        }
        .background(AppBackground())
        .navigationTitle(CalculatorKind.kcalBand.title)
        .sensoryFeedback(.impact, trigger: computePulse)
        .sheet(isPresented: $showSave) {
            if let output {
                SaveLineItemSheet(
                    kind: .kcalBand,
                    summary: KcalBandCalculator.summary(output),
                    detailJSON: KcalBandCalculator.snapshot(input, output)
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

    private var breedRow: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Typical adult weight")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(AppTheme.textSecondary)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(BreedCatalog.all) { breed in
                        Button {
                            weightKg = breed.typicalKg
                            output = nil
                        } label: {
                            Text("\(breed.name) · \(breed.typicalKg, specifier: "%.0f") kg")
                                .font(.caption)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(AppTheme.bgElevated, in: Capsule())
                        }
                        .buttonStyle(.plain)
                        .foregroundStyle(AppTheme.textPrimary)
                        .accessibilityLabel(breed.name)
                    }
                }
            }
            Text(ToolHelp.text(for: .kcalBand))
                .font(.footnote)
                .foregroundStyle(AppTheme.textSecondary)
        }
    }

    private var input: KcalBandCalculator.Input {
        KcalBandCalculator.Input(weightKg: weightKg, lifeStage: lifeStage, bcsBand: bcsBand)
    }

    private func compute() {
        output = KcalBandCalculator.compute(input)
        computePulse.toggle()
    }

    private func apply(_ preset: Preset) { applyJSON(preset.detailJSON) }

    private func applyJSON(_ json: String) {
        guard let decoded = SnapshotJSON.decodeInputs(json, as: KcalBandCalculator.Input.self) else { return }
        weightKg = decoded.weightKg
        lifeStage = decoded.lifeStage
        bcsBand = decoded.bcsBand
        output = nil
    }
}

#Preview {
    PreviewHost {
        NavigationStack { KcalBandScreen() }
    }
}
