//Main structure to organize the list of transaction entries

import SwiftUI
import Combine

struct ContentView: View {
    @ObservedObject var account: Account
    @State private var showingIncomeSheet = false
    @State private var showingExpenseSheet = false
    @State private var showingDatePicker = false
    @State private var showingBudgetSheet = false
    @State private var selectedYear = Calendar.current.component(.year, from: Date())
    @State private var selectedMonth: Int? = Calendar.current.component(.month, from: Date())
    @State private var selectedWeek: Int? = nil // Initially no week selected
    @State private var selectedDisplayType: String = "Balance" // 当前选择的显示类型

    var totalIncome: Double {
        account.transactions.filter { $0.isIncome }.map { $0.amount }.reduce(0, +)
    }
    var totalExpense: Double {
        account.transactions.filter { !$0.isIncome }.map { $0.amount }.reduce(0, +)
    }
    var filteredExpense: Double {
        let filtered = account.transactions.filter { transaction in
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
        return filtered.filter { !$0.isIncome }.map { $0.amount }.reduce(0, +)
    }
    var filteredIncome: Double {
        let filtered = account.transactions.filter { transaction in
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
        return filtered.filter { $0.isIncome }.map { $0.amount }.reduce(0, +)
    }
    var displayedValue: String {
        switch selectedDisplayType {
        case "Balance":
            return String(format: "$ %.2f", totalIncome - totalExpense)
        case "Expense":
            return String(format: "$ %.2f", filteredExpense)
        case "Income":
            return String(format: "$ %.2f", filteredIncome)
        default:
            return "$ 0.00"
        }
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
        VStack {
            headerView()
            Divider()
            
            transactionListView()
            
            Spacer()
            
            bottomButtons()
        }
        .sheet(isPresented: $showingIncomeSheet) {
            VStack{
                AddIncomeView { newTransaction in
                    account.transactions.append(newTransaction)
                }
                .presentationDetents([.height(250)]) // Adjust the size of the window
            }
        }
        .sheet(isPresented: $showingExpenseSheet) {
            VStack{
                AddExpenseView { newTransaction in
                    account.transactions.append(newTransaction)
                }
                .presentationDetents([.height(250)]) // Adjust the size of the window
            }
        }
        .sheet(isPresented: $showingDatePicker) {
            DatePickerModal(
                selectedYear: $selectedYear,
                selectedMonth: $selectedMonth,
                selectedWeek: $selectedWeek,
                onDone: { year, month, week in
                    selectedYear = year
                    selectedMonth = month
                    selectedWeek = week
                    showingDatePicker = false // 关闭选择器
                },
                onCancel: {
                    showingDatePicker = false // 关闭选择器
                }
            )
            .presentationDetents([.height(400)])
        }
        .sheet(isPresented: $showingBudgetSheet) {
            BudgetEditView(
                account: account,
                selectedYear: $selectedYear,
                selectedMonth: $selectedMonth,
                selectedWeek: $selectedWeek,
                onSave: { newBudget in
                    if let week = selectedWeek {
                        account.weeklyBudget[week] = newBudget
                    } else if let month = selectedMonth {
                        account.monthlyBudget[month] = newBudget
                    } else {
                        account.yearlyBudget[selectedYear] = newBudget
                    }
                    showingBudgetSheet = false // 关闭表单
                },
                onCancel: {
                    showingBudgetSheet = false // 放弃修改，关闭表单
                }
            )
            .presentationDetents([.height(250)])
        }
    }
}

extension ContentView {
    private func headerView() -> some View {
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
                
                HStack {
                    Menu {
                        Button("Balance") {
                            selectedDisplayType = "Balance"
                        }
                        Button("Expense") {
                            selectedDisplayType = "Expense"
                        }
                        Button("Income") {
                            selectedDisplayType = "Income"
                        }
                    } label: {
                        Text(selectedDisplayType)
                            .font(.body)
                            .foregroundColor(.blue)
                            .underline() // 添加下划线表示可点击
                    }
                    
                    Text(displayedValue)
                        .font(.bold(.title)())
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 7)
            
            HStack {
                Button(action: {
                        showingDatePicker = true
                    }) {
                        let displayDate: String = {
                            if selectedWeek != nil {
//                                return "\(selectedYear) Week \(selectedWeek!)"
                                return "Current week"
                            } else if let month = selectedMonth {
                                return "\(selectedYear) \(DateFormatter().monthSymbols[month - 1])"
                            } else {
                                return "\(selectedYear)"
                            }
                        }()
                        Text(displayDate)
                            .font(.headline)
                    }
                
                Spacer()
                
                Button(action: {
                        showingBudgetSheet = true
                }) {
                    let currentLeft: String = {
                        if selectedWeek != nil {
                            let budget = account.weeklyBudget[selectedWeek!] ?? 0.0
                            let remaining = budget - filteredExpense
                            return String(format: "%.2f", remaining)
                        } else if let month = selectedMonth {
                            let budget = account.monthlyBudget[month] ?? 0.0
                            let remaining = budget - filteredExpense
                            return String(format: "%.2f", remaining)
                        } else {
                            let budget = account.yearlyBudget[selectedYear] ?? 0.0
                            let remaining = budget - filteredExpense
                            return String(format: "%.2f", remaining)
                        }
                    }()
                    
                    let label = selectedWeek != nil ? "Current week left" : selectedMonth != nil ? "Current month left" : "Current year left"
                    
                    Text("\(label) $\(currentLeft)")
                        .font(.headline)
                }
            }
            .padding(.horizontal)
        }
    }
    
    private func transactionListView() -> some View {
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
                
                ForEach(dateGroup.transactions) { transaction in
                    ChatBubbleView(transaction: transaction)
                        .listRowInsets(EdgeInsets())
                        .listRowSeparator(.hidden)
                }
                .padding(.vertical, 0)
            }
        }
        .listStyle(.plain)
    }
    
    private func bottomButtons() -> some View {
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
    
    private func groupTransactionsByDate(_ transactions: [Transaction]) -> [TransactionDateGroup] {
        let grouped = Dictionary(grouping: transactions) { $0.dateOnly }
        return grouped.map { TransactionDateGroup(date: $0.key, transactions: $0.value) }
            .sorted { $0.date > $1.date }
    }
}
