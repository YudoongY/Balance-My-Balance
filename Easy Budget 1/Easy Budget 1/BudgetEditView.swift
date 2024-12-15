//
//  BudgetEditView.swift
//  Easy Budget 1
//
//  Created by 高铭阳 on 12/14/24.
//

import SwiftUI

struct BudgetEditView: View {
    @ObservedObject var account: Account
    @Binding var selectedYear: Int
    @Binding var selectedMonth: Int?
    @Binding var selectedWeek: Int?

    @State private var budgetAmount: Double = 0.0

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
            
            TextField("Enter new budget amount", value: $budgetAmount, format: .number)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.decimalPad)

            Button("Save") {
                saveBudget()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
    }

    private func saveBudget() {
        if selectedWeek != nil {
            account.weeklyBudget[selectedWeek!] = budgetAmount
        } else if selectedMonth != nil {
            account.monthlyBudget[selectedMonth!] = budgetAmount
            updateWeeklyBudgetsForMonth()
        } else {
            account.yearlyBudget = budgetAmount
            updateMonthlyBudgets()
        }
    }

    private func updateWeeklyBudgetsForMonth() {
        guard let month = selectedMonth else { return }
        let weeks = calculateWeeksInMonth(year: selectedYear, month: month)
        let weeklyBudget = budgetAmount / Double(weeks.count)
        for week in weeks {
            account.weeklyBudget[week] = weeklyBudget
        }
    }

    private func updateMonthlyBudgets() {
        let monthlyBudget = budgetAmount / 12
        for month in 1...12 {
            account.monthlyBudget[month] = monthlyBudget
            updateWeeklyBudgetsForMonth()
        }
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
