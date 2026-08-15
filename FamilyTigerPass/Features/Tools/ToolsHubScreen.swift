import SwiftUI
import SwiftData

struct ToolsHubScreen: View {
    @Query(sort: \Project.createdAt) private var projects: [Project]

    var body: some View {
        ZStack {
            GlassBg()
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    householdBoard
                    Text("Tools")
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(AppTheme.textPrimary)
                        .padding(.horizontal)
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
                    .padding(.horizontal)
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
                .padding(.top, 8)
            }
        }
        .navigationTitle(AppTheme.displayName)
        .kitchenChrome()
        .navigationDestination(for: CalculatorKind.self) { kind in
            ToolRouter.screen(kind, prefill: nil)
        }
        .navigationDestination(for: LineItemLaunch.self) { launch in
            ToolRouter.screen(launch.kind, prefill: launch.detailJSON)
        }
        .navigationDestination(for: ProjectNav.self) { nav in
            ProjectDetailScreen(stableID: nav.stableID)
        }
    }

    @ViewBuilder
    private var householdBoard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("On the bench")
                .font(.title3.weight(.semibold))
                .foregroundStyle(AppTheme.textPrimary)
            if projects.isEmpty {
                Text("Nothing saved yet. Run a tool and park the result in a project.")
                    .font(.subheadline)
                    .foregroundStyle(AppTheme.textSecondary)
            } else {
                ForEach(projects) { project in
                    NavigationLink(value: ProjectNav(stableID: project.stableID)) {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(project.name)
                                    .font(.headline)
                                    .foregroundStyle(AppTheme.textPrimary)
                                Spacer()
                                Text("\(project.lineItems.count)")
                                    .font(.caption.monospacedDigit())
                                    .foregroundStyle(AppTheme.textMono)
                            }
                            Text(project.summary)
                                .font(.subheadline)
                                .foregroundStyle(AppTheme.textSecondary)
                            ForEach(project.lineItems.sorted(by: { $0.createdAt < $1.createdAt }).prefix(3)) { item in
                                HStack {
                                    Text(item.title)
                                        .foregroundStyle(AppTheme.textSecondary)
                                    Spacer()
                                    Text(item.summary)
                                        .font(.caption)
                                        .foregroundStyle(AppTheme.textMono)
                                        .lineLimit(1)
                                }
                            }
                        }
                        .padding(14)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(AppTheme.bgElevated, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .stroke(AppTheme.hairline, lineWidth: 1)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(.horizontal)
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
