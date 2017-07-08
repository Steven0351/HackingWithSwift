//
//  DetailVC.swift
//  NotesClone
//
//  Created by Steven Sherry on 7/7/17.
//  Copyright © 2017 Steven Sherry. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {

    @IBOutlet weak var textView: UITextView!
    var note: Note?
    var notes: [Note]?
    var noteIndex: Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(newNote))
        let deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(removeNote))
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share))
        
        navigationItem.rightBarButtonItems = [saveButton, deleteButton, shareButton]
        
        if let text = note?.text {
            textView.text = text
        } else {
            textView.text = ""
        }
    }

    func save() {
        let savedData = NSKeyedArchiver.archivedData(withRootObject: notes!)
        let defaults = UserDefaults.standard
        defaults.set(savedData, forKey: "notes")
        navigationController?.popToRootViewController(animated: true)
    }
    
    func newNote() {
        if let note = note {
            note.text = textView.text
        } else {
            note = Note(text: textView.text)
            notes!.append(note!)
        }
        save()
    }
    
    func removeNote() {
        if let noteIndex = noteIndex {
            notes!.remove(at: noteIndex)
            save()
        }
    }
    
    func share() {
        // Share note
    }

}
