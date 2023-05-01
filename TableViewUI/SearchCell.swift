//
//  SearchCell.swift
//  Zinging
//
//  Created by Abu Nabe on 15/1/21.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class SearchCell: UITableViewCell{
    
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
    
    var HobbyLabel: UILabel = {
        let Label = UILabel()
        Label.textAlignment = .center
        Label.text = "Hobby"
        Label.font = .boldSystemFont(ofSize: 12)
        return Label
    }()
    
    var NotifLabel: UILabel = {
        let Label = UILabel()
        Label.textAlignment = .center
        Label.text = "Date"
        Label.font = .boldSystemFont(ofSize: 10)
        return Label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        addSubview(NameLabel)
        addSubview(HobbyLabel)
        addSubview(NotifLabel)
        
        
        profileImageView.anchor(left: leftAnchor, paddingLeft: 2, width: 60, height: 60)
        profileImageView.layer.cornerRadius = 60/2
        
        NameLabel.anchor(left: profileImageView.rightAnchor)
        
        HobbyLabel.anchor(top: NameLabel.bottomAnchor, left: profileImageView.rightAnchor, paddingTop: 10)
        
        NotifLabel.anchor(left: profileImageView.rightAnchor, bottom: bottomAnchor)
        NotifLabel.isHidden = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
