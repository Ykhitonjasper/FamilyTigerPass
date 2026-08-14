import SwiftUI

struct ResultCard: View {
    let title: String
    let rows: [ResultRow]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundStyle(AppTheme.textPrimary)
            ForEach(rows) { row in
                HStack(alignment: .firstTextBaseline) {
                    Text(row.label)
                        .foregroundStyle(AppTheme.textSecondary)
                    Spacer()
                    Text(row.value)
                        .font(.body.monospacedDigit())
                        .foregroundStyle(AppTheme.textMono)
                }
                .accessibilityElement(children: .combine)
            }
            Text(EstimateNote.text)
                .font(.footnote)
                .foregroundStyle(AppTheme.textSecondary)
                .padding(.top, 4)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AppTheme.bgElevated, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(AppTheme.hairline, lineWidth: 1)
        )
    }
}

#Preview {
    ResultCard(title: "Treat Budget", rows: [
        ResultRow(label: "Treat kcal", value: "198 kcal"),
        ResultRow(label: "Treat grams", value: "56.6 g"),
    ])
    .padding()
    .background(AppBackground())
}
