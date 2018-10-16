//
//  DiscoverViewController.swift
//  Instagram
//
//  Created by 翔子Shaun on 2018/9/21.
//  Copyright © 2018 翔子Shaun. All rights reserved.
//


import UIKit
import FirebaseDatabase
import FirebaseAuth

class DiscoverViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var searchResultView: UIView!
    

    let cellId = "cellId"
    
    override func viewDidLoad() {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: searchResultView.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isUserInteractionEnabled = true
        collectionView.allowsSelection = true
        searchResultView.addSubview(collectionView)
        
        collectionView.register(UserSearchCell.self, forCellWithReuseIdentifier: cellId)
        
        super.viewDidLoad()
    
        fetchUsers(collectionView)
   }
    
   
    
    var filteredUsers = [Users]()
    var users = [Users]()
    fileprivate func fetchUsers(_ collectionView: UICollectionView) {
        print("Fetch users...")
        let ref = Database.database().reference().child("users")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            
            dictionaries.forEach({ (key, value) in
                if key == Auth.auth().currentUser?.uid {
                    print("Found myself, omit from list")
                    return
                }
                
                guard let userDictionary = value as? [String: Any] else { return }
                
                let user = Users(uid: key, dictionary: userDictionary)
                self.users.append(user)
            })
            
            self.users.sort(by: { (u1, u2) -> Bool in
                
                return u1.username.compare(u2.username) == .orderedAscending
                
            })
            
            self.filteredUsers = self.users
            collectionView.reloadData()
            
        }) { (err) in
            print("Failed to fetch users for search:", err)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let user = filteredUsers[indexPath.item]
        
        let userProfileController = self.storyboard?.instantiateViewController(withIdentifier: "userProfile") as! ProfileViewController
        
        userProfileController.userId = user.uid
        
        navigationController?.pushViewController(userProfileController, animated:true)

        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredUsers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserSearchCell
        
        cell.user = filteredUsers[indexPath.item]
        
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 66)
    }
}
