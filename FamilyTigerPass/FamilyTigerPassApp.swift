import SwiftData
import SwiftUI

@main
struct FamilyTigerPassApp: App {
    private let dependencies = AppDependencies()

    var body: some Scene {
        WindowGroup {
            RootView(dependencies: dependencies)
        }
        .modelContainer(for: [Project.self, LineItem.self])
    }
}
