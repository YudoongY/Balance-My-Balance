// View to edit account name

import SwiftUI

struct EditAccountNameView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var account: Account
    @State private var tempName: String
    
    init(account: Binding<Account>) {
        self._account = account
        self._tempName = State(initialValue: account.wrappedValue.name)
    }

    var body: some View {
        NavigationView {
            Form {
                TextField("Account Name", text: $tempName)
            }
            .navigationTitle("Edit Account Name")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        account.name = tempName
                        dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}
