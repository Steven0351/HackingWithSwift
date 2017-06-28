//
//  Person.swift
//  NamesToFaces
//
//  Created by Steven Sherry on 6/28/17.
//  Copyright © 2017 Steven Sherry. All rights reserved.
//

import UIKit

class Person: NSObject {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }

}
