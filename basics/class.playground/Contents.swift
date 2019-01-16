import Foundation

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
    var transactions: [Float] = []
    
    init(amount: Float, name: String) {
        self.amount = amount
        self.name = name
    }
    
    @discardableResult
    func addTransaction(value: Float) -> Float {
        if (amount - value) < 0 {
            return 0
        }
        amount -= value
        transactions.append(value)
        return amount
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


print(me.account!.amount)

account1.addTransaction(value: 20)
print(me.account!.amount)

me.account?.addTransaction(value: 20)
print(me.account!.amount)
print(me.fullname)

me.fullname = "Gildardo Giraldo"
print(me.name)
