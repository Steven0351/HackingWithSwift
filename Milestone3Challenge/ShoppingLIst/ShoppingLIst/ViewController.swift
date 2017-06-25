//
//  ViewController.swift
//  ShoppingLIst
//
//  Created by Steven Sherry on 6/25/17.
//  Copyright © 2017 Steven Sherry. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var shoppingList = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Shopping List"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self,
                                                            action: #selector(addItem))
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath)
        cell.textLabel?.text = shoppingList[indexPath.row]
        return cell
    }
    

    func addItem() {
        let vc = UIAlertController(title: "Add item to list", message: nil, preferredStyle: .alert)
        vc.addTextField()
        
        let addAction = UIAlertAction(title: "Add", style: .default) { [unowned self, vc] _ in
            let item = vc.textFields![0]
            self.add(item: item.text!)
        }
        vc.addAction(addAction)
        present(vc, animated: true)
    }
    
    func add(item: String) {
        shoppingList.insert(item, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
}

