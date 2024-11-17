//Main structure to organize the list of transaction entries

import SwiftUI
import Combine

struct ContentView: View {
    @State private var transactions: [Transaction]
    @State private var showingAddTransactionSheet = false
    @State private var accountName: String
    @State private var isAddingIncome = true // 用于判断添加的是收入还是支出
    @State private var description: String
    
    var account: Account

    init(account: Account) {
        self.account = account
        self.transactions = account.transactions
        self.description = account.description
        self.accountName = account.name
    }
        
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
                        Text(description)
                        TextField("Description", text: $description)
                            .onReceive(Just(description)) { newValue in
                                if newValue.count > 45 {
                                    description = String(newValue.prefix(45))
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
                VStack{
                    AddTransactionView(isIncome: isAddingIncome) { newTransaction in
                        transactions.append(newTransaction)
                    }
                    .presentationDetents([.height(250)]) // Limit the size of the window
                }// Pop up the sheet
            }
        }
    }
    
    // 按日期分组交易记录
    private func groupTransactionsByDate() -> [TransactionDateGroup] {
        let grouped = Dictionary(grouping: transactions) { $0.dateOnly }
        return grouped.map { TransactionDateGroup(date: $0.key, transactions: $0.value) }
            .sorted { $0.date > $1.date } // 按日期降序排列
    }
}
