import Foundation

enum TravelKitCalculator {
    struct Input: Codable, Hashable {
        var hoursAway: Double
        var petCount: Int
        var heatBand: HeatBand
        var dailyFoodGramsPerPet: Double
        var avgWeightKg: Double
    }

    struct Output: Codable, Hashable {
        var foodGrams: Double
        var waterMl: Double
    }

    static func compute(_ input: Input) -> Output {
        let hours = min(max(input.hoursAway, 0.5), 72)
        let pets = min(max(input.petCount, 1), 8)
        let foodDay = max(input.dailyFoodGramsPerPet, 1)
        let weight = min(max(input.avgWeightKg, 0.5), 90)
        let waterMul: Double
        switch input.heatBand {
        case .cool: waterMul = 1.0
        case .mild: waterMul = 1.15
        case .hot: waterMul = 1.4
        }
        let fraction = hours / 24
        let food = (foodDay * Double(pets) * fraction).rounded()
        let water = (55 * weight * Double(pets) * fraction * waterMul).rounded()
        return Output(foodGrams: food, waterMl: water)
    }

    static func snapshot(_ input: Input, _ output: Output) -> String {
        SnapshotJSON.encode(input, output)
    }

    static func rows(_ output: Output) -> [ResultRow] {
        [
            ResultRow(label: "Food to pack", value: "\(Int(output.foodGrams)) g"),
            ResultRow(label: "Water to pack", value: "\(Int(output.waterMl)) ml"),
        ]
    }

    static func summary(_ output: Output) -> String {
        "\(Int(output.foodGrams)) g food · \(Int(output.waterMl)) ml water"
    }
}
