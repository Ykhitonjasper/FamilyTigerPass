import Foundation
import SwiftData

enum Seed {
    static let epoch = Date(timeIntervalSince1970: 1_786_694_400)

    static func bootstrap(context: ModelContext) {
        let existing = (try? context.fetch(FetchDescriptor<Project>())) ?? []
        if !existing.isEmpty { return }

        let kitchen = Project(
            stableID: "proj-lion-kitchen",
            name: "Lion Kitchen",
            summary: "2 dogs + 1 cat · weekday portions",
            createdAt: epoch
        )
        let cabin = Project(
            stableID: "proj-weekend-cabin",
            name: "Weekend Cabin",
            summary: "9-hour away pack · 3 pets",
            createdAt: epoch.addingTimeInterval(3600)
        )
        context.insert(kitchen)
        context.insert(cabin)

        insertKitchen(kitchen, context: context)
        insertCabin(cabin, context: context)
        try? context.save()
    }

    private static func insertKitchen(_ project: Project, context: ModelContext) {
        let kcalIn = KcalBandCalculator.Input(weightKg: 28, lifeStage: .adult, bcsBand: .ideal)
        let kcalOut = KcalBandCalculator.compute(kcalIn)
        add(
            project,
            stableID: "li-lion-01",
            kind: .kcalBand,
            summary: KcalBandCalculator.summary(kcalOut),
            json: KcalBandCalculator.snapshot(kcalIn, kcalOut),
            offset: 3600,
            context: context
        )

        let bowlIn = BowlSplitCalculator.Input(dailyGrams: 640, mealsPerDay: 2, petCount: 3)
        let bowlOut = BowlSplitCalculator.compute(bowlIn)
        add(
            project,
            stableID: "li-lion-02",
            kind: .bowlSplit,
            summary: BowlSplitCalculator.summary(bowlOut),
            json: BowlSplitCalculator.snapshot(bowlIn, bowlOut),
            offset: 7200,
            context: context
        )

        let treatIn = TreatBudgetCalculator.Input(dailyKcal: 1100, treatPercentCap: 18, kcalPerGram: 3.5)
        let treatOut = TreatBudgetCalculator.compute(treatIn)
        add(
            project,
            stableID: "li-lion-03",
            kind: .treatBudget,
            summary: TreatBudgetCalculator.summary(treatOut),
            json: TreatBudgetCalculator.snapshot(treatIn, treatOut),
            offset: 10_800,
            context: context
        )

        let bagIn = BagDaysCalculator.Input(bagKg: 12, dailyGrams: 640)
        let bagOut = BagDaysCalculator.compute(bagIn, now: epoch)
        add(
            project,
            stableID: "li-lion-04",
            kind: .bagDays,
            summary: BagDaysCalculator.summary(bagOut),
            json: BagDaysCalculator.snapshot(bagIn, bagOut),
            offset: 14_400,
            context: context
        )
    }

    private static func insertCabin(_ project: Project, context: ModelContext) {
        let travelIn = TravelKitCalculator.Input(
            hoursAway: 9,
            petCount: 3,
            heatBand: .mild,
            dailyFoodGramsPerPet: 210,
            avgWeightKg: 14
        )
        let travelOut = TravelKitCalculator.compute(travelIn)
        add(
            project,
            stableID: "li-cabin-01",
            kind: .travelKit,
            summary: TravelKitCalculator.summary(travelOut),
            json: TravelKitCalculator.snapshot(travelIn, travelOut),
            offset: 18_000,
            context: context
        )

        let padIn = PadLitterBurnCalculator.Input(
            petCount: 2,
            supplyKind: .pads,
            durationValue: 9,
            durationUnit: .hours
        )
        let padOut = PadLitterBurnCalculator.compute(padIn)
        add(
            project,
            stableID: "li-cabin-02",
            kind: .padLitterBurn,
            summary: PadLitterBurnCalculator.summary(padOut),
            json: PadLitterBurnCalculator.snapshot(padIn, padOut),
            offset: 21_600,
            context: context
        )

        let crateIn = CrateSizeCalculator.Input(bodyLengthCm: 78)
        let crateOut = CrateSizeCalculator.compute(crateIn)
        add(
            project,
            stableID: "li-cabin-03",
            kind: .crateSize,
            summary: CrateSizeCalculator.summary(crateOut),
            json: CrateSizeCalculator.snapshot(crateIn, crateOut),
            offset: 25_200,
            context: context
        )

        let waterIn = WaterRefillCalculator.Input(weightKg: 28, species: .dog)
        let waterOut = WaterRefillCalculator.compute(waterIn)
        add(
            project,
            stableID: "li-cabin-04",
            kind: .waterRefill,
            summary: WaterRefillCalculator.summary(waterOut),
            json: WaterRefillCalculator.snapshot(waterIn, waterOut),
            offset: 28_800,
            context: context
        )
    }

    private static func add(
        _ project: Project,
        stableID: String,
        kind: CalculatorKind,
        summary: String,
        json: String,
        offset: TimeInterval,
        context: ModelContext
    ) {
        let item = LineItem(
            stableID: stableID,
            calculatorType: kind.rawValue,
            title: kind.title,
            summary: summary,
            detailJSON: json,
            createdAt: epoch.addingTimeInterval(offset),
            project: project
        )
        context.insert(item)
    }
}
