import SwiftUI
import SwiftData

// MARK: - WBPartnersiOSApp
@main
struct WBPartnersiOSApp: App {
    
    // MARK: - ModelContainer
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Product.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    // MARK: - Body
    var body: some Scene {
        WindowGroup {
            LaunchView()
        }
        .modelContainer(sharedModelContainer)
    }
}
