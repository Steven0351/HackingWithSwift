//
//  ViewController.swift
//  SecretPhotos
//
//  Created by Steven Sherry on 7/17/17.
//  Copyright © 2017 Steven Sherry. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var publicPhotos = [String]()
    var secretPhotos = [String]()
    
    var isAuthenticated = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Puppies"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self,
                                                            action: #selector(choosePicture))
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(hide),
                                       name: Notification.Name.UIApplicationWillResignActive, object: nil)
//        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
        collectionView?.reloadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isAuthenticated {
            print("This worked")
            return secretPhotos.count
        } else {
            return publicPhotos.count
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Photo", for: indexPath) as! PhotoCell
        if isAuthenticated {
            let path = getDocumentsDirectory().appendingPathComponent(secretPhotos[indexPath.row])
            cell.imageView.image = UIImage(contentsOfFile: path.path)
        } else {
            cell.imageView.image = UIImage(named: publicPhotos[indexPath.row])
        }
        return cell
    }
    
   override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailVC {
            if isAuthenticated {
                vc.selectedImage = secretPhotos[indexPath.row]
            } else {
                vc.selectedImage = publicPhotos[indexPath.row]
            }
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func choosePicture() {
        let ac = UIAlertController(title: "Import", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "from Photo Library", style: .default) { [unowned self] _ in
            let picker = UIImagePickerController()
            picker.allowsEditing = true
            picker.delegate = self
            self.present(picker, animated: true)
        })
        ac.addAction(UIAlertAction(title: "from Camera", style: .default) { [unowned self] _ in
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.allowsEditing = true
            picker.delegate = self
            self.present(picker, animated: true)
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerEditedImage] as? UIImage else { return }
        let imageName = "\(UUID().uuidString).jpg"
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        print(imagePath)
        
        if let jpegData = UIImageJPEGRepresentation(image, 80) {
            do {
                try jpegData.write(to: imagePath)
                secretPhotos.append(imageName)
                print(imageName)
                collectionView?.reloadData()
                dismiss(animated: true)
            } catch {
                print("failure")
                let ac = UIAlertController(title: "Image Was Not Saved", message: "Try again", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                present(ac, animated: true)
            }
        }
    }
    
    
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Unlock the vault"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [unowned self] (success, authenticationError) in
                
                DispatchQueue.main.async {
                    if success {
                        self.isAuthenticated = true
                        self.collectionView?.reloadData()
                        self.navigationItem.rightBarButtonItem?.isEnabled = true
                        self.title = "Vault"
                    }
                }
            }
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func loadData() {
        let fileManager = FileManager.default
        let puppyPath = Bundle.main.resourcePath!
        if let puppies = try? fileManager.contentsOfDirectory(atPath: puppyPath) {
            if !publicPhotos.isEmpty {
                publicPhotos.removeAll()
            }
            for puppy in puppies {
                print(puppy)
                if puppy.contains("puppy") {
                    publicPhotos.append(puppy)
                }
            }
            
        }
        let secretPath = getDocumentsDirectory().path
        if let secrets = try? fileManager.contentsOfDirectory(atPath: secretPath) {
            if !secretPhotos.isEmpty {
                secretPhotos.removeAll()
            }
            for secret in secrets {
                secretPhotos.append(secret)
            }
            
        } else {
            print("Failed")
        }

    }
    
    func hide() {
        isAuthenticated = false
        navigationItem.rightBarButtonItem?.isEnabled = false
        collectionView?.reloadData()
        title = "Puppies"
    }

    override func becomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            authenticate()
        }
    }
}






