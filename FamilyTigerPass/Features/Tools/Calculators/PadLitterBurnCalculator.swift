import Foundation

enum PadLitterBurnCalculator {
    struct Input: Codable, Hashable {
        var petCount: Int
        var supplyKind: SupplyKind
        var durationValue: Double
        var durationUnit: DurationUnit
    }

    struct Output: Codable, Hashable {
        var padsNeeded: Int
        var litterDaysPerBox: Int
        var boxesNeeded: Int
        var headline: String
    }

    static func compute(_ input: Input) -> Output {
        let pets = min(max(input.petCount, 1), 8)
        let value = max(input.durationValue, 1)
        let hours: Double
        let days: Double
        switch input.durationUnit {
        case .hours:
            hours = value
            days = value / 24
        case .days:
            days = value
            hours = value * 24
        }
        let pads = pets * max(1, Int(ceil(hours / 8)))
        let litterDays = max(2, Int((7.0 / Double(pets)).rounded()))
        let boxes = max(1, Int(ceil(days / Double(litterDays))))
        let headline: String
        switch input.supplyKind {
        case .pads:
            headline = "\(pads) pads"
        case .litter:
            headline = "\(boxes) boxes · \(litterDays) days/box"
        }
        return Output(
            padsNeeded: pads,
            litterDaysPerBox: litterDays,
            boxesNeeded: boxes,
            headline: headline
        )
    }

    static func snapshot(_ input: Input, _ output: Output) -> String {
        SnapshotJSON.encode(input, output)
    }

    static func rows(_ output: Output) -> [ResultRow] {
        [
            ResultRow(label: "Headline", value: output.headline),
            ResultRow(label: "Pads", value: "\(output.padsNeeded)"),
            ResultRow(label: "Litter boxes", value: "\(output.boxesNeeded)"),
            ResultRow(label: "Days / box", value: "\(output.litterDaysPerBox)"),
        ]
    }

    static func summary(_ output: Output) -> String {
        output.headline
    }
}
