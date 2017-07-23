//
//  Commit+CoreDataProperties.swift
//  GitHubCommits
//
//  Created by Steven Sherry on 7/22/17.
//  Copyright © 2017 Steven Sherry. All rights reserved.
//

import Foundation
import CoreData


extension Commit {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Commit> {
        return NSFetchRequest<Commit>(entityName: "Commit")
    }

    @NSManaged public var date: Date
    @NSManaged public var message: String
    @NSManaged public var sha: String
    @NSManaged public var url: String
    @NSManaged public var author: Author

}
