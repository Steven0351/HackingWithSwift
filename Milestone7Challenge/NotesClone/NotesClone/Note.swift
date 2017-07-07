//
//  Note.swift
//  NotesClone
//
//  Created by Steven Sherry on 7/7/17.
//  Copyright © 2017 Steven Sherry. All rights reserved.
//

import UIKit

class Note: NSObject, NSCoding {
    var text: String
    var date: Date
    
    init(text: String) {
        self.text = text
        self.date = Date()
    }
    
    required init?(coder aDecoder: NSCoder) {
        text = aDecoder.decodeObject(forKey: "text") as! String
        date = aDecoder.decodeObject(forKey: "date") as! Date
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(text, forKey: "text")
        aCoder.encode(date, forKey: "date")
    }
}
