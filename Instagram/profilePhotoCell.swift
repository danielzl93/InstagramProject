//
//  profilePhotoCell.swift
//  Instagram
//
//  Created by 翔子Shaun on 2018/10/4.
//  Copyright © 2018 翔子Shaun. All rights reserved.
//

import UIKit

class profilePhotoCell: UICollectionViewCell {
    
    var post: Post? {
        didSet {
            print(post?.imageUrl ?? "")
            
            guard let imageUrl = post?.imageUrl else { return }

            guard let url = URL(string: imageUrl) else { return }

            URLSession.shared.dataTask(with: url) { (data, response, err) in
                if let err = err {
                    print("Failed to fetch post image:", err)
                    return
                }

                guard let imageData = data else { return }

                let photoImage = UIImage(data: imageData)

                DispatchQueue.main.async {
                    self.photoImageView.image = photoImage
                }

                }.resume()
            
        }
    }
    
    let photoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(photoImageView)
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        photoImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        photoImageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        photoImageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        photoImageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
