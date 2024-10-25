import SwiftUI

struct AccountView: View {
    // State variables to track account info
    @State private var accountName: String = "Account1"
    @State private var description: String = "This is my main account."
    @State private var amount: Double = 1000.0
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                // Account info and amount
                HStack {
                    // Placeholder for account image (circle)
                    Circle()
                        .frame(width: 50, height: 50)
                        .overlay(Text("A").font(.largeTitle))  // Placeholder with 'A'
                    
                    VStack(alignment: .leading) {
                        Text(accountName)
                            .font(.headline)
                    }
                    
                    Spacer()
                    
                    
                    Text("Amount")
                        .font(.caption) // Added
                    // Placeholder for account amount
                    Text(String(format: "$%.2f", amount))
                        .font(.headline)
                }
                .padding()
                
                // Description field
                // Text("Description: \(description)")
                //     .padding(.horizontal)
                //     .padding(.bottom, 10)
                TextField("Description", text: $description)
                    TextField("Amount", text: $amount)
                        .keyboardType(.decimalPad)
                
                Divider()
                
                // Income and Expense section
                HStack {
                    VStack {
                        Text("Income")
                            .font(.headline)
                        Spacer()
                    }
                    
                    Spacer()
                    
                    VStack {
                        Text("Expense")
                            .font(.headline)
                        Spacer()
                    }
                }
                .padding()
                
                Spacer()
                
                // Bottom buttons
                HStack {
                    Button(action: {
                        // Handle income button action
                    }) {
                        Text("+")
                            .padding()
                            .background(Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        // Handle expense button action
                    }) {
                        Text("+")
                            .padding()
                            .background(Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
                
            }
            .navigationTitle("Page 2")
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}
