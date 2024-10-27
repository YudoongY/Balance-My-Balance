import SwiftUI

struct ChatBubbleView: View {
    var transaction: Transaction
    
    private var formattedTimestamp: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: transaction.timestamp)
    }
    
    var body: some View {
        VStack{
            // 时间戳
            Text(formattedTimestamp)
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.top, 10)
                .frame(maxWidth: .infinity, alignment: .center) // 居中对齐
            
            HStack {
                ZStack {
                    // 背景气泡
                    RoundedRectangle(cornerRadius: 12)
                        .fill(transaction.isIncome ? Color.green.opacity(0.3) : Color.red.opacity(0.3))
                    
                    // 气泡内的内容
                    HStack {
                        Text("  ")
                        Text(transaction.description)
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Text(String(format: transaction.isIncome ? "+ %.2f $" : "- %.2f $", transaction.amount))
                            .font(.title3)
                            .foregroundColor(transaction.isIncome ? .green : .red)
                        Text("  ")
                    }
                    .padding(.vertical)
                }
                .frame(maxWidth: .infinity, alignment: transaction.isIncome ? .leading : .trailing)
                .padding(transaction.isIncome ? .trailing : .leading, 40) // 调整气泡的左右间距
                .padding(.horizontal, 5)
                
            }
            .padding(.vertical, 1)
        }
    }
}

struct AddTransactionView: View {
    @Environment(\.dismiss) var dismiss // 用于关闭表单视图
    @State private var description = ""
    @State private var amount = ""
    @State private var isIncome: Bool
    
    var onAdd: (Transaction) -> Void
    
    init(isIncome: Bool, onAdd: @escaping (Transaction) -> Void) {
        self._isIncome = State(initialValue: isIncome)
        self.onAdd = onAdd
    }
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Description", text: $description)
                TextField("Amount", text: $amount)
                    .keyboardType(.decimalPad)
                
                //                Picker("Type", selection: $isIncome) {
                //                    Text("Income").tag(true)
                //                    Text("Expense").tag(false)
                //                }
                //                .pickerStyle(SegmentedPickerStyle())
            }
            
            .navigationTitle(isIncome ? "Add Income" : "Add Expense")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        // 保存按钮点击后的操作
                        if let amountValue = Double(amount) {
                            let newTransaction = Transaction(
                                description: description,
                                amount: amountValue,
                                isIncome: isIncome,
                                timestamp: Date()
                            )
                            onAdd(newTransaction) // 调用回调函数，添加交易
                            dismiss() // 关闭表单视图
                        }
                    }
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss() // 取消并关闭表单视图
                    }
                }
            }
        }
        .frame(height: 250)
    }
}

struct ContentView: View {
    @State private var transactions: [Transaction] = []
    @State private var showingAddTransactionSheet = false
    @State private var accountName: String = "Account1"
    @State private var isAddingIncome = true // 用于判断添加的是收入还是支出
    @State private var description: String = ""
        
    var amount: Double {
        transactions.filter { $0.isIncome }.map { $0.amount }.reduce(0, +)
        - transactions.filter { !$0.isIncome }.map { $0.amount }.reduce(0, +)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                VStack(alignment: .leading) {
                // Account info and amount
                HStack {
                    // Placeholder for account image (circle)
                    Circle()
                        .frame(width: 45, height: 45)
                        .overlay(Text("A").font(.title))  // Placeholder with 'A'
                    
                    Text(accountName)
                        .font(.bold(.title)())
                    
                    Spacer()
                    
                    VStack {
                        // Placeholder for account amount
                        Text(String(format: "$ %.2f", amount))
                            .font(.bold(.title)())
                    }
                }
                .padding()
                
                VStack {
                    TextField("Description", text: $description)
                        .keyboardType(.decimalPad)
                        .font(.headline)
                }
                .padding(.horizontal)
            }
                Divider()
                
                // 显示交易记录的列表
                List(transactions) { transaction in
                    ChatBubbleView(transaction: transaction)
                        .listRowInsets(EdgeInsets())
                        .listRowSpacing(0)
                }
                .listStyle(.plain)
                
                Spacer()
                
                // 底部按钮，用于添加收入和支出
                HStack {
                    Button(action: {
                        isAddingIncome = true
                        showingAddTransactionSheet = true
                    }) {
                        Text("Add Income")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green.opacity(0.7))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        isAddingIncome = false
                        showingAddTransactionSheet = true
                    }) {
                        Text("Add Expense")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red.opacity(0.7))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 10)
            }
            .sheet(isPresented: $showingAddTransactionSheet) {
                AddTransactionView(isIncome: isAddingIncome) { newTransaction in
                    transactions.append(newTransaction)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
