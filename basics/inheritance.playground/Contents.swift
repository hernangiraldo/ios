import Foundation

class Transaction {
    var value: Float
    var name: String
    
    init(value: Float, name: String) {
        self.value = value
        self.name = name
    }
}

class Debit: Transaction {}

class Profit: Transaction {}

class Account {
    var amount: Float = 0 {
        // Cuando la variable va a ser modificada
        willSet {
            print("La variable será  modificada", amount, newValue)
        }
        
        // Cuando la variable ha sido modificada
        didSet {
            print("Tenemos nuevo valor", amount)
        }
    }
    var name: String = ""
    var transactions: [Transaction] = []
    
    init(amount: Float, name: String) {
        self.amount = amount
        self.name = name
    }
    
    @discardableResult
    func addTransaction(transaction: Transaction) -> Float {
        
        
        
        if transaction is Profit {
            amount += transaction.value
        }
        
        if transaction is Debit {
            if (amount - transaction.value) < 0 {
                return 0
            }
            
            amount -= transaction.value
        }
        transactions.append(transaction)
        return amount
    }
    
    func debits() -> [Transaction] {
        return transactions.filter({ $0 is Debit})
    }
    
    func profits() -> [Transaction] {
        return transactions.filter({ $0 is Profit})
    }
}

class Person {
    var name: String = ""
    var lastname: String = ""
    var account: Account?
    var fullname: String {
        get {
            return "\(name) \(lastname)"
        }
        // Otra forma de hacer el get
        // return "\(name) \(lastname)"
        
        set {
            name = String(newValue.split(separator: " ").first ?? "")
            lastname = String(newValue.split(separator: " ").last ?? "")
        }
    }
    
    init(name: String, lastname: String) {
        self.name = name
        self.lastname = lastname
    }
}

var me = Person(name: "Hernán", lastname: "Giraldo")
var account1 = Account(amount: 100_000, name: "X Bank")
me.account = account1

me.account?.addTransaction(transaction: Debit(value: 20, name: "Café con amigos"))
me.account?.addTransaction(transaction: Debit(value: 100, name: "Camiseta"))
me.account?.addTransaction(transaction: Debit(value: 500, name: "PS4"))
me.account?.addTransaction(transaction: Profit(value: 150, name: "Diseño"))
print(me.account!.amount)
