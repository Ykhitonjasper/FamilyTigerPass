import Foundation

enum WaterRefillCalculator {
    struct Input: Codable, Hashable {
        var weightKg: Double
        var species: Species
    }

    struct Output: Codable, Hashable {
        var mlMin: Double
        var mlMax: Double
    }

    static func compute(_ input: Input) -> Output {
        let weight = min(max(input.weightKg, 0.5), 90)
        let band: (Double, Double)
        switch input.species {
        case .dog: band = (50, 60)
        case .cat: band = (40, 50)
        }
        return Output(
            mlMin: (band.0 * weight).rounded(),
            mlMax: (band.1 * weight).rounded()
        )
    }

    static func snapshot(_ input: Input, _ output: Output) -> String {
        SnapshotJSON.encode(input, output)
    }

    static func rows(_ output: Output) -> [ResultRow] {
        [
            ResultRow(label: "Daily water", value: "\(Int(output.mlMin))–\(Int(output.mlMax)) ml"),
        ]
    }

    static func summary(_ output: Output) -> String {
        "\(Int(output.mlMin))–\(Int(output.mlMax)) ml / day"
    }
}
