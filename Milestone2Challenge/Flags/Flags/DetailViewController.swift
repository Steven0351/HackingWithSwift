//
//  DetailViewController.swift
//  Flags
//
//  Created by Steven Sherry on 6/24/17.
//  Copyright © 2017 Steven Sherry. All rights reserved.
//

import Social
import UIKit

class DetailViewController: UIViewController {
    var flag = ""
    @IBOutlet weak var flagView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = flag.replacingOccurrences(of: ".png", with: "").uppercased()
        flagView.layer.borderWidth = 1
        flagView.layer.borderColor = UIColor.lightGray.cgColor
        flagView.image = UIImage(named: flag)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share))
    }
    
    func share(){
        if let vc = SLComposeViewController(forServiceType: SLServiceTypeFacebook) {
            vc.add(flagView.image!)
            vc.setInitialText("Check out the flag from \(flag.replacingOccurrences(of: ".png", with: "").capitalized)")
            present(vc, animated: true)
        }
    }

}
