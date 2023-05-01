//
//  GatherRequestsCell.swift
//  Zinging
//
//  Created by Abu Nabe on 29/1/21.
//

import UIKit

class GatherRequestsCell: UITableViewCell
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
        Label.text = "Hobby"
        Label.font = .boldSystemFont(ofSize: 12)
        return Label
    }()
    
    let Acceptbutton: UIButton =
    {
        let button = UIButton()
        button.backgroundColor = .green
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Accept", for: .normal)

        return button
    }()
    let DeclineButton: UIButton =
    {
        let button = UIButton()
        button.backgroundColor = .red
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Decline", for: .normal)

        return button
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        addSubview(NameLabel)
        addSubview(HobbyLabel)
        addSubview(Acceptbutton)
        addSubview(DeclineButton)
        
        profileImageView.anchor(left: leftAnchor, paddingLeft: 2, width: 60, height: 60)
        profileImageView.layer.cornerRadius = 60/2
        
        NameLabel.anchor(left: profileImageView.rightAnchor)
        
        HobbyLabel.anchor(top: NameLabel.bottomAnchor, left: profileImageView.rightAnchor, paddingTop: 10)
        
        DeclineButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        Acceptbutton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        DeclineButton.anchor(right: rightAnchor)
        Acceptbutton.anchor(right: DeclineButton.leftAnchor, paddingRight: 5)
        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
