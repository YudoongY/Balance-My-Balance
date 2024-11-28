// Accounts selection page

import SwiftUI

struct MainPageView: View {
    @State var accounts: [Account] = []
    @State private var showingDeleteAlert = false
    @State private var selectedAccountIndex: Int?
    @State private var activeSheet: ActiveSheet?
                                   
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                HStack {
                    Text("Hi! How are you?") //姑且用这个greeting
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
                    ForEach(accounts.indices, id: \.self) { index in
                        let account = accounts[index]
                        HStack {
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
                            .contentShape(Rectangle())
                            
                            Spacer()
                            
                            Menu {
                                Button("Edit Account Name") {
                                    selectedAccountIndex = index
                                    activeSheet = .editName
                                }
                                Button("Edit Account Icon") {
                                    selectedAccountIndex = index
                                    activeSheet = .editIcon
                                }
                                Button(role: .destructive) {
                                    selectedAccountIndex = index
                                    showingDeleteAlert = true
                                } label: {
                                    Text("Delete Account")
                                }
                            }
                            label: {
                                Image(systemName: "ellipsis")
                                    .font(.title3)
                                    .foregroundColor(.primary)
                                    .frame(width: 35, height: 43)
                            }
                            .padding(.horizontal)
                        }
                        .sheet(item: $activeSheet) { sheet in
                            if let index = selectedAccountIndex {
                                switch sheet {
                                    case .editName: EditAccountNameView(account: $accounts[index])
                                    case .editIcon: EditAccountIconView(account: $accounts[index])
                                }
                            }
                        }
                        
                        Divider()
                    }
                    
                    HStack {
                        Spacer()
                        // "+" button, for adding new accounts
                        Button(action: {
                            // Add a new account
                            let newAccount = Account(name: "Account\(accounts.count + 1)", description: "")
                            accounts.append(newAccount)
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
            .alert("Delete Account", isPresented: $showingDeleteAlert) {
                Button("Delete", role: .destructive) {
                    if let selectedAccountIndex = selectedAccountIndex{
//                       let index = accounts.firstIndex(where: { $0.id == selectedAccount.id }) {
                        accounts.remove(at: selectedAccountIndex)
                    }
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Are you sure you want to delete this account?")
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
