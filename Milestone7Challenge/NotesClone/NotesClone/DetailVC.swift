//
//  DetailVC.swift
//  NotesClone
//
//  Created by Steven Sherry on 7/7/17.
//  Copyright © 2017 Steven Sherry. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
        navigationItem.rightBarButtonItems = [cancelButton, saveButton]
    }

    func save() {
        let vc = ViewController()
        let savedData = NSKeyedArchiver.archivedData(withRootObject: vc.notes)
        let defaults = UserDefaults.standard
        defaults.set(savedData, forKey: "notes")
    }
    
    func cancel() {
        dismiss(animated: true, completion: nil)
    }

}
