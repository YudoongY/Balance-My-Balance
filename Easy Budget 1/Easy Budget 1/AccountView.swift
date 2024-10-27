//import SwiftUI
//
//struct AccountView: View {
//    // State variables to track account info
//    @State private var incomes: [Income] = []
//    @State private var expenses: [Expense] = []
//    @State private var accountName: String = "Account1"
//    @State private var description: String = ""
//    @State private var amount: Double = 0.0
//    
//    var body: some View {
//        NavigationView {
//            VStack(alignment: .leading) {
//                // Account info and amount
//                HStack {
//                    // Placeholder for account image (circle)
//                    Circle()
//                        .frame(width: 30, height: 30)
//                        .overlay(Text("A").font(.largeTitle))  // Placeholder with 'A'
//                    
//                    Text(accountName)
//                        .font(.headline)
//                    
//                    Spacer()
//                    
//                    VStack {
//                        Text("Amount")
//                            .font(.caption) // Added
//                        // Placeholder for account amount
//                        Text(String(format: "$%.2f", amount))
//                            .font(.headline)
//                    }
//                }
//                .padding()
//                
//                HStack {
//                    TextField("Description", text: $description)
//                        .keyboardType(.decimalPad)
//                }
//                .padding()
//                
//                Divider()
//                
//                // Income and Expense section
//                HStack {
//                    
//                    Spacer()
//                    
//                    VStack {
//                        Text("Income")
//                            .font(.headline)
////                        Spacer()
//                        List(incomes) { income in
//                            HStack {
//                                Text(income.description)
//                                Spacer()
//                                Text(String(format: "+ $%.2f", income.amount))
//                            }
//                        }
//                    }
//                    
//                    Spacer()
//                    Spacer()
//                    
//                    VStack {
//                        Text("Expense")
//                            .font(.headline)
////                        Spacer()
//                        List(expenses) { expense in
//                            HStack {
//                                Text(expense.description)
//                                Spacer()
//                                Text(String(format: "- $%.2f", expense.amount))
//                            }
//                        }
//                    }
//                    
//                    Spacer()
//                    
//                }
//                .padding()
//                
//                Spacer()
//                
//                // Bottom buttons
//                HStack {
//                    
//                    Spacer()
//                    
//                    Button(action: addIncome) {
//                        Text("+")
//                            .padding()
//                            .background(Color.red)
//                            .foregroundColor(.white)
//                            .cornerRadius(10)
//                    }
//                    
//                    Spacer()
//                    Spacer()
//                    Spacer()
//                    Spacer()
//                    Spacer()
//                    Spacer()
//                    
//                    Button(action: addExpense) {
//                        Text("+")
//                            .padding()
//                            .background(Color.green)
//                            .foregroundColor(.white)
//                            .cornerRadius(10)
//                    }
//                    
//                    Spacer()
//                    
//                }
//                .padding(.horizontal)
//                
//            }
//            //.navigationTitle("Hi! User")
//        }
//    }
//    
//    func addIncome() {
//        let amountValue = amount
//        let newIncome = Income(description: description, amount: amountValue)
//        incomes.append(newIncome)
//        description = ""
//        amount = 0
//    }
//    func addExpense() {
//        let amountValue = amount
//        let newExpense = Expense(description: description, amount: amountValue)
//        expenses.append(newExpense)
//        description = ""
//        amount = 0
//    }
//}
//
//struct AccountView_Previews: PreviewProvider {
//    static var previews: some View {
//        AccountView()
//    }
//}
