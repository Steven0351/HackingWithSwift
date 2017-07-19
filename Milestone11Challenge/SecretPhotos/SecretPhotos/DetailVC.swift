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
    var selectedImage = ""
    weak var vc: ViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if selectedImage.contains("puppy") {
            imageView.image = UIImage(named: selectedImage)
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self,
                                                                action: #selector(deletePhoto))
            let path = getDocumentsDirectory().appendingPathComponent(selectedImage)
            imageView.image = UIImage(contentsOfFile: path.path)
        }
        
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func deletePhoto() {
        let fileManager = FileManager.default
        do {
            try fileManager.removeItem(atPath: getDocumentsDirectory().appendingPathComponent(selectedImage).path)
            navigationController?.popToRootViewController(animated: true)
        } catch {
            let ac = UIAlertController(title: "Error", message: "Your image was not deleted", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }

}
