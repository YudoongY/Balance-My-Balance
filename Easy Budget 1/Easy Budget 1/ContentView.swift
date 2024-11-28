//Main structure to organize the list of transaction entries

import SwiftUI
import Combine

struct ContentView: View {
    @ObservedObject var account: Account
    @State private var showingIncomeSheet = false
    @State private var showingExpenseSheet = false

    var amount: Double {
        account.transactions.filter { $0.isIncome }.map { $0.amount }.reduce(0, +)
        - account.transactions.filter { !$0.isIncome }.map { $0.amount }.reduce(0, +)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                VStack(alignment: .leading) {
                // Account info and amount
                    HStack {
                        // Account image (circle)
                        Circle()
                            .frame(width: 45, height: 45)
                            .overlay(Text(account.icon).font(.title))
                        
                        Text(account.name)
                            .font(.bold(.title)())
                        
                        Spacer()
                        
                        VStack {
                            // Account amount
                            Text(String(format: "$ %.2f", amount))
                                .font(.bold(.title)())
                        }
                    }
                    .padding()
                    
                    VStack {
                        TextField("Description", text: $account.description)
                            .onReceive(Just(account.description)) { newValue in
                                if newValue.count > 45 {
                                    account.description = String(newValue.prefix(45))
                                }
                            } // Limit the number of char in the description line
                            .font(.headline)
                    }
                    .padding(.horizontal)
                }
                
                Divider()
                
                // 按日期分组并显示交易记录
                List {
                    ForEach(groupTransactionsByDate()) { dateGroup in
                        HStack {
                            Spacer()
                            Text(dateGroup.date, style: .date)
                                .font(.caption)
                                .foregroundColor(.black)
                            Spacer()
                        }
                        .padding(.vertical, -20)

                        // 显示交易记录
                        ForEach(dateGroup.transactions) { transaction in
                            ChatBubbleView(transaction: transaction)
                                .listRowInsets(EdgeInsets())
                                .listRowSeparator(.hidden) // 隐藏行间分隔符
                        }
                        .padding(.vertical, 0)
                    }
                }
                .listStyle(.plain)
                
                Spacer()
                    
                // 底部按钮，用于添加收入和支出
                HStack {
                    Button(action: {
                        showingIncomeSheet = true
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
                        showingExpenseSheet = true
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
            .sheet(isPresented: $showingIncomeSheet) {
                VStack{
                    AddIncomeView { newTransaction in
                        account.transactions.append(newTransaction)
                    }
                    .presentationDetents([.height(250)]) // Adjust the size of the window
                }// Pop up the sheet
            }
            .sheet(isPresented: $showingExpenseSheet) {
                VStack{
                    AddExpenseView { newTransaction in
                        account.transactions.append(newTransaction)
                    }
                    .presentationDetents([.height(250)]) // Adjust the size of the window
                }// Pop up the sheet
            }
        }
    }
    
    // 按日期分组交易记录
    private func groupTransactionsByDate() -> [TransactionDateGroup] {
        let grouped = Dictionary(grouping: account.transactions) { $0.dateOnly }
        return grouped.map { TransactionDateGroup(date: $0.key, transactions: $0.value) }
            .sorted { $0.date > $1.date } // 按日期降序排列
    }
}
