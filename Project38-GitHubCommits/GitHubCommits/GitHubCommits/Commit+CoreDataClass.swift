//
//  Commit+CoreDataClass.swift
//  GitHubCommits
//
//  Created by Steven Sherry on 7/22/17.
//  Copyright © 2017 Steven Sherry. All rights reserved.
//

import Foundation
import CoreData

@objc(Commit)
public class Commit: NSManagedObject {
    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
        print("init called")
    }
}
