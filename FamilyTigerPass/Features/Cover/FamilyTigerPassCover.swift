import SwiftUI

struct FamilyTigerPassCover: View {
    var body: some View {
        ZStack {
            AppBackground()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(AppTheme.displayName)
                            .font(.title2.weight(.semibold))
                            .foregroundStyle(AppTheme.textPrimary)
                        Text("Lion Kitchen · weekday portions")
                            .font(.subheadline)
                            .foregroundStyle(AppTheme.textSecondary)
                    }

                    LazyVGrid(columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)], spacing: 12) {
                        coverTile(title: "Kcal band", value: "1,100", caption: "28 kg adult", symbol: "flame")
                        coverTile(title: "Bowl split", value: "320 g", caption: "2 meals · 3 pets", symbol: "circle.grid.2x1")
                        coverTile(title: "Treat cap", value: "18%", caption: "198 kcal left", symbol: "birthday.cake")
                        coverTile(title: "Bag days", value: "19 d", caption: "12 kg bag", symbol: "bag")
                    }

                    ElevatedCard {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("On the bench")
                                .font(.headline)
                                .foregroundStyle(AppTheme.textPrimary)
                            toolRow(title: "Travel kit", detail: "9-hour cabin pack · 3 pets", symbol: "suitcase")
                            toolRow(title: "Crate class", detail: "78 cm body · mid crate", symbol: "shippingbox")
                            toolRow(title: "Water refill", detail: "28 kg dog · daily ml", symbol: "drop")
                        }
                    }

                    Text("Local kitchen math on this iPhone.")
                        .font(.footnote)
                        .foregroundStyle(AppTheme.textSecondary)
                }
                .padding(16)
                .padding(.top, 8)
                .padding(.bottom, 24)
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel(AppTheme.displayName)
    }

    private func coverTile(title: String, value: String, caption: String, symbol: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: symbol)
                .font(.title2)
                .foregroundStyle(AppTheme.accent)
                .accessibilityHidden(true)
            Text(value)
                .font(.title3.monospacedDigit().weight(.semibold))
                .foregroundStyle(AppTheme.textPrimary)
            Text(title)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(AppTheme.textPrimary)
            Text(caption)
                .font(.caption)
                .foregroundStyle(AppTheme.textSecondary)
        }
        .padding(14)
        .frame(maxWidth: .infinity, minHeight: 128, alignment: .topLeading)
        .background(AppTheme.bgElevated, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(AppTheme.hairline, lineWidth: 1)
        )
    }

    private func toolRow(title: String, detail: String, symbol: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: symbol)
                .font(.body.weight(.semibold))
                .foregroundStyle(AppTheme.accent)
                .frame(width: 28)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(AppTheme.textPrimary)
                Text(detail)
                    .font(.caption)
                    .foregroundStyle(AppTheme.textSecondary)
            }

            Spacer(minLength: 0)
        }
    }
}

#Preview {
    FamilyTigerPassCover()
}
