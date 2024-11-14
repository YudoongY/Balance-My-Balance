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

class Account: Identifiable, ObservableObject, Codable{
    let id = UUID()
    var name: String
    @Published var transactions: [Transaction] = []
    
    init(name: String) {
        self.name = name
    }
    
    // Coding keys to encode/decode `@Published` property
    enum CodingKeys: String, CodingKey {
        case id, name, transactions
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        transactions = try container.decode([Transaction].self, forKey: .transactions)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(transactions, forKey: .transactions)
    }
}

// 创建共享数据模型
class AccountManager: ObservableObject {
    @Published var accounts: [Account] = [
        Account(name: "Account1")
    ]
    
    private let userDefaultsKey = "SavedAccounts"

    // 保存数据到 UserDefaults
    func saveData() {
        if let encoded = try? JSONEncoder().encode(accounts) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
    }

    // 从 UserDefaults 加载数据
    func loadData() {
        if let savedData = UserDefaults.standard.data(forKey: userDefaultsKey),
           let decoded = try? JSONDecoder().decode([Account].self, from: savedData) {
            accounts = decoded
        }
    }
}
