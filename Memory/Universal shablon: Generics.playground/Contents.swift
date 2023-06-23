import UIKit
struct FileSystem {
    static func save(param: Any) {
        print("save \(param) to fileSystem")
    }
}
/*
//func kotoraya rabotatet s strokovomu dannuma
func saveToFileSystem(data:String) {
    FileSystem.save(param: data)
}
//func kotoraya rabotatet s chislivumi dannuma
func saveToFileSystem(data:Int) {
    FileSystem.save(param: data)
}
*/
//Universal func - Generic T-TypePlaceHplder zamenitel tipa
func saveToFileSystem<T>(data:T) {
    FileSystem.save(param: data)
}

saveToFileSystem(data: 123)
saveToFileSystem(data: 123.0)
saveToFileSystem(data:"lolo")
saveToFileSystem(data:[1,2,4,5,6,7])
//No v nekororuh sluchayah, tipu dannuh dolznu sootvetstvovat kakim-to trebovaniuam
//naposhem u niversalnuy calculytor

/* Vozniknet problema, t k nelzya sravnivat prosto 2 tipa nuzhen protocol Equatable- soderzhit v sebe 2 operatora = and !="*/
 
func isEqual<T:Equatable>(x:T, y:T) -> Bool {
    return x == y
}
let arr = [1, 2,3]
let arr1 = [1.0, 2.1,3.4]
 
let dict = [1:"one", 2:"two"]

struct Queue<T> {
    var array = [T]()
    var count : Int {
        return array.count
    }
    mutating func add(_ item:T) {
        array.append(item)
    }
    mutating func remove() -> T? {
        return array .isEmpty ? nil : array.removeFirst()
    }
}

var quequ = Queue<String>()
quequ.add("SOME TASK")
quequ.add("lol1")
quequ.add("SOME j")
quequ.add("4")
quequ.count
quequ.remove()
quequ.count
//nam ne prishlos zadavat tip T
extension Queue {
    var topTask: T? {
        return array.isEmpty ? nil : array.first
    }
}
quequ.topTask
//1
//Nuzno napisat tri massiva i method kotorue budut ih raspechatuvat

var stringArr = ["Huy", "Hello", "Good by"]
var intArr = [1,2,3 ,4 ,5 , 6, 7]
var doubleArr = [1.2, 1.3, 1.4]

func printElementFromArray<T>(a:[T]) {
    for elements in a {
        print(elements)
    }
}

printElementFromArray(a: doubleArr)


//2
func doNothing<T>(x:T) -> T {
    return x
}
doNothing(x: "mam")
doNothing(x: 123)
doNothing(x: false)

//3
var emptyArr = [String]()
struct GenericArray<T> {
    var items = [T]()
    mutating func push(item:T) {
        items.append(item)
    }
}
var myFriendsList  = ["Katya", "Bob", "Lilit"]
var arrays = GenericArray(items: myFriendsList)
arrays.push(item: "Nik")
