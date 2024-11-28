// Pop up sheet window to fill out a description about current transaction and the amount of income/expense

import SwiftUI

struct AddIncomeView: View {
    @Environment(\.dismiss) var dismiss // 用于关闭表单视图
    @State private var description = ""
    @State private var amount = ""
    
//    let isIncome: Bool
    var onAdd: (Transaction) -> Void
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Description", text: $description)
                TextField("Amount", text: $amount)
                    .keyboardType(.decimalPad)
            }
            .navigationTitle("Add Income")
            
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        // 保存按钮点击后的操作
                        if let amountValue = Double(amount) {
                            let newTransaction = Transaction(
                                description: description,
                                amount: amountValue,
                                isIncome: true,
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
    }
}

struct AddExpenseView: View {
    @Environment(\.dismiss) var dismiss // 用于关闭表单视图
    @State private var description = ""
    @State private var amount = ""
    
    var onAdd: (Transaction) -> Void
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Description", text: $description)
                TextField("Amount", text: $amount)
                    .keyboardType(.decimalPad)
            }
            .navigationTitle("Add Expense")
            
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        // 保存按钮点击后的操作
                        if let amountValue = Double(amount) {
                            let newTransaction = Transaction(
                                description: description,
                                amount: amountValue,
                                isIncome: false,
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
    }
}
