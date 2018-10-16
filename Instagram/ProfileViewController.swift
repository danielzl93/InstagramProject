//
//  ProfileViewController.swift
//  Instagram
//
//  Created by 翔子Shaun on 2018/9/21.
//  Copyright © 2018 翔子Shaun. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    
    
    var userId: String?
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var gridView: UIView!
    
    @IBOutlet weak var postsView: UIView!
    
    
    @IBOutlet weak var postsLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImage.layer.cornerRadius = profileImage.frame.width/2
        profileImage.clipsToBounds = true
        
        editButton.layer.borderColor = UIColor.lightGray.cgColor
        editButton.layer.borderWidth = 1
        editButton.layer.cornerRadius = 3
        editButton.addTarget(self, action: #selector(handleProfileButton), for: .touchUpInside)
        
        gridView.layer.borderWidth = 0.5
        gridView.layer.borderColor = UIColor.lightGray.cgColor
        
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: postsView.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        postsView.addSubview(collectionView)
        
        collectionView.register(profilePhotoCell.self, forCellWithReuseIdentifier: "cell_id")
        
        fetchuser(collectionView)
    }
    
    var userList = [String]()
    @objc func handleProfileButton(_ sender: Any) {
        guard let loggedInUserId = Auth.auth().currentUser?.uid else { return }
        guard let userId = userId else { return }
        
        let ref = Database.database().reference().child("following").child(loggedInUserId)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
//            print(snapshot.value ?? "")
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            dictionary.forEach({ (key, value) in
                let userID = value as? String
                self.userList.append(userID ?? "")
            })
            print("1111111111")
            print(self.userList.count)
            
            if self.userList.contains(userId) {
                Database.database().reference().child("following").child(loggedInUserId).child(userId).removeValue(completionBlock: { (err, ref) in
                    if let err = err {
                        print("Failed to unfollow user:", err)
                        return
                    }
                    self.buttonStyle()
                })
            } else {
                print("hahahahah")
                let following_ref = Database.database().reference().child("following").child(loggedInUserId)
                
                let following_values = ["ID": userId]
                following_ref.updateChildValues(following_values) { (err, ref) in
                    if let err = err {
                        print("Failed to follow user:", err)
                        return
                    }
                    
                    self.editButton.setTitle("Unfollow", for: .normal)
                    self.editButton.backgroundColor = .white
                    self.editButton.setTitleColor(.black, for: .normal)
                }
                
                let follower_ref = Database.database().reference().child("follower").child(userId)
                
                let follower_values = ["ID": loggedInUserId]
                follower_ref.updateChildValues(follower_values) { (err, ref) in
                    if let err = err {
                        print("Failed to follow user:", err)
                        return
                    }
                }
            }
        })
    }
    
    fileprivate func fetchuser(_ collectionView: UICollectionView) {
        let uid = userId ?? (Auth.auth().currentUser?.uid ?? "")
        
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
//            print(snapshot.value ?? "")
            
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            
            let username = dictionary["username"] as? String
            self.navigationItem.title = username
            self.userNameLabel.text = username
            
            self.fetchPosts(collectionView, uid: uid)
            self.setUpProfileButton()
            
            guard let profileImageUrl = dictionary["profileImageUrl"] as? String else {return}
            
            guard let url = URL(string: profileImageUrl) else { return }
            
            URLSession.shared.dataTask(with: url) { (data, response, err) in
                //check for the error, then construct the image using data
                if let err = err {
                    print("Failed to fetch profile image:", err)
                    return
                }
                
                guard let data = data else { return }
                
                let image = UIImage(data: data)
                
                //need to get back onto the main UI thread
                DispatchQueue.main.async {
                    self.profileImage.image = image
                }
                
                }.resume()
            
        }) { (err) in
            print("Failed to fetch user:", err)
        }
    }
    
    var posts = [Post]()
    fileprivate func fetchPosts(_ collectionView: UICollectionView, uid: String) {
        
        let ref = Database.database().reference().child("posts").child(uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            //print(snapshot.value)
            
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            
            dictionaries.forEach({ (key, value) in
                guard let dictionary = value as? [String: Any] else { return }
                
                let post = Post(dictionary: dictionary)
                self.posts.append(post)
            })
            
            collectionView.reloadData()
            let numOfPosts = collectionView.numberOfItems(inSection: 0)
            self.setupStats(self.postsLabel, numOfPosts: numOfPosts)
            
        }) { (err) in
            print("Failed to fetch posts:", err)
        }
    }
    
    fileprivate func setupStats(_ postsLabel: UILabel, numOfPosts: Int) {
        let numOfPosts = String(posts.count) + "\n"
        
        let text = NSMutableAttributedString(string: numOfPosts, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        
        text.append(NSAttributedString(string: "posts", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
        
        postsLabel.attributedText = text
        
        postsLabel.textAlignment = .center
        postsLabel.numberOfLines = 0
    }
    
    fileprivate func setUpProfileButton() {
        guard let loggedInUserId = Auth.auth().currentUser?.uid else { return }
        guard let userId = userId else { return }
        
        if loggedInUserId == userId {

        } else {
            self.buttonStyle()

        }
    }
    
    fileprivate func buttonStyle() {
        self.editButton.setTitle("Follow", for: .normal)
        self.editButton.backgroundColor = UIColor.init(red: 0.06, green: 0.61, blue: 0.91, alpha: 1)
        self.editButton.setTitleColor(.white, for: .normal)
        self.editButton.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell_id", for: indexPath) as! profilePhotoCell
        
        cell.post = posts[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2) / 3
        return CGSize(width: width, height: width)
    }
    

}

struct Post {
    let imageUrl: String
    init(dictionary: [String: Any]) {
        self.imageUrl = dictionary["photoURL"] as? String ?? ""
    }
}
