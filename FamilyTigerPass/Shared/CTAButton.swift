import SwiftUI

struct CTAButton: View {
    let title: String
    var kind: Kind = .accent
    let action: () -> Void

    enum Kind {
        case accent
        case secondary
    }

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
        }
        .buttonStyle(.plain)
        .foregroundStyle(kind == .accent ? AppTheme.bgElevated : AppTheme.accent)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(kind == .accent ? AppTheme.accent : AppTheme.bgElevated)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(AppTheme.hairline, lineWidth: kind == .secondary ? 1 : 0)
        )
        .accessibilityLabel(title)
    }
}

#Preview {
    VStack {
        CTAButton(title: "Compute") {}
        CTAButton(title: "Save to project", kind: .secondary) {}
    }
    .padding()
    .background(AppBackground())
}
