import SwiftUI
import Combine



struct ChatBubbleView: View {
    var transaction: Transaction
    
    private var formattedTimestamp: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: transaction.timestamp)
    }
    
    var body: some View {
        VStack{
            HStack {
                ZStack {
                    // 背景气泡
                    RoundedRectangle(cornerRadius: 12)
                        .fill(transaction.isIncome ? Color.green.opacity(0.3) : Color.red.opacity(0.3))
                    
                    // 气泡内的内容
                    HStack {
                        Text("  ")
                        Text(transaction.description)
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Text(String(format: transaction.isIncome ? "+ %.2f $" : "- %.2f $", transaction.amount))
                            .font(.title3)
                            .foregroundColor(transaction.isIncome ? .green : .red)
                        Text("  ")
                    }
                    .padding(.vertical)
                }
                .frame(maxWidth: .infinity, alignment: transaction.isIncome ? .leading : .trailing)
                .padding(transaction.isIncome ? .trailing : .leading, 40) // 调整气泡的左右间距
                .padding(.horizontal, 5)
                
            }
            .padding(.vertical, 1)
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView(account: account)
//    }
//}
