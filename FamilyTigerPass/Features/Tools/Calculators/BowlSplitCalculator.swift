import Foundation

enum BowlSplitCalculator {
    struct Input: Codable, Hashable {
        var dailyGrams: Double
        var mealsPerDay: Int
        var petCount: Int
    }

    struct Output: Codable, Hashable {
        var gramsPerBowl: Double
        var bowlsPerDay: Int
        var gramsPerPet: Double
    }

    static func compute(_ input: Input) -> Output {
        let meals = min(max(input.mealsPerDay, 1), 6)
        let pets = min(max(input.petCount, 1), 8)
        let grams = max(input.dailyGrams, 1)
        let bowls = meals * pets
        return Output(
            gramsPerBowl: (grams / Double(bowls) * 10).rounded() / 10,
            bowlsPerDay: bowls,
            gramsPerPet: (grams / Double(pets) * 10).rounded() / 10
        )
    }

    static func snapshot(_ input: Input, _ output: Output) -> String {
        SnapshotJSON.encode(input, output)
    }

    static func rows(_ output: Output) -> [ResultRow] {
        [
            ResultRow(label: "Per bowl", value: "\(output.gramsPerBowl) g"),
            ResultRow(label: "Bowls / day", value: "\(output.bowlsPerDay)"),
            ResultRow(label: "Per pet", value: "\(output.gramsPerPet) g"),
        ]
    }

    static func summary(_ output: Output) -> String {
        "\(output.gramsPerBowl) g per bowl · \(output.bowlsPerDay) bowls"
    }
}
