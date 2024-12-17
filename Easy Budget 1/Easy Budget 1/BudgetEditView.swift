// Edit Monthly/Weekly/Yearly Budget here

import SwiftUI

struct BudgetEditView: View {
    @ObservedObject var account: Account
    @Binding var selectedYear: Int
    @Binding var selectedMonth: Int?
    @Binding var selectedWeek: Int?

    @State private var tempBudgetAmount: Double? = nil
    var onSave: (Double) -> Void
    var onCancel: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text("Edit Budget")
                .font(.headline)
            
            if selectedWeek != nil {
                Text("Editing Weekly Budget for Week \(selectedWeek!)")
            } else if selectedMonth != nil {
                Text("Editing Monthly Budget for \(DateFormatter().monthSymbols[selectedMonth! - 1]) \(selectedYear)")
            } else {
                Text("Editing Yearly Budget for \(selectedYear)")
            }
            
            TextField("Enter new budget amount", value: $tempBudgetAmount, format: .number)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.decimalPad)
                .padding(.horizontal)
                .onAppear {
                    if let week = selectedWeek, let budget = account.weeklyBudget[week] {
                        tempBudgetAmount = budget
                    } else if let month = selectedMonth, let budget = account.monthlyBudget[month] {
                        tempBudgetAmount = budget
                    } else if let budget = account.yearlyBudget[selectedYear] {
                        tempBudgetAmount = budget
                    }
                }

            HStack {
                Button("Cancel") {
                    onCancel()
                }
                .padding()
                .background(Color.gray.opacity(0.7))
                .foregroundColor(.white)
                .cornerRadius(8)
                
                Button("Save") {
                    let finalBudget = tempBudgetAmount ?? 0.0 // 如果用户未输入，则默认保存为 0
                    onSave(finalBudget)
                }
                .padding()
                .background(Color.blue.opacity(0.7))
                .foregroundColor(.white)
                .cornerRadius(8)
            }
        }
        .padding()
        
    }

    private func calculateWeeksInMonth(year: Int, month: Int) -> [Int] {
        // 根据年份和月份计算每月的周
        let calendar = Calendar.current
        let dateComponents = DateComponents(year: year, month: month)
        guard let startDate = calendar.date(from: dateComponents) else { return [] }
        var weeks: [Int] = []
        for dayOffset in 0..<calendar.range(of: .day, in: .month, for: startDate)!.count {
            let date = calendar.date(byAdding: .day, value: dayOffset, to: startDate)!
            let week = calendar.component(.weekOfYear, from: date)
            if !weeks.contains(week) {
                weeks.append(week)
            }
        }
        return weeks
    }
}
