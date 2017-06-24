//
//  DetailViewController.swift
//  StormViewer
//
//  Created by Steven Sherry on 6/23/17.
//  Copyright © 2017 Steven Sherry. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var selectedImage: String?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.hidesBarsOnTap = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = selectedImage
        if let imageToLoad = selectedImage {
            imageView.image = UIImage(named: imageToLoad)
        }
        
    }

    
}
