import SwiftUI

struct ContentView: View {
    // State to track the list of transactions and input data
    @State private var transactions: [Transaction] = []
    @State private var description: String = ""
    @State private var amount: String = ""
    @State private var isIncome: Bool = true

    var body: some View {
        NavigatioView {
            VStack {
                // Form to add a new transaction
                Form {
                    TextField("Description", text: $description)
                    TextField("Amount", text: $amount)
                        .keyboardType(.decimalPad)

                    Picker("Type", selection: $isIncome) {
                        Text("Income").tag(true)
                        Text("Expense").tag(false)
                    }.pickerStyle(SegmentedPickerStyle())

                    Button(action: addTransaction) {
                        Text("+")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(30)   // 10 --> 30
                    }
                }

                // List to display transactions
                List(transactions) { transaction in
                    HStack {
                        Text(transaction.description)
                        Spacer()
                        if(transaction.isIncome) {
                            Text(String(format: "+ $%.2f",transaction.amount))
                        } else {
                            Text(String(format: "- $%.2f",transaction.amount))
                        }
                            // .foregroundColor(transaction.isIncome ? .green : .red)
                        // Color --> +/-
                    }
                }
                .navigationTitle("Transactions")
            }
        }
    }

    func addTransaction() {
        
    }
    
}
