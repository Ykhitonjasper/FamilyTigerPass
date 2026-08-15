import SwiftUI

struct KcalBandScreen: View {
    var prefillJSON: String? = nil
    @State private var weightKg = 28.0
    @State private var lifeStage: LifeStage = .adult
    @State private var bcsBand: BCSBand = .ideal
    @State private var saveDraft: SaveDraft?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                PresetChipRow(presets: PresetCatalog.presets(for: .kcalBand)) { apply($0) }
                DecimalField(title: "Weight", value: $weightKg, suffix: "kg")
                labeledPicker("Life stage") {
                    Picker("Life stage", selection: $lifeStage) {
                        ForEach(LifeStage.allCases) { item in
                            Text(item.chip).tag(item)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                labeledPicker("Body condition") {
                    Picker("Body condition", selection: $bcsBand) {
                        ForEach(BCSBand.allCases) { item in
                            Text(item.label).tag(item)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                breedRow
                Text("Uses a resting-energy band, then life stage and body condition. Kitchen planning only.")
                    .font(.footnote)
                    .foregroundStyle(AppTheme.textSecondary)
                ResultCard(
                    title: CalculatorKind.kcalBand.title,
                    rows: KcalBandCalculator.rows(output),
                    takeaway: KcalBandCalculator.summary(output)
                )
                CTAButton(title: "Save to project") { offerSave() }
            }
            .padding()
        }
        .background(AppBackground())
        .navigationTitle(CalculatorKind.kcalBand.title)
        .toolWorkbench()
        .saveToProject(draft: $saveDraft)
        .task {
            if let prefillJSON { applyJSON(prefillJSON) }
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

    @ViewBuilder
    private func labeledPicker<Content: View>(_ title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(AppTheme.textSecondary)
            content()
        }
    }

    private var input: KcalBandCalculator.Input {
        KcalBandCalculator.Input(weightKg: weightKg, lifeStage: lifeStage, bcsBand: bcsBand)
    }

    private var output: KcalBandCalculator.Output { KcalBandCalculator.compute(input) }

    private func offerSave() {
        KeyboardChrome.dismiss()
        saveDraft = SaveDraft(
            kind: .kcalBand,
            summary: KcalBandCalculator.summary(output),
            detailJSON: KcalBandCalculator.snapshot(input, output)
        )
    }

    private func apply(_ preset: Preset) { applyJSON(preset.detailJSON) }

    private func applyJSON(_ json: String) {
        guard let decoded = SnapshotJSON.decodeInputs(json, as: KcalBandCalculator.Input.self) else { return }
        weightKg = decoded.weightKg
        lifeStage = decoded.lifeStage
        bcsBand = decoded.bcsBand
    }
}

#Preview {
    PreviewHost {
        NavigationStack { KcalBandScreen() }
    }
}
