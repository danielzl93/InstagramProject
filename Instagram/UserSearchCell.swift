//
//  UserSearchCell.swift
//  Instagram
//
//  Created by 翔子Shaun on 2018/10/11.
//  Copyright © 2018 翔子Shaun. All rights reserved.
//

import UIKit

class UserSearchCell: UICollectionViewCell {
    
    var user: Users? {
        didSet {
//            username.setTitle(user?.username, for: .normal)
            usernameLabel.text = user?.username
        }
    }
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .red
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.backgroundColor = UIColor.lightGray
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(usernameLabel)
usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.topAnchor.constraint(equalTo:topAnchor).isActive = true
        usernameLabel.leftAnchor.constraint(equalTo:leftAnchor).isActive = true
        usernameLabel.rightAnchor.constraint(equalTo:rightAnchor).isActive = true
        usernameLabel.bottomAnchor.constraint(equalTo:bottomAnchor).isActive = true 
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

