//
//  HomePostCell.swift
//  Zinging
//
//  Created by Abu Nabe on 21/1/21.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth


class HomePostCell: UITableViewCell
{
    
    var postID: String!
    var Liked = "No"
    var Disliked = "No"
    var postPublisher: String!
    
    let posttext =  UITextView()
    
    var profileImageView: UIImageView = {
        let profileimage = UIImageView()
        
        profileimage.contentMode = .scaleToFill
        profileimage.clipsToBounds = true
        profileimage.layer.borderWidth = 1
        profileimage.image = UIImage(systemName: "person.fill")?.withRenderingMode(.alwaysOriginal)
        profileimage.layer.borderColor = UIColor.black.cgColor
        return profileimage
    }()
    
    let NameLabel: UILabel = {
        let Label = UILabel()
        Label.textAlignment = .center
        Label.text = "Username"
        Label.textColor = .black
        Label.font = .boldSystemFont(ofSize: 12)
        return Label
    }()
    
    let TimeLabel: UILabel = {
        let Label = UILabel()
        Label.textAlignment = .center
        Label.text = "TimeAgo"
        Label.font = .boldSystemFont(ofSize: 14)
        return Label
    }()
    
    let PointsLabel: UILabel = {
        let Label = UILabel()
        Label.textAlignment = .center
        Label.text = "0"
        Label.font = .boldSystemFont(ofSize: 14)
        
        return Label
    }()
    
    let PictureView: UIImageView = {
        let profileimage = UIImageView()
        
        profileimage.contentMode = .scaleAspectFill
        profileimage.clipsToBounds = true
        
        return profileimage
    }()
    
    let Likeslabel: UILabel = {
        let Label = UILabel()
        Label.textAlignment = .center
        Label.text = "Likes"
        Label.font = .boldSystemFont(ofSize: 14)
        return Label
    }()
    
    let Dislikelabel: UILabel = {
        let Label = UILabel()
        Label.textAlignment = .center
        Label.text = "Dislike"
        Label.font = .boldSystemFont(ofSize: 14)
        return Label
    }()
    
    
    let LikeImage: UIImageView = {
        var imageview = UIImageView()
        imageview.image = UIImage(systemName: "face.smiling")
        
        return imageview
    }()
    
    let DislikeImage: UIImageView = {
        var imageview = UIImageView()
        imageview.image = UIImage(named: "Unhappy")
        
        return imageview
    }()
    
    let OptionImage: UIImageView = {
        var imageview = UIImageView()
        imageview.image = UIImage(systemName: "ellipsis")
        imageview.tintColor = .black
        
        return imageview
    }()
    
    let StarImage: UIImageView = {
        var imageview = UIImageView()
        imageview.image = UIImage(systemName: "star.fill")
        imageview.tintColor = .gray
        
        return imageview
    }()
    
    
    let LinkButton: UIImageView = {
        var imageview = UIImageView()
        imageview.image = UIImage(systemName: "square")
        imageview.tintColor = .black
        return imageview
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        addSubview(NameLabel)
        addSubview(TimeLabel)
        addSubview(PointsLabel)
        addSubview(Likeslabel)
        addSubview(Dislikelabel)
        addSubview(PictureView)
        addSubview(LinkButton)
        addSubview(LikeImage)
        addSubview(DislikeImage)
        addSubview(OptionImage)
        addSubview(StarImage)
        profileImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        profileImageView.anchor(top: topAnchor, width: 30, height: 30)
        profileImageView.layer.cornerRadius = 30/2
        
        NameLabel.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor).isActive = true
        NameLabel.anchor(top: profileImageView.bottomAnchor)
        
        TimeLabel.anchor(top: profileImageView.bottomAnchor, right: rightAnchor, paddingRight: 5)
        
        PointsLabel.centerYAnchor.constraint(equalTo: StarImage.centerYAnchor).isActive = true
        PointsLabel.anchor(top: profileImageView.bottomAnchor, left: StarImage.rightAnchor, paddingLeft: 2)
        
        StarImage.anchor(left: leftAnchor, bottom: PictureView.topAnchor, paddingLeft: 5, width: 20, height: 20)
        
        PictureView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        PictureView.anchor(top: NameLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, height: 350)
        
        Likeslabel.anchor(top: PictureView.bottomAnchor, left: leftAnchor)
        Dislikelabel.anchor(top: PictureView.bottomAnchor, right: rightAnchor)
        
        LikeImage.anchor(top: Likeslabel.bottomAnchor, left: leftAnchor,paddingTop:3, width: 25, height: 25)
        DislikeImage.anchor(top: Dislikelabel.bottomAnchor, right: rightAnchor, width: 30, height: 30)
        
        LinkButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        LinkButton.anchor(top: Likeslabel.bottomAnchor, width: 25, height: 25)
        
        OptionImage.anchor(right: rightAnchor, paddingTop: 5, paddingRight: 5, width: 25, height: 25)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(AddLike))
        tap.numberOfTapsRequired = 1
        LikeImage.isUserInteractionEnabled = true
        LikeImage.addGestureRecognizer(tap)
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(AddDislike))
        tap1.numberOfTapsRequired = 1
        DislikeImage.isUserInteractionEnabled = true
        DislikeImage.addGestureRecognizer(tap1)
    }
    
    
    @objc func AddLike()
    {
        let ref = Database.database().reference()
        let Auth = FirebaseAuth.Auth.auth().currentUser!.uid

        if Liked == "No"
        {
        ref.child("Rates").child(postID).child(Auth).setValue(true)
        }else {
            ref.child("Rates").child(postID).child(Auth).removeValue()
        }
    }
    
    @objc func AddDislike()
    {
        
        let ref = Database.database().reference()
        let Auth = FirebaseAuth.Auth.auth().currentUser!.uid
        if Disliked == "No"
        {
        ref.child("Dislikes").child(postID).child(Auth).setValue(true)
        }else {
            ref.child("Dislikes").child(postID).child(Auth).setValue(true)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
