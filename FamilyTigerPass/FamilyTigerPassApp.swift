import SwiftUI
import SwiftData

@main
struct FamilyTigerPassApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(for: [Project.self, LineItem.self])
    }
}
