//
//  ChatCell.swift
//  Zinging
//
//  Created by Abu Nabe on 20/1/21.
//

import UIKit
import Firebase

class CommentPostCell: UITableViewCell
{
    var timestring = String()
    var CheckLiked = "No"
    var commentLabel: UILabel = {
        let Label = UILabel()
        Label.text = ""
        Label.textColor = .black
        Label.numberOfLines = 0
        Label.font = .systemFont(ofSize: 12)
        return Label
    }()
    
    let profileImageView: UIImageView = {
        let profileimage = UIImageView()
        
        profileimage.contentMode = .scaleAspectFill
        profileimage.clipsToBounds = true
        profileimage.layer.borderWidth = 1
        profileimage.layer.borderColor = UIColor.black.cgColor
        profileimage.image = UIImage(systemName: "person.fill")?.withRenderingMode(.alwaysOriginal)
        
        return profileimage
    }()
    
    let Namelabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Username"
        label.font = .boldSystemFont(ofSize: 10)
    
        
        return label
    }()
    
    let heartImage: UIImageView =
    {
        let background = UIImageView()
        background.image = UIImage(systemName: "heart")
        background.tintColor = .systemGreen
        
        return background
    }()
    
    let likeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "0 yesss"
        label.font = .boldSystemFont(ofSize: 10)
        
        return label
    }()
    
    let timeAgo: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Date"
        label.font = .boldSystemFont(ofSize: 10)
        
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(commentLabel)
        addSubview(heartImage)
        addSubview(profileImageView)
        addSubview(Namelabel)
        addSubview(likeLabel)
        addSubview(timeAgo)
        
        profileImageView.anchor(top: topAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 2, width: 40, height: 40)
        profileImageView.layer.cornerRadius = 40/2
        
        Namelabel.anchor(top: profileImageView.topAnchor, left: profileImageView.rightAnchor)
        
        commentLabel.translatesAutoresizingMaskIntoConstraints = false
        
        heartImage.anchor(top: profileImageView.topAnchor, right: likeLabel.leftAnchor, width: 20, height: 20)
        likeLabel.anchor(top: profileImageView.topAnchor,right: rightAnchor)
        
        timeAgo.anchor(top: commentLabel.bottomAnchor, right: rightAnchor)
        
        let Constraints = [commentLabel.topAnchor.constraint(equalTo: Namelabel.bottomAnchor, constant: 4), commentLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 4), commentLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4), commentLabel.widthAnchor.constraint(lessThanOrEqualToConstant: width)]
    
        NSLayoutConstraint.activate(Constraints)
        
        let likeTap = UITapGestureRecognizer(target: self, action: #selector(LikeComment(sender:)))
        likeTap.numberOfTapsRequired = 1
        heartImage.isUserInteractionEnabled = true
        heartImage.addGestureRecognizer(likeTap)
        
    }
    
    @objc func LikeComment(sender: UITapGestureRecognizer)
    {
        let ref = Database.database().reference()
        let Auth = FirebaseAuth.Auth.auth().currentUser!.uid
        
            ref.child("CommentLikes").child(timestring).child(Auth).observe(.value) { (snapshot) in
                if snapshot.exists()
                {
                    ref.child("CommentLikes").child(self.timestring).child(Auth).removeValue()
                    self.heartImage.image = UIImage(systemName: "heart")
                }else {
                    ref.child("CommentLikes").child(self.timestring).child(Auth).setValue(true)
                    self.heartImage.image = UIImage(systemName: "heart.fill")
                }
            }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
