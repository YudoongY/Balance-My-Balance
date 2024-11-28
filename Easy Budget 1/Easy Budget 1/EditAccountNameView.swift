
import SwiftUI

struct EditAccountNameView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var account: Account

    var body: some View {
        NavigationView {
            Form {
                TextField("Account Name", text: $account.name)
            }
            .navigationTitle("Edit Account Name")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
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
