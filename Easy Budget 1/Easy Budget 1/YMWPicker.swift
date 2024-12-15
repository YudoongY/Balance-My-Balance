// Chosen of Year/Month/Week

import SwiftUI

struct DatePickerModal: View {
    @Binding var selectedYear: Int
    @Binding var selectedMonth: Int?
    @Binding var selectedWeek: Int?
    @State private var pickerMode: String = "Year"

    var body: some View {
        VStack {
            HStack {
                ForEach(["Year", "Month", "Week"], id: \.self) { mode in
                    Button(action: {
                        pickerMode = mode
                        if mode == "Year" {
                            selectedMonth = nil
                            selectedWeek = nil
                        } else if mode == "Month" {
                            selectedWeek = nil
                        }
                    }) {
                        HStack{
                            Spacer()
                            Text(mode)
                                .padding()
                                .background(pickerMode == mode ? Color.blue : Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            Spacer()
                        }
                    }
                }
            }
            .padding()

            if pickerMode == "Year" {
                Picker("Year", selection: $selectedYear) {
                    ForEach(2006...2042, id: \.self) { year in
                        Text("\(year)").tag(year)
                    }
                }
                .pickerStyle(WheelPickerStyle())
            } else if pickerMode == "Month" {
                HStack {
                    Picker("Year", selection: $selectedYear) {
                        ForEach(2006...2042, id: \.self) { year in
                            Text("\(year)").tag(year)
                        }
                    }
                    Picker("Month", selection: $selectedMonth) {
                        ForEach(1...12, id: \.self) { month in
                            Text("\(DateFormatter().monthSymbols[month - 1])").tag(month)
                        }
                    }
                }
                .pickerStyle(WheelPickerStyle())
            } else if pickerMode == "Week" {
                Picker("Year", selection: $selectedYear) {
                    ForEach(2006...2042, id: \.self) { year in
                        Text("\(year)").tag(year)
                    }
                }
                Picker("Week", selection: $selectedWeek) {
                    ForEach(1...52, id: \.self) { week in
                        Text("Week \(week)").tag(week)
                    }
                }
                .pickerStyle(WheelPickerStyle())
            }
        }
        .padding()
    }
}
