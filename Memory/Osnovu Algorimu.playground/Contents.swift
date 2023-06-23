import UIKit

func algoritmSolution(str1:String , str2:String) -> Bool {
    let list1 = Array(str1)
    let list2 = Array(str2)
    list1.sorted(by: {$0 < $1})
    list1.sorted(by: {$0 < $1})
    
    var position = 0
    var matches = true
    
    while position < list1.count && matches {
        if list1[position] == list2[position] {
            position += 1
        } else {
            matches = false
        }
    }
    return matches
}

algoritmSolution(str1: "abc", str2: "bcs")
algoritmSolution(str1: "abc", str2: "bca")

//func fibonnacciRecursiveNum(num1: Int, num2:Int , steps:Int) {
//    if steps > 0 {
//        let newNum = num1 + num2
//        fibonnacciRecursiveNum(num2, num2: newNum , steps: steps - 1)
//    }
//    else {
//        print("result = \(num2)")
//    }
//}
//fibonnacciRecursiveNum(num1: 0, num2: 1, steps: 7)

