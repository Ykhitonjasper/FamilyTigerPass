import Foundation
import SwiftData

@Model
final class Project {
    var stableID: String
    var name: String
    var summary: String
    var createdAt: Date
    @Relationship(deleteRule: .cascade, inverse: \LineItem.project)
    var lineItems: [LineItem]

    init(stableID: String, name: String, summary: String, createdAt: Date, lineItems: [LineItem] = []) {
        self.stableID = stableID
        self.name = name
        self.summary = summary
        self.createdAt = createdAt
        self.lineItems = lineItems
    }
}
