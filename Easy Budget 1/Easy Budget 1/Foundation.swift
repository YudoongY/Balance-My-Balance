// All the declarations of structures and classes

import Foundation

struct Transaction: Identifiable, Codable {
    var id = UUID()
    var description: String
    var amount: Double
    var isIncome: Bool
    var timestamp: Date
    
    // 仅保留日期部分
    var dateOnly: Date {
        Calendar.current.startOfDay(for: timestamp)
    }
    
    init(id: UUID = UUID(), description: String, amount: Double, isIncome: Bool, timestamp: Date) {
        self.id = id
        self.description = description
        self.amount = amount
        self.isIncome = isIncome
        self.timestamp = timestamp
    }
}

// 用于按日期分组交易的结构体
struct TransactionDateGroup: Identifiable {
    let id = UUID()
    let date: Date
    let transactions: [Transaction]
}

class Account: Identifiable{
    let id = UUID()
    var name: String
    var description: String
    @Published var transactions: [Transaction] = []
    
    init(name: String, description: String) {
        self.name = name
        self.description = description
    }
}
