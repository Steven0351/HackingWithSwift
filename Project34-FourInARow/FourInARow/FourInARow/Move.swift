//
//  Move.swift
//  FourInARow
//
//  Created by Steven Sherry on 7/21/17.
//  Copyright © 2017 Steven Sherry. All rights reserved.
//

import UIKit
import GameplayKit

class Move: NSObject, GKGameModelUpdate {
    var value: Int = 0
    var column: Int
    
    init(column: Int) {
        self.column = column
    }
}
