import Foundation

enum TreatBudgetCalculator {
    struct Input: Codable, Hashable {
        var dailyKcal: Double
        var treatPercentCap: Double
        var kcalPerGram: Double
    }

    struct Output: Codable, Hashable {
        var treatKcal: Double
        var treatGrams: Double
    }

    static func compute(_ input: Input) -> Output {
        let kcal = max(input.dailyKcal, 1)
        let percent = min(max(input.treatPercentCap, 1), 25)
        let density = max(input.kcalPerGram, 0.5)
        let treatKcal = (kcal * (percent / 100)).rounded()
        let grams = (treatKcal / density * 10).rounded() / 10
        return Output(treatKcal: treatKcal, treatGrams: grams)
    }

    static func snapshot(_ input: Input, _ output: Output) -> String {
        SnapshotJSON.encode(input, output)
    }

    static func rows(_ output: Output) -> [ResultRow] {
        [
            ResultRow(label: "Treat kcal", value: "\(Int(output.treatKcal)) kcal"),
            ResultRow(label: "Treat grams", value: "\(output.treatGrams) g"),
        ]
    }

    static func summary(_ output: Output) -> String {
        "\(Int(output.treatKcal)) kcal · \(output.treatGrams) g treats"
    }
}
