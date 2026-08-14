import Foundation
import SwiftData

@Model
final class LineItem {
    var stableID: String
    var calculatorType: String
    var title: String
    var summary: String
    var detailJSON: String
    var createdAt: Date
    var project: Project?

    init(
        stableID: String,
        calculatorType: String,
        title: String,
        summary: String,
        detailJSON: String,
        createdAt: Date,
        project: Project? = nil
    ) {
        self.stableID = stableID
        self.calculatorType = calculatorType
        self.title = title
        self.summary = summary
        self.detailJSON = detailJSON
        self.createdAt = createdAt
        self.project = project
    }

    var kind: CalculatorKind {
        CalculatorKind(rawValue: calculatorType) ?? .kcalBand
    }
}
