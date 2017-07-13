//
//  ViewController.swift
//  TestUIViewExtension
//
//  Created by Steven Sherry on 7/13/17.
//  Copyright © 2017 Steven Sherry. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var testView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        testView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        testView.backgroundColor = UIColor.green
        view.addSubview(testView)
        testView.bounceOut(duration: 5)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension UIView {
    func bounceOut(duration: TimeInterval) {
        UIView.animate(withDuration: duration) { [unowned self] in
            self.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
        }
    }
}

