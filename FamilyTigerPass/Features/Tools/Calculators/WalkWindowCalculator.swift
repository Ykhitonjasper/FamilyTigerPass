import Foundation

enum WalkWindowCalculator {
    struct Input: Codable, Hashable {
        var weightKg: Double
        var energyBand: EnergyBand
    }

    struct Output: Codable, Hashable {
        var minutesMin: Int
        var minutesMax: Int
    }

    static func compute(_ input: Input) -> Output {
        let weight = min(max(input.weightKg, 1), 90)
        let base: (Double, Double)
        switch weight {
        case ..<8: base = (15, 25)
        case ..<20: base = (25, 40)
        case ..<35: base = (35, 50)
        default: base = (40, 60)
        }
        let mul: Double
        switch input.energyBand {
        case .low: mul = 0.75
        case .moderate: mul = 1.0
        case .high: mul = 1.35
        }
        let minM = max(10, Int((base.0 * mul).rounded()))
        let maxM = max(minM + 5, Int((base.1 * mul).rounded()))
        return Output(minutesMin: minM, minutesMax: maxM)
    }

    static func snapshot(_ input: Input, _ output: Output) -> String {
        SnapshotJSON.encode(input, output)
    }

    static func rows(_ output: Output) -> [ResultRow] {
        [
            ResultRow(label: "Walk window", value: "\(output.minutesMin)–\(output.minutesMax) min"),
        ]
    }

    static func summary(_ output: Output) -> String {
        "\(output.minutesMin)–\(output.minutesMax) min walk window"
    }
}
