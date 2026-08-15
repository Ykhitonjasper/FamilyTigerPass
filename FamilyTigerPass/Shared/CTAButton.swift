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
        .buttonStyle(CTAButtonStyle(kind: kind))
        .accessibilityLabel(title)
    }
}

private struct CTAButtonStyle: ButtonStyle {
    let kind: CTAButton.Kind

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(kind == .accent ? AppTheme.bgElevated : AppTheme.accent)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(kind == .accent ? AppTheme.accent : AppTheme.bgElevated)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(AppTheme.hairline, lineWidth: kind == .secondary ? 1 : 0)
            )
            .contentShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .opacity(configuration.isPressed ? 0.82 : 1)
    }
}

#Preview {
    VStack {
        CTAButton(title: "Save to project") {}
        CTAButton(title: "Save to project", kind: .secondary) {}
    }
    .padding()
    .background(AppBackground())
}
