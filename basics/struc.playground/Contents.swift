import Foundation

struct Account {
    var amount: Float = 0 {
        didSet {
            print("Tenemos nuevo valor", amount)
        }
    }
    var name: String = ""
    var transactions: [Float] = []
    
    init(amount: Float, name: String) {
        self.amount = amount
        self.name = name
    }
    
    @discardableResult
    mutating func addTransaction(value: Float) -> Float {
        if (amount - value) < 0 {
            return 0
        }
        amount -= value
        transactions.append(value)
        return amount
    }
}

struct Person {
    var name: String
    var lastName: String
    var account: Account?
}

var me = Person(name: "Hernán", lastName: "Giraldo", account: nil)
var account1 = Account(amount: 100_000, name: "X Bank")

me.account = account1

print(me.account!)

account1.addTransaction(value: 20)
print(me.account!)

me.account?.addTransaction(value: 20)
print(me.account!)
