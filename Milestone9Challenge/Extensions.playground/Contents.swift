//: Playground - noun: a place where people can play

import UIKit
import GameplayKit

extension Integer {
    func isEven() -> Bool {
        if self % 2 == 0 {
            return true
        } else {
            return false
        }
    }
}

2.isEven()
3.isEven()
213091232.isEven()
112389712387.isEven()

extension String {
    var length: Int {
        return self.characters.count
    }
}

"Hi".length
"This is a longer string that I'm just typing because reasons".length

extension UIView {
    func bounceOut(duration: TimeInterval) {
        UIView.animate(withDuration: duration) { [unowned self] in
            self.transform = CGAffineTransform(translationX: 0.0001, y: 0.0001)
        }
    }
}

var view = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
view.backgroundColor = UIColor.green
view.bounceOut(duration: 10)

extension Array {
    mutating func shuffle() {
        self = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: self) as! Array
    }
}

var array = [1, 2, 3, 4, 5, 6]
array.shuffle()

extension Array where Element: Comparable {
    mutating func remove(item: Element) {
        
    }
}
