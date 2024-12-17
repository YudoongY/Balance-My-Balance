import SwiftUI

@main
struct Easy_Budget_1App: App {
    var body: some Scene {
        WindowGroup {
            MainPageView(accounts: [Account(name: "Account1")])
        }
    }
}
