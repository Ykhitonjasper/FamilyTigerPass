import Foundation

enum CrateSizeCalculator {
    struct Input: Codable, Hashable {
        var bodyLengthCm: Double
    }

    struct Output: Codable, Hashable {
        var crateClassInches: Int
        var interiorInches: Int
        var crateLabel: String
    }

    static func compute(_ input: Input) -> Output {
        let length = max(input.bodyLengthCm, 10)
        let crate: Int
        switch length {
        case ...40: crate = 24
        case ...55: crate = 30
        case ...70: crate = 36
        case ...85: crate = 42
        default: crate = 48
        }
        return Output(
            crateClassInches: crate,
            interiorInches: crate,
            crateLabel: "\(crate) in crate"
        )
    }

    static func snapshot(_ input: Input, _ output: Output) -> String {
        SnapshotJSON.encode(input, output)
    }

    static func rows(_ output: Output) -> [ResultRow] {
        [
            ResultRow(label: "Class", value: output.crateLabel),
            ResultRow(label: "Interior", value: "\(output.interiorInches) in"),
        ]
    }

    static func summary(_ output: Output) -> String {
        output.crateLabel
    }
}
