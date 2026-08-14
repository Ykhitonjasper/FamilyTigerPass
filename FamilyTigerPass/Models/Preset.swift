import Foundation

struct Preset: Identifiable, Hashable {
    let stableID: String
    let kind: CalculatorKind
    let title: String
    let subtitle: String
    let detailJSON: String

    var id: String { stableID }
}
