import Foundation

extension Date {
    init(year: Int, month: Int, day: Int) {
        let calendar = Calendar(identifier: .gregorian)
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        self = calendar.date(from: dateComponents) ?? Date()
    }
}

protocol InvalidateTransaction {
    func invalidateTransaction(transaction: Transaction)
}

protocol Transaction {
    var value: Float { get }
    var name: String { get }
    var isValid: Bool { get set}
    var delegate: InvalidateTransaction? { get set }
    var date: Date { get }
}

extension Transaction {
    mutating func invalidateTransaction() {
        isValid = false
        delegate?.invalidateTransaction(transaction: self)
    }
}

protocol TransactionDebit: Transaction {
    var category: eDebit { get }
}

enum eDebit: String {
    case health
    case food
    case transportation
    case other
    case entertaiment
}

enum eProfit {
    case salary
    case bonus
    case freelance
}

enum eTransactionType {
    case debit(value: Float, name: String, category: eDebit, date: Date)
    case profit(value: Float, name: String, category: eProfit, date: Date)
}

class Debit: TransactionDebit {
    var delegate: InvalidateTransaction?
    var value: Float
    var name: String
    var category: eDebit
    var isValid: Bool = true
    var date: Date
    
    init(value: Float, name: String, category: eDebit, date: Date) {
        self.value = value
        self.name = name
        self.category = category
        self.date = date
    }
}

class Profit: Transaction {
    var delegate: InvalidateTransaction?
    var value: Float
    var name: String
    var category: eProfit
    var isValid: Bool = true
    var date: Date
    
    init(value: Float, name: String, category: eProfit, date: Date) {
        self.value = value
        self.name = name
        self.category = category
        self.date = date
    }
}

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
    var debits: [Debit] = []
    var profits: [Profit] = []
    
    init(amount: Float, name: String) {
        self.amount = amount
        self.name = name
    }
    
    @discardableResult
    func addTransaction(transaction: eTransactionType) -> Transaction? {
        switch transaction {
        case .debit(let debit):
            if (amount - debit.value) < 0 {
                return nil
            }
            amount -= debit.value
            let tmp = Debit(value: debit.value, name: debit.name, category: debit.category, date: debit.date)
            tmp.delegate = self
            debits.append(tmp)
            return tmp
        case .profit(let profit):
            amount += profit.value
            let tmp = Profit(value: profit.value, name: profit.name, category: profit.category, date: profit.date)
            tmp.delegate = self
            profits.append(tmp)
            return tmp
        }
    }
    
    func debitsByCategory(category: eDebit) -> [Transaction] {
        return transactions.filter({ (transaction) -> Bool in
            guard let transaction = transaction as? Debit else {
                return false
            }
            return transaction.category == category
        })
    }
    
    func profitsByCategory(category: eProfit) -> [Transaction] {
        return transactions.filter({ (transaction) -> Bool in
            guard let transaction = transaction as? Profit else {
                return false
            }
            return transaction.category == category
        })
    }
}

extension Account: InvalidateTransaction {
    func invalidateTransaction(transaction: Transaction) {
        if transaction is Debit {
            amount += transaction.value
        } else {
            amount -= transaction.value
        }
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

me.account?.addTransaction(
    transaction: .debit(
        value: 20,
        name: "Café con amigos",
        category: eDebit.food,
        date: Date(year: 2018, month: 11, day: 14)
    )
)

me.account?.addTransaction(
    transaction: .debit(
        value: 100,
        name: "Camiseta",
        category: eDebit.entertaiment,
        date: Date(year: 2018, month: 11, day: 10)
    )
)

me.account?.addTransaction(
    transaction: .debit(
        value: 500,
        name: "PS4",
        category: eDebit.entertaiment,
        date: Date(year: 2018, month: 11, day: 10)
    )
)
me.account?.addTransaction(
    transaction: .profit(
        value: 150,
        name: "Diseño",
        category: eProfit.freelance,
        date: Date(year: 2018, month: 11, day: 1)
    )
)

var free = me.account?.addTransaction(
    transaction: .profit(
        value: 150,
        name: "Diseño",
        category: eProfit.freelance,
        date: Date(year: 2018, month: 11, day: 1)
    )
)
free?.invalidateTransaction()

var debits = me.account?.debits
for debit in debits ?? [] {
    print(debit.category)
}

var debitsByCategory = me.account!.debitsByCategory(category: eDebit.entertaiment) as? [Debit]
for debit in debitsByCategory ?? [] {
    let type = debit.category.rawValue
    print(type.capitalized)
    print(debit.name, debit.value, debit.category.rawValue)
}

for gain in me.account?.profits ?? [] {
    print(gain.name, gain.value, gain.isValid)
}

print(me.account?.amount ?? 0.0)
