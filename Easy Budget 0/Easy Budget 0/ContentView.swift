import SwiftUI

struct ContentView: View {
    // State to track the list of transactions and input data
    @State private var transactions: [Transaction] = []
    @State private var description: String = ""
    @State private var amount: String = ""
    @State private var isIncome: Bool = true
    
    var totalIncome: Double {
        transactions.filter { $0.isIncome }.map { $0.amount }.reduce(0, +)
    }
    var totalExpense: Double {
        transactions.filter { !$0.isIncome }.map { $0.amount }.reduce(0, +)
    }
    var body: some View {
        NavigationView {
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
                        Text("Add Transaction")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                
                // List to display transactions
                List(transactions) { transaction in
                    HStack {
                        Text(transaction.description)
                        Spacer()
                        if(transaction.isIncome) {
                            Text(String(format: "+ $%.2f", transaction.amount))
                        } else {
                            Text(String(format: "- $%.2f", transaction.amount))
                        }
//                        Text(String(format: "$%.2f", transaction.amount))
//                            .foregroundColor(transaction.isIncome ? .green : .red)
                    }
                }
                .navigationTitle("Transactions")
            }
        }
    }
    
    // Function to add a new transaction
    func addTransaction() {
        guard let amountValue = Double(amount) else { return }
        let newTransaction = Transaction(description: description, amount: amountValue, isIncome: isIncome)
        transactions.append(newTransaction)
        description = ""
        amount = ""
    }
}

#Preview {
    ContentView()
}
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView1()
//    }
//}
