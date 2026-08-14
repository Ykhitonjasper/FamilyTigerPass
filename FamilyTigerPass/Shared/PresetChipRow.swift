import SwiftUI

struct PresetChipRow: View {
    let presets: [Preset]
    let onPick: (Preset) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Presets")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(AppTheme.textSecondary)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(presets) { preset in
                        Button {
                            onPick(preset)
                        } label: {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(preset.title)
                                    .font(.caption.weight(.semibold))
                                Text(preset.subtitle)
                                    .font(.caption2)
                                    .foregroundStyle(AppTheme.textSecondary)
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(AppTheme.bgElevated, in: Capsule())
                            .overlay(Capsule().stroke(AppTheme.hairline, lineWidth: 1))
                        }
                        .buttonStyle(.plain)
                        .foregroundStyle(AppTheme.textPrimary)
                        .accessibilityLabel(preset.title)
                    }
                }
            }
        }
    }
}
