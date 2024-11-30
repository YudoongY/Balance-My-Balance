// View to edit account icon.
// The icon picker format should be modified.

import SwiftUI

struct EditAccountIconView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var account: Account
    let icons = ["💰", "🏦", "📈", "📉", "💸", "💳"]
    @State private var tempIcon: String

    init(account: Binding<Account>) {
        self._account = account
        self._tempIcon = State(initialValue: account.wrappedValue.icon)
    }

    var body: some View {
        NavigationView {
            List(icons, id: \.self) { icon in
                Button {
                    tempIcon = icon // Update the temporary icon
                } label: {
                    HStack {
                        Text(icon)
                        Spacer()
                        if icon == tempIcon {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
            .navigationTitle("Edit Account Icon")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        account.icon = tempIcon // Apply the change
                        dismiss() // Close the sheet
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss() // Dismiss without saving
                    }
                }
            }
        }
    }
}
