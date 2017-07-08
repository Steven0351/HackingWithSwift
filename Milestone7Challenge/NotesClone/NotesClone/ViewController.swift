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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if let firstLineIndex = notes[indexPath.row].text.characters.index(of: "\n") {
            cell.textLabel?.text = notes[indexPath.row].text.substring(to: firstLineIndex)
        } else {
            cell.textLabel?.text = notes[indexPath.row].text
        }
        cell.detailTextLabel?.text = notes[indexPath.row].date.toString()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailView") as! DetailVC
        vc.note = notes[indexPath.row]
        vc.notes = notes
        vc.noteIndex = indexPath.row
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func newNote() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailView") as! DetailVC
        vc.notes = notes
        navigationController?.pushViewController(vc, animated: true)
    }
}

