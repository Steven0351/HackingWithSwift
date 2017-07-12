//
//  Enums.swift
//  ShootingGallery
//
//  Created by Steven Sherry on 7/12/17.
//  Copyright © 2017 Steven Sherry. All rights reserved.
//

import UIKit


enum SequenceType: Int {
    case twoNoBadTarget, twoWithBadTarget, three, four, random
}

enum ForceBadTarget {
    case never, always, random
}

enum TargetSize: Int {
    case big, medium, small
}

enum TargetSpeed: Double {
    case big = 8.0
    case medium = 5.0
    case small = 2.0
}

enum Row: CGFloat {
    case top = 590
    case middle = 340
    case bottom = 100
    case leftStart = -55
    case rightStart = 1084
}
