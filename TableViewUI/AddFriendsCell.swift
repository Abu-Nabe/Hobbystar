//
//  AddFriendsCell.swift
//  Zinging
//
//  Created by Abu Nabe on 27/1/21.
//

import UIKit

class AddFriendsCell: UITableViewCell
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
    
    var HobbyLabel: UILabel = {
        let Label = UILabel()
        Label.textAlignment = .center
        Label.text = "0"
        Label.font = .boldSystemFont(ofSize: 12)
        return Label
    }()
    
    var Button: UIButton = {
        let LoginButton = UIButton()
        LoginButton.backgroundColor = .gray
        LoginButton.setTitleColor(.green, for: .normal)
        LoginButton.setTitle("Request", for: .normal)
        
        return LoginButton
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        addSubview(NameLabel)
        addSubview(HobbyLabel)
        addSubview(Button)
        
        
        profileImageView.anchor(left: leftAnchor, paddingLeft: 2, width: 60, height: 60)
        profileImageView.layer.cornerRadius = 60/2
        
        NameLabel.anchor(left: profileImageView.rightAnchor)
        
        HobbyLabel.anchor(top: NameLabel.bottomAnchor, left: profileImageView.rightAnchor, paddingTop: 10)
        
        Button.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        Button.anchor(right: rightAnchor,paddingRight: 3,height: 30)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
