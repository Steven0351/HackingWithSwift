//
//  DetailVC.swift
//  SecretPhotos
//
//  Created by Steven Sherry on 7/17/17.
//  Copyright © 2017 Steven Sherry. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    weak var viewController: ViewController!
    var selectedImage = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if viewController.publicPhotos.contains(selectedImage) {
//            imageView.image = UIImage(named: selectedImage)
//        } else {
//            let path = viewController.getDocumentsDirectory().appendingPathComponent(selectedImage)
//            imageView.image = UIImage(contentsOfFile: path.path)
//        }
        
    }

}
