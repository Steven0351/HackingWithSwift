//
//  ViewController.swift
//  UserDefaultsTest
//
//  Created by Steven Sherry on 6/29/17.
//  Copyright © 2017 Steven Sherry. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let array = defaults.object(forKey: "SavedArray") as? [String] ?? [String]()
        print(array)
        let dict = defaults.object(forKey: "SavedDict") as? [String: String] ?? [String: String]()
        print(dict)
    }


}

