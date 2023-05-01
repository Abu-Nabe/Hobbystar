//
//  SearchCell.swift
//  Zinging
//
//  Created by Abu Nabe on 15/1/21.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class MessageCell: UITableViewCell{
    
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

    var OnlineLabel: UILabel = {
        let Label = UILabel()
        Label.textAlignment = .center
        Label.text = "Online"
        Label.font = .boldSystemFont(ofSize: 12)
        return Label
    }()
    
    var TextLabel: UILabel = {
        let Label = UILabel()
        Label.textAlignment = .right
        Label.text = "Text"
        Label.font = .boldSystemFont(ofSize: 12)
        
        return Label
    }()
    
    var UnreadLabel: UILabel = {
        let Label = UILabel()
        Label.textAlignment = .center
        Label.text = ""
        Label.font = .boldSystemFont(ofSize: 12)
        return Label
    }()
    
    
    var TextAgoLabel: UILabel = {
        let Label = UILabel()
        Label.textAlignment = .center
        Label.text = "Mins"
        Label.font = .boldSystemFont(ofSize: 12)
        return Label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        addSubview(NameLabel)
        addSubview(OnlineLabel)
        addSubview(TextLabel)
        addSubview(TextAgoLabel)
        addSubview(UnreadLabel)
                
        profileImageView.anchor(left: leftAnchor, paddingLeft: 2, width: 60, height: 60)
        profileImageView.layer.cornerRadius = 60/2
        
        NameLabel.anchor(left: profileImageView.rightAnchor)
        
        OnlineLabel.anchor(left: profileImageView.rightAnchor, bottom: bottomAnchor)
        
        TextLabel.anchor(top: topAnchor, right: rightAnchor, paddingRight: 5, width: 50)
        
        TextAgoLabel.anchor(bottom: bottomAnchor, right: rightAnchor)
        
        UnreadLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        UnreadLabel.anchor(right: rightAnchor, paddingRight: 5)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
