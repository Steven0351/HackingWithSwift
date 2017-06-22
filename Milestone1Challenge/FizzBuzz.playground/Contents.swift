//: Playground - noun: a place where people can play

import UIKit

func fizzBuzz(number: Int) -> String {
    let value = (number % 3 == 0 && number % 5 == 0) ? "Fizz Buzz" :
        number % 3 == 0 ? "Fizz" : number % 5 == 0 ? "Buzz" :"\(number)"
    return value
}

fizzBuzz(number: 3)
fizzBuzz(number: 5)
fizzBuzz(number: 15)
fizzBuzz(number: 16)