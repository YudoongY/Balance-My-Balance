//Icon picker view

import SwiftUI

struct IconPickerView: View {
    @Environment(\.presentationMode) var presentationMode
    let columns = [GridItem(.adaptive(minimum: 50))] // Adaptive grid layout
    @State private var searchText = ""
    @Binding var selectedIcon: String
    
    // All available SF Symbols (you can expand this list)
    let allIcons = [
        "banknote", "cart", "house", "gift", "creditcard",
        "bag", "bicycle", "car", "gamecontroller", "pc",
        "gear", "leaf", "pawprint", "bell", "calendar"
    ]
    
    var filteredIcons: [String] {
        if searchText.isEmpty {
            return allIcons
        } else {
            return allIcons.filter { $0.contains(searchText.lowercased()) }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Type to search", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(filteredIcons, id: \.self) { icon in
                            Button(action: {
                                selectedIcon = icon
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                Image(systemName: icon)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                                    .padding()
                                    .background(selectedIcon == icon ? Color.blue.opacity(0.3) : Color.clear)
                                    .cornerRadius(8)
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Choose an Icon")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}
