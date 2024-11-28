
import SwiftUI

struct EditAccountIconView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var account: Account
    let icons = ["💰", "🏦", "📈", "📉", "💸", "💳"]

    var body: some View {
        NavigationView {
            List(icons, id: \.self) { icon in
                Button {
                    account.icon = icon
                    dismiss()
                } label: {
                    HStack {
                        Text(icon)
                        Spacer()
                        if icon == account.icon {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
            .navigationTitle("Edit Account Icon")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}
