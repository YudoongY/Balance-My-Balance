import SwiftUI

@main
struct Easy_Budget_1App: App {
    var body: some Scene {
        WindowGroup {
//            ChatBubbleView(transaction: <#Transaction#>)
            MainPageView(accounts: [Account(name: "Account1", description: "")])
        }
    }
}
