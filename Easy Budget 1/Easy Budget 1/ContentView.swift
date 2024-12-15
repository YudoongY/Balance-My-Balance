//Main structure to organize the list of transaction entries

import SwiftUI
import Combine

struct ContentView: View {
    @ObservedObject var account: Account
    @State private var showingIncomeSheet = false
    @State private var showingExpenseSheet = false
    @State private var showingDatePicker = false
    @State private var selectedYear = Calendar.current.component(.year, from: Date())
    @State private var selectedMonth: Int? = Calendar.current.component(.month, from: Date())
    @State private var selectedWeek: Int? = nil // Initially no week selected


    var amount: Double {
        account.transactions.filter { $0.isIncome }.map { $0.amount }.reduce(0, +)
        - account.transactions.filter { !$0.isIncome }.map { $0.amount }.reduce(0, +)
    }
    
    var filteredTransactions: [Transaction] {
        account.transactions.filter { transaction in
            if let week = selectedWeek {
                return Calendar.current.component(.weekOfYear, from: transaction.timestamp) == week &&
                       Calendar.current.component(.year, from: transaction.timestamp) == selectedYear
            }
            if let month = selectedMonth {
                return Calendar.current.component(.month, from: transaction.timestamp) == month &&
                       Calendar.current.component(.year, from: transaction.timestamp) == selectedYear
            }
            return Calendar.current.component(.year, from: transaction.timestamp) == selectedYear
        }
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
                    
                    HStack {
                        Button(action: {
                            showingDatePicker = true
                        }) {
                            Text("\(selectedYear)\(selectedMonth == nil ? "" : " \(DateFormatter().monthSymbols[selectedMonth! - 1])")")
                                .font(.headline)
                        }
                        Spacer()
                        Button(action: {
                            // Placeholder for "current month left $100" action
                        }) {
                            Text(String(format: "Current month left $.2f", account.balance))
                                .font(.headline)
                        }
                    }
                    .padding()
                }
                
                Divider()
                
                // 按日期分组并显示交易记录
                List {
                    ForEach(groupTransactionsByDate(filteredTransactions)) { dateGroup in
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
            .sheet(isPresented: $showingDatePicker) {
                DatePickerModal(
                    selectedYear: $selectedYear,
                    selectedMonth: $selectedMonth,
                    selectedWeek: $selectedWeek
                )
                .presentationDetents([.height(400)])
            }
        }
    }
    
    // 按日期分组交易记录
//    private func groupTransactionsByDate() -> [TransactionDateGroup] {
//        let grouped = Dictionary(grouping: account.transactions) { $0.dateOnly }
//        return grouped.map { TransactionDateGroup(date: $0.key, transactions: $0.value) }
//            .sorted { $0.date > $1.date } // 按日期降序排列
//    }
    private func groupTransactionsByDate(_ transactions: [Transaction]) -> [TransactionDateGroup] {
        let grouped = Dictionary(grouping: transactions) { $0.dateOnly }
        return grouped.map { TransactionDateGroup(date: $0.key, transactions: $0.value) }
            .sorted { $0.date > $1.date }
    }
}
