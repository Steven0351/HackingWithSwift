//: Playground - noun: a place where people can play

import UIKit
import GameplayKit

// Without GameplayKit
print(arc4random()) // no control over range
print(arc4random())
print(arc4random())
print(arc4random())

print(arc4random() % 6) // modulo bias
print(arc4random_uniform(6)) // only allows specifying an upper bound and does not include negatives
print(arc4random_uniform(6))

// With GameplayKit
print(GKRandomSource.sharedRandom().nextInt()) // not always truly random in all situation
print(GKRandomSource.sharedRandom().nextInt(upperBound: 6)) // up to 5, upper bound is not inclusive

// GKLInearCongruentialRandomSource: high performance - low randomness

// GKMersenneTwisterRandomSource: high randomness - low performance
let mersenne = GKMersenneTwisterRandomSource()
mersenne.nextInt(upperBound: 20)

// GKARC4RandomSource: good performance - good randomness
let arc4 = GKARC4RandomSource()
arc4.nextInt(upperBound: 20)
arc4.dropValues(1024)    // Best practice to flush GKARC4RandomSource before using for anything important

// Built in die-roll
let d6 = GKRandomDistribution.d6()
d6.nextInt()

let d20 = GKRandomDistribution.d20()
d20.nextInt()

// Any random number within a specified range - inclusive - uses unspecified algorithm
let crazy = GKRandomDistribution(lowestValue: 1, highestValue: 11539)
crazy.nextInt()

// Any random number within a specified range - inclusive with specified algorithm
let rand = GKMersenneTwisterRandomSource()
let distribution = GKRandomDistribution(randomSource: rand,lowestValue: 10, highestValue: 20)
print(distribution.nextInt())

// GKShuffledDistribution - sequences repeat less frequently
let shuffled = GKShuffledDistribution.d6()
print(shuffled.nextInt())
print(shuffled.nextInt())
print(shuffled.nextInt())
print(shuffled.nextInt())
print(shuffled.nextInt())
print(shuffled.nextInt())

// GKGaussianDistribution - results naturally form a bell curve; results occur more frequently near the mean

let gaussian = GKGaussianDistribution.d20()
//for _ in 1 ... 100 {
//    print(gaussian.nextInt())
//}

// GK arrayByShufflingObjects(in:) - returns a randomly shuffled array - lottery example purely random
let lotteryBalls = [Int](1...49)
let shuffledBalls = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: lotteryBalls)
print(shuffledBalls[0])
print(shuffledBalls[1])
print(shuffledBalls[2])
print(shuffledBalls[3])
print(shuffledBalls[4])
print(shuffledBalls[5])

// lottery example with seed value - allows predictable "randomness"
let fixedLotteryBalls = [Int](1...49)
let fixedShuffledBalls = GKMersenneTwisterRandomSource(seed: 1001).arrayByShufflingObjects(in: fixedLotteryBalls)
print(fixedShuffledBalls[0])
print(fixedShuffledBalls[1])
print(fixedShuffledBalls[2])
print(fixedShuffledBalls[3])
print(fixedShuffledBalls[4])
print(fixedShuffledBalls[5])





