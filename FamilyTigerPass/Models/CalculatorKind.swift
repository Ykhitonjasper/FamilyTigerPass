import Foundation
import SwiftUI

enum CalculatorKind: String, Codable, CaseIterable, Identifiable, Hashable {
    case kcalBand
    case bowlSplit
    case treatBudget
    case bagDays
    case crateSize
    case walkWindow
    case travelKit
    case waterRefill
    case padLitterBurn
    case boardingPack

    var id: String { rawValue }

    var title: String {
        switch self {
        case .kcalBand: return "Kcal Band"
        case .bowlSplit: return "Bowl Split"
        case .treatBudget: return "Treat Budget"
        case .bagDays: return "Bag Days"
        case .crateSize: return "Crate Size"
        case .walkWindow: return "Walk Window"
        case .travelKit: return "Travel Kit"
        case .waterRefill: return "Water Refill"
        case .padLitterBurn: return "Pad / Litter Burn"
        case .boardingPack: return "Boarding Pack"
        }
    }

    var subtitle: String {
        switch self {
        case .kcalBand: return "Daily calorie range from weight"
        case .bowlSplit: return "Grams in each bowl"
        case .treatBudget: return "Treat share of daily kcal"
        case .bagDays: return "How long a bag lasts"
        case .crateSize: return "Crate class from body length"
        case .walkWindow: return "Walk minutes, not a log"
        case .travelKit: return "Food and water for hours away"
        case .waterRefill: return "Daily water millilitres"
        case .padLitterBurn: return "Pads or litter boxes"
        case .boardingPack: return "Meals and spare grams"
        }
    }

    var systemImage: String {
        switch self {
        case .kcalBand: return "flame"
        case .bowlSplit: return "circle.grid.2x1"
        case .treatBudget: return "birthday.cake"
        case .bagDays: return "bag"
        case .crateSize: return "shippingbox"
        case .walkWindow: return "figure.walk"
        case .travelKit: return "suitcase"
        case .waterRefill: return "drop"
        case .padLitterBurn: return "square.grid.2x2"
        case .boardingPack: return "moon.zzz"
        }
    }
}

struct ProjectNav: Hashable {
    let stableID: String
}

struct LineItemLaunch: Hashable {
    let kind: CalculatorKind
    let detailJSON: String
}

struct ResultRow: Identifiable, Hashable {
    let label: String
    let value: String
    var id: String { label }
}

enum SnapshotJSON {
    static func encodeInputs<I: Encodable>(_ inputs: I) -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys]
        guard let data = try? encoder.encode(InputWrap(inputs: inputs)), let text = String(data: data, encoding: .utf8) else {
            return "{}"
        }
        return text
    }

    static func encode<I: Encodable, O: Encodable>(_ inputs: I, _ outputs: O) -> String {
        let box = Box(inputs: AnyEncodable(inputs), outputs: AnyEncodable(outputs), disclaimer: EstimateNote.text)
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys]
        guard let data = try? encoder.encode(box), let text = String(data: data, encoding: .utf8) else {
            return "{}"
        }
        return text
    }

    static func decodeInputs<I: Decodable>(_ json: String, as type: I.Type) -> I? {
        guard let data = json.data(using: .utf8) else { return nil }
        return try? JSONDecoder().decode(Envelope<I>.self, from: data).inputs
    }

    private struct InputWrap<T: Encodable>: Encodable {
        let inputs: T
    }

    private struct Box: Encodable {
        let inputs: AnyEncodable
        let outputs: AnyEncodable
        let disclaimer: String
    }

    private struct Envelope<I: Decodable>: Decodable {
        let inputs: I
    }
}

private struct AnyEncodable: Encodable {
    private let encodeClosure: (Encoder) throws -> Void
    init<T: Encodable>(_ value: T) {
        encodeClosure = { encoder in
            var container = encoder.singleValueContainer()
            try container.encode(value)
        }
    }
    func encode(to encoder: Encoder) throws {
        try encodeClosure(encoder)
    }
}
