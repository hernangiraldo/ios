import Foundation

var accountTotal: Float = 1_000_000.00

let name = "Hernán"
let lastName = "Giraldo"

let fullName = "\(name) \(lastName)"
print(fullName)
print(fullName.capitalized)

accountTotal = accountTotal + 100_000
accountTotal += 100_000

var account = 1e6
print(account)

var isActive = !fullName.isEmpty
print(isActive)

var myFullName = "Hernán Giraldo"
var age = 29
var amount = 3_250_000

print("Mi nombre es \(myFullName), tengo \(age) años y un saldo de \(amount) en mi cuenta de ahorros")

var transactions: [Float] = [20, 10, 100]
//Cuando tipamos alguno de los valores, queda tipado todo el array
var transactionsIm = [20, 10, 100.0]

transactions.count
transactions.isEmpty
transactions.append(140)
transactions.first
transactions.last
transactions[2]
transactions.removeLast()
transactions.removeAll()

var transactionsDaily: [[Float]] = [
    [20, 10, 100],
    [],
    [1000],
    [10],
]

transactionsDaily.first
transactionsDaily[0][0]
transactionsDaily[1].isEmpty
transactionsDaily[3][0]

var transactionsDic: [String: [Float]] = [
    "1ene": [20, 10, 100],
    "2ene": [],
    "3ene": [1000],
    "4ene": [10],
]

transactionsDic["1ene"]?.isEmpty
print(transactionsDic.keys)
print(transactionsDic.values)
print(transactionsDic.count)

if accountTotal < 1_000_000 {
    print("somos pobres")
} else if accountTotal >= 1_000_000 {
    print("somos ricos")
} else {
    print("somos muy ricos")
}

let hasMoney = accountTotal > 1_000_000 ? "Somos ricos" : "Somos pobres"

var myAge = 29
var tax: Float = 1

switch myAge {
case (0...18):
    print("20%")
case (18...25):
    tax = 1.5
    print("30%")
case (25...50):
    tax = 2
    print("40%")
default:
    tax = 3
    print("60%")
}

var todayTransactions: [Float] = [10, 20, 30]
var total: Float = 0
for transaction in todayTransactions {
    total += transaction
}
print(total)

var total2: Float = 0
for key in transactionsDic.keys{
    for transaction in transactionsDic[key] ?? [] {
        total2 += transaction
    }
}
print(total2)

var nameOpt: String?
print(nameOpt ?? "No tienes nombre")

nameOpt = "Hernán"

if let nameOpt = nameOpt {
    print(nameOpt)
}

print(nameOpt!)

var add: Float = 0
for key in transactionsDic.keys{
    for transaction in transactionsDic[key]! where transaction > 10{
        add += transaction
    }
}
print(add)

transactions = [20, 10, 100]

var total3 = transactions.reduce(0.0) { (result, element) -> Float in
    return result + element
}

print(total3)

print(transactions.reduce(0.0, { return $0 + $1 }))
print(transactions.reduce(0.0, { $0 + $1 }))
print(transactions.reduce(0.0, +))

var valuesDouble = transactions.map { (element) -> Float in
    return element * 2
}

//var orderValues = transactions.sorted(by: { (element1, element2) -> Bool in
//    return element1 > element2
//})
//var orderValues = transactions.sorted()
var orderValues = transactions.sorted(by: >)

var filteredValues = transactions.filter { (element) -> Bool in
    return element > 10
}

print(valuesDouble)
print(orderValues)
print(filteredValues)

transactions.removeAll(where: {
    $0 > 10
})

print(transactions)

//func totalAccount() {
//    var total: Float = 0
//    for key in transactionsDic.keys {
//        let array = transactionsDic[key]!
//        total += array.reduce(0.0, +)
//    }
//    print(total)
//}

// Se le pone un alias al nombre que va a tener el parámetro al momento de invocarse
// forTransactions transactions
func totalAccount(forTransactions transactions: [String: [Float]]) {
    print(transactions.reduce(0.0, {$0 + $1.value.reduce(0.0, +)}))
}
totalAccount(forTransactions: transactionsDic)

// Si no queremos poner el nombre al parámetro que se va a pasar al momento de la invocación
func totalAccount2(_ transactions: [String: [Float]]) {
    print(transactions.reduce(0.0, {$0 + $1.value.reduce(0.0, +)}))
}
totalAccount2(transactionsDic)

// Cuando una función retorna algo
func totalAccount3(_ transactions: [String: [Float]]) -> Float {
    return transactions.reduce(0.0, {$0 + $1.value.reduce(0.0, +)})
}
var invokeFunc = totalAccount3(transactionsDic)
print(invokeFunc)

func add(a: Int, b: Int) {
    print(a + b)
}
add(a: 1, b: 2)

//Tuplas
func multipleReturn(forTransactions transactions: [String: [Float]]) -> (Float, Int) {
    return (transactions.reduce(0.0, {$0 + $1.value.reduce(0.0, +)}), transactions.count)
}
var total4 = multipleReturn(forTransactions: transactionsDic)
print(total4)
print(total4.0, total4.1)

var toupleName = ("Hernán", "Giraldo")
print(toupleName.0)
print(toupleName.1)

var toupleName2 = (name: "Hernán", last: "Giraldo")
print(toupleName2.name)
print(toupleName2.last)

var a = 1
var b = 2
var c = 0

c = a
a = b
b = c

print(a, b)

var d = 1
var e = 2
(d, e) = (e, d)
print(d, e)

@discardableResult
func addTransaction(transactionValue value: Float) -> Bool {
    print(accountTotal)
    if (accountTotal - value) < 0 {
        return false
    }
    accountTotal -= value
    transactions.append(value)
    return true
}
let result = addTransaction(transactionValue: 30)

// Parámetro opcional con valor predeterminado
@discardableResult
func addTransaction2(transactionValue value: Float? = nil) -> Bool {
    guard let value = value else {
        return false
    }

    print(accountTotal)
    if (accountTotal - value) < 0 {
        return false
    }
    accountTotal -= value
    transactions.append(value)
    return true
}
let result2 = addTransaction2(transactionValue: 30)
addTransaction2()

//Parámetro opcional sin valor predeterminado
@discardableResult
func addTransaction3(transactionValue value: Float?) -> Bool {
    guard let value = value else {
        return false
    }
    
    print(accountTotal)
    if (accountTotal - value) < 0 {
        return false
    }
    accountTotal -= value
    transactions.append(value)
    return true
}
addTransaction3(transactionValue: nil)
