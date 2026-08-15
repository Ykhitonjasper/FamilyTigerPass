import SwiftUI
import SwiftData

struct PreviewHost<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        if let container = Self.container() {
            content.modelContainer(container)
        } else {
            content
        }
    }

    private static func container() -> ModelContainer? {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        guard let container = try? ModelContainer(for: Project.self, LineItem.self, configurations: config) else {
            return nil
        }
        Seed.bootstrap(context: container.mainContext)
        return container
    }
}

struct DecimalField: View {
    let title: String
    @Binding var value: Double
    var suffix: String = ""

    var body: some View {
        HStack {
            Text(title)
            Spacer()
            TextField(title, value: $value, format: .number.precision(.fractionLength(0...1)))
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.trailing)
                .frame(maxWidth: 120)
            if !suffix.isEmpty {
                Text(suffix)
                    .foregroundStyle(AppTheme.textSecondary)
                    .frame(width: 36, alignment: .leading)
            }
        }
        .foregroundStyle(AppTheme.textPrimary)
    }
}

struct ElevatedCard<Content: View>: View {
    @ViewBuilder var content: Content

    var body: some View {
        content
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(AppTheme.bgElevated, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(AppTheme.hairline, lineWidth: 1)
            )
    }
}

extension View {
    func kitchenChrome() -> some View {
        toolbarBackground(AppTheme.bgBase, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.light, for: .navigationBar)
    }
}

struct IntStepperField: View {
    let title: String
    @Binding var value: Int
    let range: ClosedRange<Int>

    var body: some View {
        Stepper(value: $value, in: range) {
            HStack {
                Text(title)
                Spacer()
                Text("\(value)")
                    .font(.body.monospacedDigit())
                    .foregroundStyle(AppTheme.textMono)
            }
        }
        .foregroundStyle(AppTheme.textPrimary)
    }
}
