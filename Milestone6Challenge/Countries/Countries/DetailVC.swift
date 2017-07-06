//
//  DetailVC.swift
//  Countries
//
//  Created by Steven Sherry on 7/5/17.
//  Copyright © 2017 Steven Sherry. All rights reserved.
//

import UIKit

class DetailVC: UITableViewController {
    
    var country = [String: String]()
    var keys = [String]()
    var values = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = country["Name"]
        for (key, value) in country {
            if key == "Name" {
                continue
            }
            keys.append(key)
            values.append(value)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return values.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Detail", for: indexPath)
        cell.textLabel?.text = keys[indexPath.row]
        cell.detailTextLabel?.text = values[indexPath.row]
        return cell
    }

}
