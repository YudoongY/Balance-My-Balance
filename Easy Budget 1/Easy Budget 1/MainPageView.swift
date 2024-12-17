// Accounts selection page

import SwiftUI

struct MainPageView: View {
    @State var accounts: [Account] = []

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                HStack {
                    Text("Hi! How are you?")
                        .font(.title)
                        .padding(.bottom, 5)
                        .padding(.horizontal)
                    Spacer()
                }

                HStack {
                    Text("Accounts:")
                        .font(.headline)
                        .padding(.horizontal)
                    Spacer()
                }

                VStack {
                    ForEach($accounts) { $account in
                        AccountRowView(account: $account, accounts: $accounts)
                        Divider()
                    }

                    HStack {
                        Spacer()
                        Button(action: {
                            let newAccount = Account(name: "Account \(accounts.count + 1)")
                            accounts.append(newAccount) // Add new account
                        }) {
                            HStack {
                                Image(systemName: "plus.circle")
                                Text("Add Account")
                            }
                            .padding(.top)
                            .font(.headline)
                        }
                        Spacer()
                    }
                }

                Spacer()
            }
        }
    }
}

struct TransactionsView: View {
    @State var account: Account
    
    var body: some View {
        VStack{
            ContentView(account: account)
        }
        .navigationTitle(account.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
