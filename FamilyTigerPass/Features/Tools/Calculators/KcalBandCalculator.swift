import Foundation

enum KcalBandCalculator {
    struct Input: Codable, Hashable {
        var weightKg: Double
        var lifeStage: LifeStage
        var bcsBand: BCSBand
    }

    struct Output: Codable, Hashable {
        var rerKcal: Double
        var kcalMin: Double
        var kcalMax: Double
    }

    static func compute(_ input: Input) -> Output {
        let weight = min(max(input.weightKg, 0.5), 90)
        let rer = 70 * pow(weight, 0.75)
        let factors: (Double, Double)
        switch input.lifeStage {
        case .puppyKitten: factors = (2.0, 3.0)
        case .adult: factors = (1.4, 1.8)
        case .senior: factors = (1.1, 1.4)
        }
        let bcsMul: Double
        switch input.bcsBand {
        case .under: bcsMul = 1.15
        case .ideal: bcsMul = 1.00
        case .over: bcsMul = 0.85
        }
        return Output(
            rerKcal: rer.rounded(),
            kcalMin: (rer * factors.0 * bcsMul).rounded(),
            kcalMax: (rer * factors.1 * bcsMul).rounded()
        )
    }

    static func snapshot(_ input: Input, _ output: Output) -> String {
        SnapshotJSON.encode(input, output)
    }

    static func rows(_ output: Output) -> [ResultRow] {
        [
            ResultRow(label: "RER", value: "\(Int(output.rerKcal)) kcal"),
            ResultRow(label: "Daily band", value: "\(Int(output.kcalMin))–\(Int(output.kcalMax)) kcal"),
        ]
    }

    static func summary(_ output: Output) -> String {
        "\(Int(output.kcalMin))–\(Int(output.kcalMax)) kcal / day"
    }
}
