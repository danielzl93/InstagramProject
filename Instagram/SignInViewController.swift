//
//  SignInViewController.swift
//  Instagram
//
//  Created by 翔子Shaun on 2018/9/20.
//  Copyright © 2018 翔子Shaun. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignInViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signinButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        passwordTextField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        
        handleTextField()
        
    

        // Do any additional setup after loading the view.
    }
    
    func handleTextField() {
        emailTextField.addTarget(self, action: #selector(SignUpViewController.textFieldDidChange), for: UIControl.Event.editingChanged)
        passwordTextField.addTarget(self, action: #selector(SignUpViewController.textFieldDidChange), for: UIControl.Event.editingChanged)
    }
    
    @objc func textFieldDidChange() {
        guard let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty else {
            signinButton.setTitleColor(UIColor.lightText, for: .normal)
            signinButton.isEnabled = false
            return
        }
        

        signinButton.setTitleColor(.white, for: .normal)
        signinButton.isEnabled = true
    }
    

    @IBAction func signinButton_TouchUpInside(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if error != nil {
                return
            }
            self.performSegue(withIdentifier: "signInToTabbar", sender: nil)
        }
    }
    

}
