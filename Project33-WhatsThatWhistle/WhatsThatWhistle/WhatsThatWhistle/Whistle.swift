//
//  Whistle.swift
//  WhatsThatWhistle
//
//  Created by Steven Sherry on 7/20/17.
//  Copyright © 2017 Steven Sherry. All rights reserved.
//

import UIKit
import CloudKit

class Whistle: NSObject {
    var recordID: CKRecordID!
    var genre: String!
    var comments: String!
    var audio: URL!

}
