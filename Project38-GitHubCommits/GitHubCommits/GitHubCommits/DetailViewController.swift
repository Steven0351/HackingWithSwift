//
//  DetailViewController.swift
//  GitHubCommits
//
//  Created by Steven Sherry on 7/22/17.
//  Copyright © 2017 Steven Sherry. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailLabel: UILabel!
    
    var detailItem: Commit?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let detail = self.detailItem {
            detailLabel.text = detail.message
            //navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Commit 1/\(detail.author.commits.count)",
            //   style: .plain, target: self, action: #selector(showAuthorCommits))
        }
    }

    
}
