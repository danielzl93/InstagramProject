//
//  SignUpViewController.swift
//  Instagram
//
//  Created by 翔子Shaun on 2018/9/20.
//  Copyright © 2018 翔子Shaun. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class SignUpViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var signupButton: UIButton!
    
    
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        
        emailTextField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        
        passwordTextField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.handleSelectorProfileImageView))
//        profileImage.layer.cornerRadius = 40
//        profileImage.clipsToBounds = true
        profileImage.addGestureRecognizer(tapGesture)
        profileImage.isUserInteractionEnabled = true
        profileImage.layer.cornerRadius = profileImage.frame.width/2
//        profileImage.layer.masksToBounds = true
        profileImage.clipsToBounds = true
        
        handleTextField()
        
        // Do any additional setup after loading the view.
    }
    
    func handleTextField() {
        usernameTextField.addTarget(self, action: #selector(SignUpViewController.textFieldDidChange), for: UIControl.Event.editingChanged)
        emailTextField.addTarget(self, action: #selector(SignUpViewController.textFieldDidChange), for: UIControl.Event.editingChanged)
        passwordTextField.addTarget(self, action: #selector(SignUpViewController.textFieldDidChange), for: UIControl.Event.editingChanged)
    }
    
    @objc func textFieldDidChange() {
        guard let username = usernameTextField.text, !username.isEmpty, let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty else {

            signupButton.setTitleColor(UIColor.lightText, for: .normal)
            signupButton.isEnabled = false
            return
        }
        

        signupButton.setTitleColor(.white, for: .normal)
        signupButton.isEnabled = true
    }
    
    @objc func handleSelectorProfileImageView() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
        
    }
    
    @IBAction func dismiss_onClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signUpTouchUpInside(_ sender: Any) {
        
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user: AuthDataResult?, error: Error?) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            let uid = user?.user.uid
            let storageRef = Storage.storage().reference(forURL: "gs://instagramclone-170fd.appspot.com").child("profile_image").child(uid!)
            if let profileImg = self.selectedImage, let imagedata = profileImg.jpegData(compressionQuality: 0.1) {
                storageRef.putData(imagedata, metadata: nil, completion: { (metadata, error ) in
                    if error != nil {
                        return
                    }
                    storageRef.downloadURL(completion: { (url, error) in
                        if error != nil {
                            return
                        } else {
                            let profileImageUrl = url?.absoluteString
                            let ref = Database.database().reference()
                            let usersReference = ref.child("users")
                            
                            let newUserReference = usersReference.child(uid!)
                            newUserReference.setValue(["username": self.usernameTextField.text!, "email": self.emailTextField.text!, "profileImageUrl": profileImageUrl])
                            self.performSegue(withIdentifier: "signUpToTabbar", sender: nil)
                        
                        }
                    })
                })
            }
        }
    }
    
}

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImage = image
            profileImage.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}
