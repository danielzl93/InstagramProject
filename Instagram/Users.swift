//
//  User.swift
//  Instagram
//
//  Created by 翔子Shaun on 2018/10/13.
//  Copyright © 2018 翔子Shaun. All rights reserved.
//

import Foundation

struct Users {
    
    let uid: String
    let username: String
    let profileImageUrl: String
    
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"]  as? String ?? ""
    }
}
