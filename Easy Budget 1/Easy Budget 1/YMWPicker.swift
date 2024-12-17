// Chosen of Year/Month/Week

import SwiftUI

struct DatePickerModal: View {
    @Binding var selectedYear: Int
    @Binding var selectedMonth: Int?
    @Binding var selectedWeek: Int?

    @State private var tempYear: Int
    @State private var tempMonth: Int?
    @State private var tempWeek: Int?
    @State private var pickerMode: String = "Year" // 控制当前的滚轮模式

    var onDone: (Int, Int?, Int?) -> Void
    var onCancel: () -> Void

    init(selectedYear: Binding<Int>, selectedMonth: Binding<Int?>, selectedWeek: Binding<Int?>, onDone: @escaping (Int, Int?, Int?) -> Void, onCancel: @escaping () -> Void) {
        self._selectedYear = selectedYear
        self._selectedMonth = selectedMonth
        self._selectedWeek = selectedWeek
        self.onDone = onDone
        self.onCancel = onCancel
        self._tempYear = State(initialValue: selectedYear.wrappedValue)
        self._tempMonth = State(initialValue: selectedMonth.wrappedValue)
        self._tempWeek = State(initialValue: selectedWeek.wrappedValue)
    }

    var body: some View {
        VStack(spacing: 20) {
            // 模式选择按钮
            HStack {
                ForEach(["Year", "Month", "Week"], id: \.self) { mode in
                    Button(action: {
                        pickerMode = mode
                        if mode == "Year" {
                            tempMonth = nil
                            tempWeek = nil
                        } else if mode == "Month" {
                            tempWeek = nil
                        }
                    }) {
                        Text(mode)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(pickerMode == mode ? Color.blue : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            }
            .padding(.horizontal)

            // 滚轮选择器
            if pickerMode == "Year" {
                Picker("Year", selection: $tempYear) {
                    ForEach(2006...2042, id: \.self) { year in
                        Text("\(year)").tag(year)
                    }
                }
                .pickerStyle(WheelPickerStyle())
            } else if pickerMode == "Month" {
                HStack {
                    Picker("Year", selection: $tempYear) {
                        ForEach(2006...2042, id: \.self) { year in
                            Text("\(year)").tag(year)
                        }
                    }
                    Picker("Month", selection: $tempMonth) {
                        ForEach(1...12, id: \.self) { month in
                            Text("\(DateFormatter().monthSymbols[month - 1])").tag(month)
                        }
                    }
                }
                .pickerStyle(WheelPickerStyle())
            } else if pickerMode == "Week" {
                HStack {
                    Picker("Year", selection: $tempYear) {
                        ForEach(2006...2042, id: \.self) { year in
                            Text("\(year)").tag(year)
                        }
                    }
                    Picker("Week", selection: $tempWeek) {
                        ForEach(1...52, id: \.self) { week in
                            Text("Week \(week)").tag(week)
                        }
                    }
                }
                .pickerStyle(WheelPickerStyle())
            }

            // 操作按钮
            HStack {
                Button("Cancel") {
                    onCancel()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.gray.opacity(0.7))
                .foregroundColor(.white)
                .cornerRadius(8)

                Button("Done") {
                    onDone(tempYear, tempMonth, tempWeek)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue.opacity(0.7))
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .padding(.horizontal)
        }
        .padding()
    }
}
