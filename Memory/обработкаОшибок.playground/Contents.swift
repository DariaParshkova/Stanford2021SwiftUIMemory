import UIKit

/*enum VendingMachineError : Error {
    case invalidSelection
    case insufficientFunds(coinsNeeded: Int)
    case outOfStock
}

throw VendingMachineError.insufficientFunds(coinsNeeded: 5)
struct Item {
    var price : Int
    var count: Int
}
class VendingMachine {
    var inventory = [
        "Candy Bar ": Item(price: 12, count: 7),
        "Chops": Item(price: 10, count: 4),
        "Pretzels": Item(price:7 , count:11)
    ]
    var coinsDeposited = 0
    
    func vend(itemNamed name : String ) throws {
        guard let item = inventory[name] else {
            throw VendingMachineError.invalidSelection
        }
        guard item.count > 0 else {
            throw VendingMachineError.outOfStock
        }
        guard item.price <= coinsDeposited else {
            throw VendingMachineError.insufficientFunds(coinsNeeded: item.price - coinsDeposited)
        }
        coinsDeposited -= item.price
        var newItem = item
        newItem.count -= 1
        inventory[name] = newItem
        print("Dispensing \(name)")
        
    }
}
let favoriteSnacks = [
    "Alice":"Chips",
    "Bob": "Licorice",
    "Eve": "Pretzels"

]
func buyFavoriteSnack(person:String, vendingMachine: VendingMachine) throws {
    let snackName = favoriteSnacks[person] ?? "Candy Bar"
    try vendingMachine.vend(itemNamed: snackName  )
}
struct PurchedSnack {
    let name: String
    init(name:String, vendingMachine: VendingMachine) throws {
        try vendingMachine.vend(itemNamed: name )
        self.name = name
    }
}

*/


// Ne smogli proiznesti zaklinaniya

//1 oshibkikotorue mogut proizoyiti
enum SpellCastError : Error {
    case spellIsNoteLearned
    case notEnoughMana(needMore:Int) //predostavim information scolko ne hvataet manu
    case friendlyTarget
}

//2 rashirenie dly podrobnogo opisania
//CustomStringConvertible - protocol kotor pozvolyaet dobavit svoystwa description
// self t k mu rashur spellcastError i smotrim na znachenie kotoroe u nas est
extension SpellCastError : CustomStringConvertible {
    var description: String {
        switch self {
        case .spellIsNoteLearned : return "spell is not learned yet"
        case .notEnoughMana(let mana): return "need \(mana) more"
        case .friendlyTarget: return "you can't this spell on friendly targets"
        
        }
    }
}
protocol Target {}
struct Enemy : Target {}
struct Friend : Target{}

class Mage {
    var mana = 0
    var spells = ["fireball":100]
    func fillMana() {
        mana = 1000
    }
    // methods kotorue budut generirovat oshibki
    //throws pozvolyaet func nauchitsy generirovat oshubku
    func castHarmSpell(onEnemy target: Target) throws  {
        if target is Friend {
            throw SpellCastError.friendlyTarget
        }
        print("cast fireball all enemies")
        //  ^^^^ esli net oshibki
    }
    // hotim raspostranit oshibku dalshe
    func castFireBall(onTarget target : Target) throws {
        if mana < spells["fireball"]! {
            throw SpellCastError.notEnoughMana(needMore: spells["fireball"]! - mana)
        }
        //nasha mana menshe chem spells berem key- fireball , to pishem scolko manu ne havtaet
        if !spells.keys.contains("fireball") {
            throw SpellCastError.spellIsNoteLearned
        }
        //est li v nashem slovare fireball to generir oshibku\
        print("Cast fireball again!") //ctobu ne zastryat na drugih methodah , v sluchae esli oshibki ne budet
    }
    
}

//kak eto budet rabotat
let targetF = Friend()
let targetE = Enemy()
let mage = Mage()

// do eto vuzov
//catch - vozvrashenie
//zdec raasmotreli func castHarmSpell
do {
    try mage.castHarmSpell(onEnemy: targetF)
} catch  let error as SpellCastError {
    switch error  {
    case .friendlyTarget : print(error.description)
    default: break
    }
}

do {
    try mage.castFireBall(onTarget: targetE)
} catch SpellCastError.notEnoughMana(let mana) {
    print(SpellCastError.notEnoughMana(needMore: mana).description)
} catch SpellCastError.spellIsNoteLearned {
    print(SpellCastError.spellIsNoteLearned.description)
}
mage.fillMana()
do {
    try mage.castFireBall(onTarget: targetE)
} catch SpellCastError.notEnoughMana(let mana) {
    print(SpellCastError.notEnoughMana(needMore: mana).description)
} catch SpellCastError.spellIsNoteLearned {
    print(SpellCastError.spellIsNoteLearned.description)
}

// Throwing FUNC nuzhnu dlya togo chtobu mu mogli razbivat oshibi na bolee melkie, chobu ih  tochno identeficirovat

