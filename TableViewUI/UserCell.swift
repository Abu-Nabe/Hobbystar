//
//  UserCell.swift
//  Zinging
//
//  Created by Abu Nabe on 14/1/21.
//

import UIKit

class UserCell: UITableViewCell {
    
//    var proflepic = UIImageView()
    var Username = UILabel()
//    var UserActivity = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        addSubview(proflepic)
        addSubview(Username)
//        addSubview(UserActivity)
        
        configureUsername()
//        configureImageView()
//        configureUserActivity()
        
//        setImageConstraints()
        setUsernameConstraints()
//        setActivityConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(userinfo: UserData)
    {
        //        proflepic.image = userinfo.image
        Username.text = userinfo.text
        //        UserActivity.text = userinfo.Activity
    }
    
//    func configureImageView()
//    {
//        proflepic.contentMode = .scaleAspectFill
//        proflepic.clipsToBounds = true
//        proflepic.layer.borderWidth = 3
//        proflepic.layer.borderColor = UIColor.black.cgColor
//    }
    
    func configureUsername()
    {
        Username.textAlignment = .center
        Username.text = "Username"
        Username.textColor = .black
        Username.font = .boldSystemFont(ofSize: 14)
    }
    
//    func configureUserActivity()
//    {
//        //        UserActivity.numberOfLines = 0
//        UserActivity.adjustsFontSizeToFitWidth = true
//    }
    
//    func setImageConstraints()
//    {
//        proflepic.anchor(left: leftAnchor, width: 60, height: 60)
//        proflepic.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
//    }
    
    func setUsernameConstraints()
    {
        Username.anchor(left: leftAnchor)
    }
//    func setActivityConstraints()
//    {
//        UserActivity.anchor(top: Username.bottomAnchor, left: proflepic.rightAnchor)
//    }
}

