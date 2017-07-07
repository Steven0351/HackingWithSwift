//
//  ViewController.swift
//  NotesClone
//
//  Created by Steven Sherry on 7/7/17.
//  Copyright © 2017 Steven Sherry. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var notes = [Note]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Notes"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self,
                                                            action: #selector(newNote))
        
        let defaults = UserDefaults.standard
        
        if let savedNotes = defaults.object(forKey: "notes") as? Data {
            notes = NSKeyedUnarchiver.unarchiveObject(with: savedNotes) as! [Note]
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // return note representation
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // push detail view controller with file contents
    }
    
    func newNote() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailView") as! DetailVC
        present(vc, animated: true)
    }
}

