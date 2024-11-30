// Single line of account view in main page

import SwiftUI

struct AccountRowView: View {
    @Binding var account: Account
    @Binding var accounts: [Account] // To allow deletion of the account

    @State private var showingEditNameSheet = false
    @State private var showingEditIconSheet = false
    @State private var showingDeleteAlert = false

    var body: some View {
        HStack {
            NavigationLink(destination: TransactionsView(account: account)) {
                HStack {
                    Circle()
                        .frame(width: 45, height: 45)
                        .overlay(Text(account.icon).font(.title)) // Account Icon
                    Text(account.name) // Account Name
                    Spacer()
                }
                .padding(.horizontal)
            }
            .contentShape(Rectangle())

            Menu {
                Button("Edit Account Name") {
                    showingEditNameSheet = true // Show Edit Name Sheet
                }
                Button("Edit Account Icon") {
                    showingEditIconSheet = true // Show Edit Icon Sheet
                }
                Button(role: .destructive) {
                    showingDeleteAlert = true // Show Delete Alert
                } label: {
                    Text("Delete Account")
                }
            } label: {
                Image(systemName: "ellipsis")
                    .font(.title3)
                    .foregroundColor(.primary)
                    .frame(width: 35, height: 43)
            }
            .padding(.horizontal)
        }
        .sheet(isPresented: $showingEditNameSheet) {
            EditAccountNameView(account: $account) // Pass binding to the account
            .presentationDetents([.height(250)])
        }
        .sheet(isPresented: $showingEditIconSheet) {
            EditAccountIconView(account: $account) // Pass binding to the account
//            .presentationDetents([.height(250)])
        }
        .alert("Delete Account", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                if let index = accounts.firstIndex(where: { $0.id == account.id }) {
                    accounts.remove(at: index) // Delete account from list
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure you want to permanently delete this account?")
        }
    }
}
