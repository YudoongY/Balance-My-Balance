//
//  Foundation.swift
//  Easy Budget 1
//
//  Created by 高铭阳 on 10/20/24.
//

import Foundation

struct Transaction: Identifiable {
    let id = UUID()
    var description: String
    var amount: Double
    var isIncome: Bool
    var timestamp: Date
    
    // 仅保留日期部分
    var dateOnly: Date {
        Calendar.current.startOfDay(for: timestamp)
    }
}

// 用于按日期分组交易的结构体
struct TransactionDateGroup: Identifiable {
    let id = UUID()
    let date: Date
    let transactions: [Transaction]
}

// 创建共享数据模型
class AccountManager: ObservableObject {
    @Published var accounts: [Account] = [
        Account(name: "Account1")
    ]
}

class Account: Identifiable, ObservableObject{
    let id = UUID()
    var name: String
    @Published var transactions: [Transaction] = []
    
    init(name: String) {
        self.name = name
    }
}
