//
//  AddFriendsCell.swift
//  Zinging
//
//  Created by Abu Nabe on 27/1/21.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class GatherItemCell: UITableViewCell
{
    let profileImageView: UIImageView = {
        let profileimage = UIImageView()
        
        profileimage.contentMode = .scaleAspectFill
        profileimage.clipsToBounds = true
        profileimage.layer.borderWidth = 3
        
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
    
    var removeButton: UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(systemName: "xmark.circle")
        
        return imageview
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        addSubview(NameLabel)
        addSubview(HobbyLabel)
        addSubview(removeButton)
        
        
        profileImageView.anchor(left: leftAnchor, paddingLeft: 2, width: 60, height: 60)
        profileImageView.layer.cornerRadius = 60/2
        
        NameLabel.anchor(left: profileImageView.rightAnchor)
        
        HobbyLabel.anchor(top: NameLabel.bottomAnchor, left: profileImageView.rightAnchor, paddingTop: 10)
        
        removeButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        removeButton.anchor(right: rightAnchor,paddingRight: 3)
        
//        let buttonTap = UITapGestureRecognizer(target: self, action: #selector(Uninterest))
//            buttonTap.numberOfTapsRequired = 1
//            Button.isUserInteractionEnabled = true
//            Button.addGestureRecognizer(buttonTap)
//        ref.child("Interest").child(Auth).child(interestID!).observe(.value) { (snapshot) in
//            if snapshot.exists()
//            {
//                self.Button.setTitle("Interested", for: .normal)
//            }else {
//                self.Button.setTitle("Interest", for: .normal)
//            }
//        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
