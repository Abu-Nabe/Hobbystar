//
//  FriendlistCell.swift
//  Zinging
//
//  Created by Abu Nabe on 30/1/21.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class FriendlistCell: UITableViewCell
{
    var friendid: String?
    
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
        Label.text = "friends"
        Label.font = .boldSystemFont(ofSize: 12)
        return Label
    }()
    
    let HeartImage: UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(systemName: "heart")
        imageview.tintColor = .black
        return imageview
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        addSubview(NameLabel)
        addSubview(HobbyLabel)
        addSubview(HeartImage)
        
        
        profileImageView.anchor(left: leftAnchor, paddingLeft: 2, width: 60, height: 60)
        profileImageView.layer.cornerRadius = 60/2
        
        NameLabel.anchor(left: profileImageView.rightAnchor)
        
        HobbyLabel.anchor(top: NameLabel.bottomAnchor, left: profileImageView.rightAnchor, paddingTop: 10)
        
        HeartImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        HeartImage.anchor(right: rightAnchor, paddingRight: 5,width: 30, height: 30)
        
        let heartTap = UITapGestureRecognizer(target: self, action: #selector(HeartFriend))
            heartTap.numberOfTapsRequired = 1
            HeartImage.isUserInteractionEnabled = true
            HeartImage.addGestureRecognizer(heartTap)
        
        let hobbyTap = UITapGestureRecognizer(target: self, action: #selector(hobbyFriend))
            hobbyTap.numberOfTapsRequired = 1
            HobbyLabel.isUserInteractionEnabled = true
            HobbyLabel.addGestureRecognizer(hobbyTap)
        
        
        let ref = Database.database().reference()
        let Auth = FirebaseAuth.Auth.auth().currentUser!.uid
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func HeartFriend()
    {
        let ref = Database.database().reference()
        let Auth = FirebaseAuth.Auth.auth().currentUser!.uid
        ref.child("Crush").child(Auth).child(friendid!).observe(.value) { (snapshot) in
            if snapshot.exists()
            {
                self.type =  "Yes"
            }else {
                self.type = "No"
            }
        }
        if type == "No"
        {
        ref.child("Crush").child(Auth).child(friendid!).setValue("Crushing")
        }else {
            ref.child("Crush").child(Auth).child(friendid!).removeValue()
        }
    }
    @objc func hobbyFriend()
    {
        let ref = Database.database().reference()
        let Auth = FirebaseAuth.Auth.auth().currentUser!.uid
        
        ref.child("Message").child(Auth).child(friendid!).observeSingleEvent(of: .value) { [self] (snapshot) in
            let objDict = snapshot.value as? [String: AnyObject]

            let status = objDict?["status"]
            
                if status == nil
                {
                    ref.child("Message").child(Auth).child(friendid!).child("status").setValue("best friend")
                    
                    HobbyLabel.text = "best friends"
                }else if status as! String == "friends"
                {
                    ref.child("Message").child(Auth).child(friendid!).child("status").setValue("best friend")
                    HobbyLabel.text = "best friend"
                    
                }
                else if status as! String == "best friend"
                {
                    ref.child("Message").child(Auth).child(friendid!).child("status").setValue("close friend")
                    HobbyLabel.text = "close friend"
                    
                }else if status as! String == "close friend"
                {
                    ref.child("Message").child(Auth).child(friendid!).child("status").setValue("relationship")
                    
                    HobbyLabel.text = "relationship"
        
                }else if status as! String == "relationship"
                {
                    ref.child("Message").child(Auth).child(friendid!).child("status").setValue("family")
                    HobbyLabel.text = "family"
                }else if status as! String == "family"
                {
                    ref.child("Message").child(Auth).child(friendid!).child("status").setValue("friends")
                    HobbyLabel.text = "friends"
                }
        }
    }
}
