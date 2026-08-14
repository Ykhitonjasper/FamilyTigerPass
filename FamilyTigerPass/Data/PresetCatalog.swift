import Foundation

enum PresetCatalog {
    static let all: [Preset] = [
        Preset(
            stableID: "preset-kcal-01",
            kind: .kcalBand,
            title: "Adult lab mix, 28 kg",
            subtitle: "Ideal BCS",
            detailJSON: SnapshotJSON.encodeInputs(KcalBandCalculator.Input(weightKg: 28, lifeStage: .adult, bcsBand: .ideal))
        ),
        Preset(
            stableID: "preset-kcal-02",
            kind: .kcalBand,
            title: "Kitten, 1.8 kg",
            subtitle: "Under BCS",
            detailJSON: SnapshotJSON.encodeInputs(KcalBandCalculator.Input(weightKg: 1.8, lifeStage: .puppyKitten, bcsBand: .under))
        ),
        Preset(
            stableID: "preset-kcal-03",
            kind: .kcalBand,
            title: "Senior beagle, 12 kg",
            subtitle: "Over BCS",
            detailJSON: SnapshotJSON.encodeInputs(KcalBandCalculator.Input(weightKg: 12, lifeStage: .senior, bcsBand: .over))
        ),
        Preset(
            stableID: "preset-kcal-04",
            kind: .kcalBand,
            title: "Adult cat, 5 kg",
            subtitle: "Ideal BCS",
            detailJSON: SnapshotJSON.encodeInputs(KcalBandCalculator.Input(weightKg: 5, lifeStage: .adult, bcsBand: .ideal))
        ),
        Preset(
            stableID: "preset-bowl-01",
            kind: .bowlSplit,
            title: "Two bowls, 360 g",
            subtitle: "2 meals · 2 pets",
            detailJSON: SnapshotJSON.encodeInputs(BowlSplitCalculator.Input(dailyGrams: 360, mealsPerDay: 2, petCount: 2))
        ),
        Preset(
            stableID: "preset-bowl-02",
            kind: .bowlSplit,
            title: "Three cats, 180 g",
            subtitle: "3 meals · 3 pets",
            detailJSON: SnapshotJSON.encodeInputs(BowlSplitCalculator.Input(dailyGrams: 180, mealsPerDay: 3, petCount: 3))
        ),
        Preset(
            stableID: "preset-bowl-03",
            kind: .bowlSplit,
            title: "Solo dinner, 220 g",
            subtitle: "1 meal · 1 pet",
            detailJSON: SnapshotJSON.encodeInputs(BowlSplitCalculator.Input(dailyGrams: 220, mealsPerDay: 1, petCount: 1))
        ),
        Preset(
            stableID: "preset-bowl-04",
            kind: .bowlSplit,
            title: "Lion Kitchen weekday",
            subtitle: "640 g · 2 meals · 3 pets",
            detailJSON: SnapshotJSON.encodeInputs(BowlSplitCalculator.Input(dailyGrams: 640, mealsPerDay: 2, petCount: 3))
        ),
        Preset(
            stableID: "preset-treat-01",
            kind: .treatBudget,
            title: "Cat, 10% cap",
            subtitle: "180 kcal",
            detailJSON: SnapshotJSON.encodeInputs(TreatBudgetCalculator.Input(dailyKcal: 180, treatPercentCap: 10, kcalPerGram: 3.5))
        ),
        Preset(
            stableID: "preset-treat-02",
            kind: .treatBudget,
            title: "Two dogs, 18% treats",
            subtitle: "Smoke preset · 1,100 kcal",
            detailJSON: SnapshotJSON.encodeInputs(TreatBudgetCalculator.Input(dailyKcal: 1100, treatPercentCap: 18, kcalPerGram: 3.5))
        ),
        Preset(
            stableID: "preset-treat-03",
            kind: .treatBudget,
            title: "High-drive puppy, 8%",
            subtitle: "900 kcal",
            detailJSON: SnapshotJSON.encodeInputs(TreatBudgetCalculator.Input(dailyKcal: 900, treatPercentCap: 8, kcalPerGram: 3.5))
        ),
        Preset(
            stableID: "preset-treat-04",
            kind: .treatBudget,
            title: "Low-treat senior, 5%",
            subtitle: "620 kcal",
            detailJSON: SnapshotJSON.encodeInputs(TreatBudgetCalculator.Input(dailyKcal: 620, treatPercentCap: 5, kcalPerGram: 3.5))
        ),
        Preset(
            stableID: "preset-bag-01",
            kind: .bagDays,
            title: "15 kg bag, 360 g/day",
            subtitle: "Two medium dogs",
            detailJSON: SnapshotJSON.encodeInputs(BagDaysCalculator.Input(bagKg: 15, dailyGrams: 360))
        ),
        Preset(
            stableID: "preset-bag-02",
            kind: .bagDays,
            title: "2 kg kitten bag",
            subtitle: "55 g/day",
            detailJSON: SnapshotJSON.encodeInputs(BagDaysCalculator.Input(bagKg: 2, dailyGrams: 55))
        ),
        Preset(
            stableID: "preset-bag-03",
            kind: .bagDays,
            title: "Lion Kitchen 12 kg",
            subtitle: "640 g/day",
            detailJSON: SnapshotJSON.encodeInputs(BagDaysCalculator.Input(bagKg: 12, dailyGrams: 640))
        ),
        Preset(
            stableID: "preset-crate-01",
            kind: .crateSize,
            title: "Dachshund, 38 cm",
            subtitle: "Body length",
            detailJSON: SnapshotJSON.encodeInputs(CrateSizeCalculator.Input(bodyLengthCm: 38))
        ),
        Preset(
            stableID: "preset-crate-02",
            kind: .crateSize,
            title: "Shepherd, 78 cm",
            subtitle: "Body length",
            detailJSON: SnapshotJSON.encodeInputs(CrateSizeCalculator.Input(bodyLengthCm: 78))
        ),
        Preset(
            stableID: "preset-walk-01",
            kind: .walkWindow,
            title: "12 kg, moderate",
            subtitle: "Beagle energy",
            detailJSON: SnapshotJSON.encodeInputs(WalkWindowCalculator.Input(weightKg: 12, energyBand: .moderate))
        ),
        Preset(
            stableID: "preset-walk-02",
            kind: .walkWindow,
            title: "32 kg, high energy",
            subtitle: "Shepherd mix",
            detailJSON: SnapshotJSON.encodeInputs(WalkWindowCalculator.Input(weightKg: 32, energyBand: .high))
        ),
        Preset(
            stableID: "preset-travel-01",
            kind: .travelKit,
            title: "9-hour cabin, 3 pets",
            subtitle: "Mild weather",
            detailJSON: SnapshotJSON.encodeInputs(
                TravelKitCalculator.Input(hoursAway: 9, petCount: 3, heatBand: .mild, dailyFoodGramsPerPet: 210, avgWeightKg: 14)
            )
        ),
        Preset(
            stableID: "preset-travel-02",
            kind: .travelKit,
            title: "3-hour clinic day",
            subtitle: "1 pet · cool",
            detailJSON: SnapshotJSON.encodeInputs(
                TravelKitCalculator.Input(hoursAway: 3, petCount: 1, heatBand: .cool, dailyFoodGramsPerPet: 280, avgWeightKg: 28)
            )
        ),
        Preset(
            stableID: "preset-travel-03",
            kind: .travelKit,
            title: "Hot afternoon, 2 pets",
            subtitle: "6 hours",
            detailJSON: SnapshotJSON.encodeInputs(
                TravelKitCalculator.Input(hoursAway: 6, petCount: 2, heatBand: .hot, dailyFoodGramsPerPet: 180, avgWeightKg: 9)
            )
        ),
        Preset(
            stableID: "preset-water-01",
            kind: .waterRefill,
            title: "Dog, 28 kg",
            subtitle: "Lab mix",
            detailJSON: SnapshotJSON.encodeInputs(WaterRefillCalculator.Input(weightKg: 28, species: .dog))
        ),
        Preset(
            stableID: "preset-water-02",
            kind: .waterRefill,
            title: "Cat, 4.5 kg",
            subtitle: "Indoor adult",
            detailJSON: SnapshotJSON.encodeInputs(WaterRefillCalculator.Input(weightKg: 4.5, species: .cat))
        ),
        Preset(
            stableID: "preset-pad-01",
            kind: .padLitterBurn,
            title: "2 dogs, 9 hours",
            subtitle: "Pads",
            detailJSON: SnapshotJSON.encodeInputs(
                PadLitterBurnCalculator.Input(petCount: 2, supplyKind: .pads, durationValue: 9, durationUnit: .hours)
            )
        ),
        Preset(
            stableID: "preset-pad-02",
            kind: .padLitterBurn,
            title: "1 cat, 7 days",
            subtitle: "Litter",
            detailJSON: SnapshotJSON.encodeInputs(
                PadLitterBurnCalculator.Input(petCount: 1, supplyKind: .litter, durationValue: 7, durationUnit: .days)
            )
        ),
        Preset(
            stableID: "preset-board-01",
            kind: .boardingPack,
            title: "3 nights, 2 pets",
            subtitle: "2 meals / day",
            detailJSON: SnapshotJSON.encodeInputs(
                BoardingPackCalculator.Input(nights: 3, petCount: 2, mealsPerDay: 2, dailyGramsPerPet: 220)
            )
        ),
        Preset(
            stableID: "preset-board-02",
            kind: .boardingPack,
            title: "Weekend, 3 pets",
            subtitle: "2 nights",
            detailJSON: SnapshotJSON.encodeInputs(
                BoardingPackCalculator.Input(nights: 2, petCount: 3, mealsPerDay: 2, dailyGramsPerPet: 180)
            )
        ),
    ]

    static func presets(for kind: CalculatorKind) -> [Preset] {
        all.filter { $0.kind == kind }
    }
}
