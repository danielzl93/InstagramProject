//
//  HomeViewController.swift
//  Instagram
//
//  Created by 翔子Shaun on 2018/9/21.
//  Copyright © 2018 翔子Shaun. All rights reserved.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func logout_TouchUpInside(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        dismiss(animated: true, completion: nil)
    }
    


}
