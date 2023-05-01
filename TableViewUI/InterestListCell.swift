//
//  AddFriendsCell.swift
//  Zinging
//
//  Created by Abu Nabe on 27/1/21.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class InterestListCell: UITableViewCell
{
    var interestID: String?
    var removeData: String?
    var type = "Yes"
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
        LoginButton.setTitle("Interested", for: .normal)
        
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
        
//        let buttonTap = UITapGestureRecognizer(target: self, action: #selector(Uninterest))
//            buttonTap.numberOfTapsRequired = 1
//            Button.isUserInteractionEnabled = true
//            Button.addGestureRecognizer(buttonTap)
//        let ref = Database.database().reference()
//        let Auth = FirebaseAuth.Auth.auth().currentUser!.uid
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
    
    @objc func Uninterest()
    {
        let ref = Database.database().reference()
        let Auth = FirebaseAuth.Auth.auth().currentUser!.uid
        
        ref.child("Interest").child(Auth).child(interestID!).observe(.value) { (snapshot) in
            if snapshot.exists()
            {
                self.type = "Yes"
            }else {
                self.type = "No"
            }
        }
        
        if type == "Yes"
        {
            ref.child("Interest").child(Auth).child(self.interestID!).removeValue()
            self.Button.setTitle("Interest", for: .normal)
        }else {
            ref.child("Interest").child(Auth).child(self.interestID!).setValue(true)
            self.Button.setTitle("Interested", for: .normal)
            
        }
    }
    
}
