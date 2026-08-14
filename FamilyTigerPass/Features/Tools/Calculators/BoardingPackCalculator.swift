import Foundation

enum BoardingPackCalculator {
    struct Input: Codable, Hashable {
        var nights: Int
        var petCount: Int
        var mealsPerDay: Int
        var dailyGramsPerPet: Double
    }

    struct Output: Codable, Hashable {
        var mealCount: Int
        var foodGrams: Double
        var spareGrams: Double
        var totalPackGrams: Double
    }

    static func compute(_ input: Input) -> Output {
        let nights = min(max(input.nights, 1), 21)
        let pets = min(max(input.petCount, 1), 8)
        let meals = min(max(input.mealsPerDay, 1), 6)
        let daily = max(input.dailyGramsPerPet, 1)
        let mealCount = nights * pets * meals
        let food = daily * Double(pets * nights)
        let spare = (food * 0.15).rounded()
        return Output(
            mealCount: mealCount,
            foodGrams: food.rounded(),
            spareGrams: spare,
            totalPackGrams: (food + spare).rounded()
        )
    }

    static func snapshot(_ input: Input, _ output: Output) -> String {
        SnapshotJSON.encode(input, output)
    }

    static func rows(_ output: Output) -> [ResultRow] {
        [
            ResultRow(label: "Meals", value: "\(output.mealCount)"),
            ResultRow(label: "Food", value: "\(Int(output.foodGrams)) g"),
            ResultRow(label: "Spare 15%", value: "\(Int(output.spareGrams)) g"),
            ResultRow(label: "Pack total", value: "\(Int(output.totalPackGrams)) g"),
        ]
    }

    static func summary(_ output: Output) -> String {
        "\(output.mealCount) meals · \(Int(output.totalPackGrams)) g pack"
    }
}
