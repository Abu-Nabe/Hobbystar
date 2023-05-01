//
//  PostNotifications.swift
//  Zinging
//
//  Created by Abu Nabe on 19/3/21.
//

import UIKit

class PostNotifications: UICollectionViewCell
{
    let profileImageView: UIImageView = {
        let profileimage = UIImageView()
        
        profileimage.contentMode = .scaleAspectFill
        profileimage.clipsToBounds = true
        profileimage.layer.borderWidth = 1
        profileimage.image = UIImage(systemName: "person.fill")?.withRenderingMode(.alwaysOriginal)
        profileimage.layer.borderColor = UIColor.black.cgColor
        return profileimage
    }()
    
    
    var NameLabel: UILabel = {
        let Label = UILabel()
        Label.textAlignment = .center
        Label.text = "Username"
        Label.textColor = .black
        Label.font = .boldSystemFont(ofSize: 16)
        return Label
    }()

    var TimeAgoLabel: UILabel = {
        let Label = UILabel()
        Label.textAlignment = .center
        Label.text = "Online"
        Label.font = .boldSystemFont(ofSize: 10)
        return Label
    }()
    
    var DescriptionLabel: UILabel = {
        let Label = UILabel()
        Label.textAlignment = .right
        Label.text = "recent post!"
        Label.font = .boldSystemFont(ofSize: 10)
        
        return Label
    }()
    
    
    let postView: UIImageView = {
        let profileimage = UIImageView()
        
        profileimage.contentMode = .scaleAspectFill
        profileimage.clipsToBounds = true
        
        return profileimage
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(profileImageView)
        addSubview(NameLabel)
        addSubview(TimeAgoLabel)
        addSubview(DescriptionLabel)
        addSubview(postView)
        
        
        
        postView.anchor(top: NameLabel.bottomAnchor, paddingLeft: 2, width: 150, height: 150)
        
        profileImageView.centerXAnchor.constraint(equalTo: postView.centerXAnchor).isActive = true
        profileImageView.anchor(top: topAnchor, left: postView.rightAnchor, paddingLeft: 5, width: 60, height: 60)
        profileImageView.layer.cornerRadius = 60/2
        
        NameLabel.centerXAnchor.constraint(equalTo: postView.centerXAnchor).isActive = true
        NameLabel.anchor(top: profileImageView.bottomAnchor)
        
        
        DescriptionLabel.anchor(top: postView.bottomAnchor,left: leftAnchor, paddingLeft: 2)
        
        TimeAgoLabel.anchor(top: postView.bottomAnchor, right: rightAnchor, paddingRight: 2)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
