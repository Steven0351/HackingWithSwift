//: Playground - noun: a place where people can play

import UIKit

extension Int {
    mutating func plusOne() {
        self += 1
    }
}

extension Integer {
    func squared() -> Self {
        return self * self
    }
}

var myInt = 0

myInt.plusOne()
myInt

myInt = 10
myInt.plusOne()

//let otherInt = 10
//otherInt.plusOne()

let i: Int = 8
print(i.squared())