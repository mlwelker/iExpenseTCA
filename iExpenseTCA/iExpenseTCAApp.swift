
import ComposableArchitecture
import SwiftUI

@main
struct iExpenseTCAApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(store: Store.init(
                initialState: Application.State(),
                reducer: { Application() })
            )
        }
    }
}
