// Accounts selection page

import SwiftUI

struct MainPageView: View {
    @State var accounts: [Account] = []
    @State private var selectedIcon = "creditcard"
    @State private var showingIconPicker = false
                                   
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("Hi! How are you?") //姑且用这个greeting
                    .font(.title)
                    .padding(.bottom, 5)
                    .padding(.horizontal)
                
                Text("Accounts:")
                    .font(.headline)
                    .padding(.horizontal)
                
                VStack {
                    ForEach(accounts) { account in
                        NavigationLink(destination: TransactionsView(account: account)) {
                            HStack {
                                Circle()
                                    .frame(width: 45, height: 45)
                                    .overlay(Text(account.icon).font(.title))
                                // Account avatar
                                Text(account.name)
                                Spacer()
                                
                            }
                            .padding(.horizontal)
                        }
                        Divider()
                    }
                    
                    // "+" button, for adding new accounts
                    Button(action: {
                        // Add a new account
                        @State var newAccount = Account(name: "Account\(accounts.count + 1)", description: "")
                        accounts.append(newAccount)
                    }) {
                        HStack {
                            Image(systemName: "plus.circle")
                            Text("Add Account")
                        }
                        .padding(.top)
                        .font(.headline)
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

struct MainPageView_Previews: PreviewProvider {
    static var previews: some View {
        @State var accounts: [Account] = [Account(name: "Your Account", description: "")]
        MainPageView(accounts: accounts)
    }
}
