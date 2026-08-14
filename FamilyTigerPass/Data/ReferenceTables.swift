import Foundation

struct BreedRef: Identifiable, Hashable {
    let stableID: String
    let name: String
    let species: Species
    let typicalKg: Double
    let bodyLengthCm: Double
    let energy: EnergyBand

    var id: String { stableID }
}

enum BreedCatalog {
    static let all: [BreedRef] = [
        BreedRef(stableID: "br-lab", name: "Lab mix", species: .dog, typicalKg: 28, bodyLengthCm: 70, energy: .moderate),
        BreedRef(stableID: "br-shep", name: "Shepherd mix", species: .dog, typicalKg: 32, bodyLengthCm: 78, energy: .high),
        BreedRef(stableID: "br-beagle", name: "Beagle", species: .dog, typicalKg: 12, bodyLengthCm: 48, energy: .moderate),
        BreedRef(stableID: "br-dach", name: "Dachshund", species: .dog, typicalKg: 7, bodyLengthCm: 38, energy: .low),
        BreedRef(stableID: "br-corgi", name: "Corgi", species: .dog, typicalKg: 12, bodyLengthCm: 52, energy: .moderate),
        BreedRef(stableID: "br-boxer", name: "Boxer", species: .dog, typicalKg: 27, bodyLengthCm: 66, energy: .high),
        BreedRef(stableID: "br-poodle", name: "Standard poodle", species: .dog, typicalKg: 22, bodyLengthCm: 62, energy: .high),
        BreedRef(stableID: "br-shih", name: "Shih tzu", species: .dog, typicalKg: 6, bodyLengthCm: 32, energy: .low),
        BreedRef(stableID: "br-husky", name: "Husky mix", species: .dog, typicalKg: 24, bodyLengthCm: 64, energy: .high),
        BreedRef(stableID: "br-whippet", name: "Whippet", species: .dog, typicalKg: 13, bodyLengthCm: 58, energy: .high),
        BreedRef(stableID: "br-great", name: "Great dane", species: .dog, typicalKg: 54, bodyLengthCm: 92, energy: .moderate),
        BreedRef(stableID: "br-maltese", name: "Maltese", species: .dog, typicalKg: 3.5, bodyLengthCm: 26, energy: .low),
        BreedRef(stableID: "br-doodle", name: "Doodle mix", species: .dog, typicalKg: 20, bodyLengthCm: 60, energy: .moderate),
        BreedRef(stableID: "br-pit", name: "Bully mix", species: .dog, typicalKg: 25, bodyLengthCm: 62, energy: .high),
        BreedRef(stableID: "br-retr", name: "Golden mix", species: .dog, typicalKg: 30, bodyLengthCm: 72, energy: .moderate),
        BreedRef(stableID: "br-dsh", name: "Domestic shorthair", species: .cat, typicalKg: 4.5, bodyLengthCm: 40, energy: .moderate),
        BreedRef(stableID: "br-dlh", name: "Domestic longhair", species: .cat, typicalKg: 5.2, bodyLengthCm: 42, energy: .low),
        BreedRef(stableID: "br-siam", name: "Siamese mix", species: .cat, typicalKg: 4.0, bodyLengthCm: 44, energy: .high),
        BreedRef(stableID: "br-maine", name: "Maine coon mix", species: .cat, typicalKg: 7.5, bodyLengthCm: 50, energy: .moderate),
        BreedRef(stableID: "br-beng", name: "Bengal mix", species: .cat, typicalKg: 5.5, bodyLengthCm: 46, energy: .high),
        BreedRef(stableID: "br-rag", name: "Ragdoll mix", species: .cat, typicalKg: 6.0, bodyLengthCm: 48, energy: .low),
        BreedRef(stableID: "br-brit", name: "British shorthair", species: .cat, typicalKg: 5.8, bodyLengthCm: 43, energy: .low),
        BreedRef(stableID: "br-sphynx", name: "Sphynx mix", species: .cat, typicalKg: 4.2, bodyLengthCm: 38, energy: .moderate),
        BreedRef(stableID: "br-tabby", name: "Tabby house cat", species: .cat, typicalKg: 4.8, bodyLengthCm: 41, energy: .moderate),
        BreedRef(stableID: "br-aussie", name: "Aussie mix", species: .dog, typicalKg: 23, bodyLengthCm: 61, energy: .high),
        BreedRef(stableID: "br-collie", name: "Border collie mix", species: .dog, typicalKg: 18, bodyLengthCm: 56, energy: .high),
        BreedRef(stableID: "br-akita", name: "Akita mix", species: .dog, typicalKg: 38, bodyLengthCm: 80, energy: .moderate),
        BreedRef(stableID: "br-yorkie", name: "Yorkie mix", species: .dog, typicalKg: 3.2, bodyLengthCm: 24, energy: .moderate),
        BreedRef(stableID: "br-persian", name: "Persian mix", species: .cat, typicalKg: 4.4, bodyLengthCm: 38, energy: .low),
        BreedRef(stableID: "br-russian", name: "Russian blue mix", species: .cat, typicalKg: 4.1, bodyLengthCm: 40, energy: .moderate),
    ]

