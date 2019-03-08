//
//  ProfileViewController.swift
//  SoloProjectFireBase
//
//  Created by Olimpia on 2/26/19.
//  Copyright © 2019 Olimpia. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseAuth

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profilePictureButton: UIButton!
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var emailLabel: UILabel!
    
    private var usersession: UserSession!
    private var storageManager: StorageManager!
    private lazy var imagePickerController: UIImagePickerController = {
        let ip = UIImagePickerController()
        ip.allowsEditing = true
        ip.delegate = self
        return ip
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        imagePickerController.delegate = self
        
     usersession = (UIApplication.shared.delegate as! AppDelegate).usersession
        storageManager = (UIApplication.shared.delegate as! AppDelegate).storageManager
        usersession.usersessionSignOutDelegate = self
        storageManager.delegate = self
        
        guard let user = usersession.getCurrentUser() else {
            emailLabel.text = "no logged user"
            return
        }
        emailLabel.text = user.email ?? "no email found for logged user"
        guard let photoURL = user.photoURL else {
            print("no photoURL")
            return
        }
        
        if let image = ImageCache.shared.fetchImageFromCache(urlString: photoURL.absoluteString) {
            profilePictureButton.setImage(image, for: .normal)
        } else {
            ImageCache.shared.fetchImageFromNetwork(urlString: photoURL.absoluteString) { (appError, image) in
                if let appError = appError {
                   self.showAlert(title: "Fetching Image Error", message: appError.errorMessage(), actionTitle: "Ok")
                
                } else if let image = image {
                   self.profilePictureButton.setImage(image, for: .normal)
                }
                
            }
        }
      
    }
    
    @IBAction func signOutButton(_ sender: UIButton) {
        usersession.signOut()
       
    }
    
    @IBAction func pickerFoto(_ sender: UIButton) {
        let alertController = UIAlertController(title: "slflksdf", message: "dfndfnvdfv", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.imagePickerController.sourceType = .camera
            self.showImagePickerController()
        }
        let photoLibrary = UIAlertAction(title: "Photo", style: .default) { (action) in
            self.imagePickerController.sourceType = .photoLibrary
            self.showImagePickerController()
        }
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alertController.addAction(photoLibrary)
            
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self.present(alertController, animated: true, completion: nil)
        }
        
        //present(alertController, animated: true, completion: nil)
        
    }
    
    private func showImagePickerController() {
        present(imagePickerController, animated: true, completion: nil)
    }
    
}


extension ProfileViewController: UserSessionSignOutDelegate {
    func didRecieveSignOutError(_ usersession: UserSession, error: Error) {
        showAlert(title: "Sign Out Error", message: error.localizedDescription, actionTitle: "Ok")
    }
    
    func didSignOutUser(_ usersession: UserSession) {
        presentLoginVC()
    }
 
    func presentLoginVC() {
        if let _ = (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController as? UITabBarController {
          
            let window = (UIApplication.shared.delegate as! AppDelegate).window
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
            window?.rootViewController = loginViewController
        } else {
          
            dismiss(animated: true)
        }

    }
    
}


extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let imageInfo = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            showAlert(title: "Error with Image", message: "Try again", actionTitle: "Ok")
            return
        }
        profilePictureButton.setImage(imageInfo, for: .normal)
        
        guard let imageData = imageInfo.jpegData(compressionQuality: 0.5) else {
            print("failed to create data")
            return
        }
        storageManager.postImage(withData: imageData)
        
        dismiss(animated: true)
    }
}

extension ProfileViewController: StorageManagerDelegate {
    func didFetchImage(_ storageManager: StorageManager, imageURL: URL) {
        usersession.updateUser(displayName: nil, photoURL: imageURL)
    }
    
    
}
