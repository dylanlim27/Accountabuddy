import SwiftUI

@main
struct AccountaBuddyApp: App {
    @StateObject private var store = BuddyStore()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(store)
                .preferredColorScheme(.light)
        }
    }
}
