//
//  CameraViewController.swift
//  Instagram
//
//  Created by 翔子Shaun on 2018/9/21.
//  Copyright © 2018 翔子Shaun. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth

class CameraViewController: UIViewController {

    
    @IBOutlet weak var photo: UIImageView!
    
    @IBOutlet weak var shareButton: UIButton!
    
    
    @IBOutlet weak var commentTextView: UITextView!
    
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CameraViewController.handleSelectorProfileImageView))
        photo.addGestureRecognizer(tapGesture)
        photo.isUserInteractionEnabled = true
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handlePost()
    }
    
    
    func handlePost() {
        if selectedImage != nil {
            self.shareButton.isEnabled = true
            self.shareButton.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        } else {
            self.shareButton.isEnabled = false
            self.shareButton.backgroundColor = .lightGray
        }
    }
    
    @objc func handleSelectorProfileImageView() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    

    @IBAction func shareButton_TouchUpInside(_ sender: Any) {
        if let photoImg = self.selectedImage, let imagedata = photoImg.jpegData(compressionQuality: 0.1) {
            let photoID = NSUUID().uuidString
            let storageRef = Storage.storage().reference(forURL: "gs://instagramclone-170fd.appspot.com").child("posts").child(photoID)
            
            storageRef.putData(imagedata, metadata: nil, completion: { (metadata, error ) in
                if error != nil {
                    return
                }
                storageRef.downloadURL(completion: { (url, error) in
                    if error != nil {
                        return
                    } else {
                        let photoUrl = url?.absoluteString
                        
                        guard let uid = Auth.auth().currentUser?.uid else { return }
                        
                        let userPostRef = Database.database().reference().child("posts").child(uid)
                        
                        let ref = userPostRef.childByAutoId()
                        let values = ["photoURL": photoUrl, "comment": self.commentTextView.text!]
                        ref.updateChildValues(values as [AnyHashable : Any])
                        
                        self.commentTextView.text = ""
                        self.photo.image = UIImage(named: "plus_photo")
                        self.selectedImage = nil
                        self.tabBarController?.selectedIndex = 0
                    }
                })
            })
        }
    }
    
    func sendDataToDatabase() {
        
    }
    
}

extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImage = image
            photo.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}

