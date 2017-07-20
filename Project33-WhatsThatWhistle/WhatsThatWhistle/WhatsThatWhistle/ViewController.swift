//
//  ViewController.swift
//  WhatsThatWhistle
//
//  Created by Steven Sherry on 7/20/17.
//  Copyright © 2017 Steven Sherry. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    static var isDirty = true

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "What's that Whistle?"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self,
                                                            action: #selector(addWhistle))
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Home", style: .plain, target: nil, action: nil)
    }


    func addWhistle() {
        let vc  = RecordWhistleViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

}