    static func dogs() -> [BreedRef] { all.filter { $0.species == .dog } }
    static func cats() -> [BreedRef] { all.filter { $0.species == .cat } }
}

enum KitchenNotes {
    static let lines: [String] = [
        "Weigh the bag once, then reuse the grams in Bowl Split and Bag Days.",
        "Treat cap is a kitchen ceiling, not a clinic prescription.",
        "Crate class uses body length on the floor, not height at the shoulder.",
        "Travel Kit scales a full day down to the hours the house is empty.",
        "Lion Kitchen and Weekend Cabin are already saved so Export is not blank.",
    ]
}

enum CrateChart {
    struct Row: Identifiable, Hashable {
        let maxBodyCm: Double
        let crateInches: Int
        var id: Int { crateInches }
        var label: String { "Up to \(Int(maxBodyCm)) cm → \(crateInches) in" }
    }

    static let rows: [Row] = [
        Row(maxBodyCm: 40, crateInches: 24),
        Row(maxBodyCm: 55, crateInches: 30),
        Row(maxBodyCm: 70, crateInches: 36),
        Row(maxBodyCm: 85, crateInches: 42),
        Row(maxBodyCm: 120, crateInches: 48),
    ]
}

enum FoodDensity {
    struct Row: Identifiable, Hashable {
        let stableID: String
        let name: String
        let kcalPerGram: Double
        var id: String { stableID }
    }

    static let rows: [Row] = [
        Row(stableID: "fd-kibble", name: "Adult kibble", kcalPerGram: 3.5),
        Row(stableID: "fd-lite", name: "Light kibble", kcalPerGram: 3.1),
        Row(stableID: "fd-puppy", name: "Puppy kibble", kcalPerGram: 3.8),
        Row(stableID: "fd-wet", name: "Wet food", kcalPerGram: 1.0),
        Row(stableID: "fd-treat", name: "Training treats", kcalPerGram: 3.2),
        Row(stableID: "fd-jerky", name: "Jerky strips", kcalPerGram: 3.6),
        Row(stableID: "fd-cheese", name: "Cheese cubes", kcalPerGram: 4.0),
        Row(stableID: "fd-carrot", name: "Carrot coins", kcalPerGram: 0.4),
        Row(stableID: "fd-apple", name: "Apple slices", kcalPerGram: 0.5),
        Row(stableID: "fd-sardine", name: "Sardine pieces", kcalPerGram: 2.1),
        Row(stableID: "fd-liver", name: "Liver treats", kcalPerGram: 3.9),
    ]
}

enum ToolHelp {
    static func text(for kind: CalculatorKind) -> String {
        switch kind {
        case .kcalBand:
            return "Resting energy is 70 × weight^0.75. Life stage stretches the band. Body condition nudges it up or down. Kitchen planning, not a clinic chart."
        case .bowlSplit:
            return "One household daily gram figure, split across meals and pets so bowls match. Does not track who filled which bowl."
        case .treatBudget:
            return "A percent cap of daily kcal converted to grams at the treat density you type. Keep the cap at or under 25%."
        case .bagDays:
            return "Bag kilograms versus household grams per day. The calendar hint is local to this phone’s date."
        case .crateSize:
            return "Body length on the floor, nose to base of tail, maps to a crate class in inches. Standing height is a different measurement."
        case .walkWindow:
            return "Minutes as a planning window from weight and energy. It does not store walks and it is not a route log."
        case .travelKit:
            return "A fraction of a day’s food plus water scaled by hours and heat. Pack the rounded grams, then add ice if the car runs hot."
        case .waterRefill:
            return "Dogs sit near 50–60 ml/kg. Cats sit near 40–50 ml/kg. Wet food already carries water, so treat this as a bowl target."
        case .padLitterBurn:
            return "Pads: one set per pet about every eight hours. Litter: a box lasts fewer days as headcount rises."
        case .boardingPack:
            return "Nights × pets × meals, plus a 15% spare so the last morning is not an empty scoop."
        }
    }
}
