//
//  ZingingPostCell.swift
//  Zinging
//
//  Created by Abu Nabe on 23/1/21.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class ZingingPostCell: UITableViewCell
{
    
    var Liked = "No"
    var postID: String!
    var postPublisher: String!
    
    let starView: UIImageView = {
        let profileimage = UIImageView()
        
        profileimage.contentMode = .scaleAspectFill
        profileimage.image = UIImage(systemName: "star")
        profileimage.tintColor = .green
        return profileimage
    }()
    
    let HobbyLabel: UILabel = {
        let Label = UILabel()
        Label.textAlignment = .center
        Label.text = "Hobby"
        Label.textColor = .black
        Label.numberOfLines = 0
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
    
    let profileImageView: UIImageView = {
        let profileimage = UIImageView()
        
        profileimage.contentMode = .scaleAspectFill
        profileimage.clipsToBounds = true
        profileimage.layer.borderWidth = 1
        profileimage.layer.borderColor = UIColor.black.cgColor
        profileimage.image = UIImage(systemName: "person.fill")?.withRenderingMode(.alwaysOriginal)
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
    
    let CurrentPointsLabel: UILabel = {
        let Label = UILabel()
        Label.textAlignment = .center
        Label.text = "0"
        Label.font = .boldSystemFont(ofSize: 14)
        return Label
    }()
    
    let DescriptionLabel: UILabel = {
        let Label = UILabel()
        Label.textAlignment = .center
        Label.text = "Star"
        Label.font = .boldSystemFont(ofSize: 14)
        return Label
    }()
    
    let Comments: UIImageView = {
        let Label = UIImageView()
        Label.image = UIImage(systemName: "ellipsis.bubble.fill")
        Label.tintColor = .green
        return Label
    }()
    
    let personalStarView: UIImageView = {
        let profileimage = UIImageView()
        
        profileimage.contentMode = .scaleAspectFill
        profileimage.image = UIImage(systemName: "star.fill")
        profileimage.tintColor = .gray
        return profileimage
    }()
    
    let BlackLine: UIView = {
        let Label = UIView()
        Label.backgroundColor = .black
        return Label
    }()

    
    let OptionImage: UIImageView = {
        var imageview = UIImageView()
        imageview.image = UIImage(systemName: "ellipsis")
        imageview.tintColor = .black
        
        return imageview
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(starView)
        addSubview(HobbyLabel)
        addSubview(TimeLabel)
        addSubview(PointsLabel)
        addSubview(PictureView)
        addSubview(profileImageView)
        addSubview(NameLabel)
        addSubview(Comments)
        addSubview(CurrentPointsLabel)
        addSubview(DescriptionLabel)
        addSubview(BlackLine)
        addSubview(OptionImage)
        addSubview(personalStarView)
        
        starView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        starView.anchor(width: 30, height: 30)
        
        PointsLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        PointsLabel.anchor(top: starView.bottomAnchor)
                
        TimeLabel.anchor(top: starView.bottomAnchor, right: rightAnchor, paddingRight: 2)
        
        PictureView.anchor(top: PointsLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, height: 350)
        
        profileImageView.anchor(top: PictureView.bottomAnchor, left: leftAnchor, paddingLeft: 2, width: 25, height: 25)
        profileImageView.layer.cornerRadius = 25/2
        
        NameLabel.anchor(top: PictureView.bottomAnchor, left: profileImageView.rightAnchor)
        
        
        personalStarView.anchor(top: NameLabel.bottomAnchor, left: profileImageView.rightAnchor, bottom: CurrentPointsLabel.bottomAnchor)
        
        CurrentPointsLabel.anchor(top: NameLabel.bottomAnchor, left: personalStarView.rightAnchor)
        
        DescriptionLabel.anchor(top: CurrentPointsLabel.bottomAnchor, left: profileImageView.rightAnchor)
        
        HobbyLabel.anchor(top: PictureView.bottomAnchor, right: rightAnchor, paddingRight: 2)
        
        Comments.anchor(top: HobbyLabel.bottomAnchor, right: rightAnchor, paddingLeft: 2)

        
        BlackLine.anchor(bottom: bottomAnchor, width: 10000, height: 1)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(AddLike))
        starView.isUserInteractionEnabled = true
        starView.addGestureRecognizer(tap)
        
        OptionImage.anchor(right: rightAnchor, paddingTop: 5, paddingRight: 5, width: 25, height: 25)
    }
    
    
    
    @objc func AddLike()
    {
        let ref = Database.database().reference()
        let Auth = FirebaseAuth.Auth.auth().currentUser!.uid

        if Liked == "No"
        {
            ref.child("Rates").child(postID).child(Auth).setValue(true)
            ref.child("Users").child("points").child(postID).child(Auth).setValue(true)
        }else {
            ref.child("Rates").child(postID).child(Auth).removeValue()
            ref.child("Users").child("points").child(postID).child(Auth).removeValue()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
