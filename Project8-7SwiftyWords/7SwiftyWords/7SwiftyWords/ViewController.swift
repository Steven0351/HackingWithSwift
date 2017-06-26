//
//  ViewController.swift
//  7SwiftyWords
//
//  Created by Steven Sherry on 6/26/17.
//  Copyright © 2017 Steven Sherry. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cluesLabel: UILabel!
    @IBOutlet weak var answersLabel: UILabel!
    @IBOutlet weak var currentAnswer: UITextField!
    @IBOutlet weak var scoreLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func submitTapped(_ sender: Any) {
    }

    @IBAction func clearTapped(_ sender: Any) {
    }
}

