import SwiftUI

struct ToolsHubScreen: View {
    @State private var presentedKind: CalculatorKind?

    var body: some View {
        ZStack {
            GlassBg()
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                LazyVGrid(columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)], spacing: 12) {
                    ForEach(CalculatorKind.allCases) { kind in
                        NavigationLink(value: kind) {
                            VStack(alignment: .leading, spacing: 10) {
                                Image(systemName: kind.systemImage)
                                    .font(.title2)
                                    .foregroundStyle(AppTheme.accent)
                                    .accessibilityHidden(true)
                                Text(kind.title)
                                    .font(.headline)
                                    .foregroundStyle(AppTheme.textPrimary)
                                Text(kind.subtitle)
                                    .font(.caption)
                                    .foregroundStyle(AppTheme.textSecondary)
                                    .multilineTextAlignment(.leading)
                            }
                            .padding(14)
                            .frame(maxWidth: .infinity, minHeight: 128, alignment: .topLeading)
                            .background(AppTheme.bgElevated, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .stroke(AppTheme.hairline, lineWidth: 1)
                            )
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel(kind.title)
                    }
                }
                .padding()
                VStack(alignment: .leading, spacing: 8) {
                    Text("Kitchen notes")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(AppTheme.textSecondary)
                    ForEach(KitchenNotes.lines, id: \.self) { line in
                        Text(line)
                            .font(.footnote)
                            .foregroundStyle(AppTheme.textSecondary)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 24)
                }
            }
        }
        .navigationTitle(AppTheme.displayName)
        .navigationDestination(for: CalculatorKind.self) { kind in
            ToolRouter.screen(kind, prefill: nil)
        }
        .navigationDestination(for: LineItemLaunch.self) { launch in
            ToolRouter.screen(launch.kind, prefill: launch.detailJSON)
        }
        .navigationDestination(item: $presentedKind) { kind in
            ToolRouter.screen(kind, prefill: nil)
        }
        .onAppear { applyLaunchTool() }
    }

    private func applyLaunchTool() {
        let args = ProcessInfo.processInfo.arguments
        if let idx = args.firstIndex(of: "-openKind"), args.indices.contains(idx + 1) {
            presentedKind = CalculatorKind(rawValue: args[idx + 1])
        }
    }
}

enum ToolRouter {
    @ViewBuilder
    static func screen(_ kind: CalculatorKind, prefill: String?) -> some View {
        switch kind {
        case .kcalBand: KcalBandScreen(prefillJSON: prefill)
        case .bowlSplit: BowlSplitScreen(prefillJSON: prefill)
        case .treatBudget: TreatBudgetScreen(prefillJSON: prefill)
        case .bagDays: BagDaysScreen(prefillJSON: prefill)
        case .crateSize: CrateSizeScreen(prefillJSON: prefill)
        case .walkWindow: WalkWindowScreen(prefillJSON: prefill)
        case .travelKit: TravelKitScreen(prefillJSON: prefill)
        case .waterRefill: WaterRefillScreen(prefillJSON: prefill)
        case .padLitterBurn: PadLitterBurnScreen(prefillJSON: prefill)
        case .boardingPack: BoardingPackScreen(prefillJSON: prefill)
        }
    }
}

#Preview {
    PreviewHost {
        NavigationStack { ToolsHubScreen() }
    }
}
