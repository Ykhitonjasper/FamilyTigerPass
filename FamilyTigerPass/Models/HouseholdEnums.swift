import Foundation

enum EstimateNote {
    static let text = "Estimates only. Not veterinary advice. Not for medication."
}

protocol StringRawPickable: RawRepresentable, CaseIterable, Identifiable, Hashable where RawValue == String {}
extension StringRawPickable {
    var id: String { rawValue }
}

enum LifeStage: String, Codable, StringRawPickable {
    case puppyKitten
    case adult
    case senior

    var label: String {
        switch self {
        case .puppyKitten: return "Puppy / kitten"
        case .adult: return "Adult"
        case .senior: return "Senior"
        }
    }

    var chip: String {
        switch self {
        case .puppyKitten: return "Young"
        case .adult: return "Adult"
        case .senior: return "Senior"
        }
    }
}

enum BCSBand: String, Codable, StringRawPickable {
    case under
    case ideal
    case over

    var label: String {
        switch self {
        case .under: return "Under"
        case .ideal: return "Ideal"
        case .over: return "Over"
        }
    }
}

enum EnergyBand: String, Codable, StringRawPickable {
    case low
    case moderate
    case high

    var label: String {
        switch self {
        case .low: return "Low"
        case .moderate: return "Moderate"
        case .high: return "High"
        }
    }
}

enum HeatBand: String, Codable, StringRawPickable {
    case cool
    case mild
    case hot

    var label: String {
        switch self {
        case .cool: return "Cool"
        case .mild: return "Mild"
        case .hot: return "Hot"
        }
    }
}

enum Species: String, Codable, StringRawPickable {
    case dog
    case cat

    var label: String {
        switch self {
        case .dog: return "Dog"
        case .cat: return "Cat"
        }
    }
}

enum SupplyKind: String, Codable, StringRawPickable {
    case pads
    case litter

    var label: String {
        switch self {
        case .pads: return "Pads"
        case .litter: return "Litter"
        }
    }
}

enum DurationUnit: String, Codable, StringRawPickable {
    case hours
    case days

    var label: String {
        switch self {
        case .hours: return "Hours"
        case .days: return "Days"
        }
    }
}
