//
//  DetailVC.swift
//  NotesClone
//
//  Created by Steven Sherry on 7/7/17.
//  Copyright © 2017 Steven Sherry. All rights reserved.
//

import UIKit
import Social

class DetailVC: UIViewController {

    @IBOutlet weak var textView: UITextView!
    var note: Note?
    var noteIndex: Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard),
                                       name: Notification.Name.UIKeyboardWillHide, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard),
                                       name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)

        
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
        let savedData = NSKeyedArchiver.archivedData(withRootObject: notes)
        let defaults = UserDefaults.standard
        defaults.set(savedData, forKey: "notes")
        navigationController?.popToRootViewController(animated: true)
    }
    
    func newNote() {
        if let note = note {
            note.text = textView.text
        } else {
            note = Note(text: textView.text)
            notes.append(note!)
        }
        save()
    }
    
    func removeNote() {
        if let noteIndex = noteIndex {
            notes.remove(at: noteIndex)
            save()
        }
    }
    
    func share() {
        if let text = textView.text {
            let vc = UIActivityViewController(activityItems: [text], applicationActivities: [])
            vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItems?[2]
            present(vc, animated: true)
        }
    }
    
    func adjustForKeyboard(notification: Notification) {
        let userInfo = notification.userInfo!
        
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == Notification.Name.UIKeyboardWillHide {
            textView.contentInset = UIEdgeInsets.zero
        } else {
            let navigationBarHeight = CGFloat(60.0)
            textView.contentInset = UIEdgeInsets(top: navigationBarHeight, left: 0,
                                                 bottom: keyboardViewEndFrame.height, right: 0)
        }
        
        textView.scrollIndicatorInsets = textView.contentInset
        
        let selectedRange = textView.selectedRange
        textView.scrollRangeToVisible(selectedRange)
    }

}
