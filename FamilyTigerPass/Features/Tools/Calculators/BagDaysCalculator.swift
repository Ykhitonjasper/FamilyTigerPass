import Foundation

enum BagDaysCalculator {
    struct Input: Codable, Hashable {
        var bagKg: Double
        var dailyGrams: Double
    }

    struct Output: Codable, Hashable {
        var daysUntilEmpty: Double
        var wholeDays: Int
        var calendarHint: String
    }

    static func compute(_ input: Input, now: Date = Date()) -> Output {
        let bag = max(input.bagKg, 0.1)
        let daily = max(input.dailyGrams, 1)
        let days = (bag * 1000) / daily
        let whole = Int(days.rounded(.down))
        let empty = Calendar.current.date(byAdding: .day, value: whole, to: Calendar.current.startOfDay(for: now)) ?? now
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return Output(
            daysUntilEmpty: (days * 10).rounded() / 10,
            wholeDays: whole,
            calendarHint: "Empty around \(formatter.string(from: empty))"
        )
    }

    static func snapshot(_ input: Input, _ output: Output) -> String {
        SnapshotJSON.encode(input, output)
    }

    static func rows(_ output: Output) -> [ResultRow] {
        [
            ResultRow(label: "Days left", value: "\(output.daysUntilEmpty)"),
            ResultRow(label: "Whole days", value: "\(output.wholeDays)"),
            ResultRow(label: "Hint", value: output.calendarHint),
        ]
    }

    static func summary(_ output: Output) -> String {
        "\(output.wholeDays) days · \(output.calendarHint)"
    }
}
