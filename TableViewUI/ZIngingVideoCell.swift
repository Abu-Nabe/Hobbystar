//
//  ZingingVideoCell.swift
//  Zinging
//
//  Created by Abu Nabe on 23/1/21.
//

import UIKit
import AVKit
import AVFoundation
import FirebaseAuth
import FirebaseDatabase

class ZingingVideoCell: UITableViewCell
{
    var Liked = "No"
    var playing = "yes"
    var sound = "Yes"
    var vidID: String!
    var player = AVPlayer()
    var postPublisher: String!
    public var videoID: String!
    
    
    
    let VideoView: UIImageView = {
        let pic = UIImageView()
        pic.contentMode = .scaleAspectFit

        return pic
    }()
    
    let starView: UIImageView = {
        let profileimage = UIImageView()
        
        profileimage.contentMode = .scaleAspectFill
        profileimage.image = UIImage(systemName: "star")
        profileimage.tintColor = .green
        return profileimage
    }()
    
    let personalStarView: UIImageView = {
        let profileimage = UIImageView()
        
        profileimage.contentMode = .scaleAspectFill
        profileimage.image = UIImage(systemName: "star.fill")
        profileimage.tintColor = .gray
        return profileimage
    }()
    
    let HobbyLabel: UILabel = {
        let Label = UILabel()
        Label.textAlignment = .center
        Label.text = "Hobby"
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
        Label.numberOfLines = 0
        Label.font = .boldSystemFont(ofSize: 14)
        return Label
    }()
    
    let Comments: UIImageView = {
        let Label = UIImageView()
        Label.image = UIImage(systemName: "ellipsis.bubble.fill")
        Label.tintColor = .green
        return Label
    }()
    
    let videoFrame: UIView = {
        let frame = UIView()
        frame.backgroundColor = .black
        
        return frame
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
    
    let SoundButton: UIImageView = {
        var imageview = UIImageView()
        imageview.image = UIImage(systemName: "record.circle")
        imageview.tintColor = .black
        
        return imageview
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(starView)
        addSubview(HobbyLabel)
        addSubview(TimeLabel)
        addSubview(PointsLabel)
        addSubview(profileImageView)
        addSubview(NameLabel)
        addSubview(Comments)
        addSubview(CurrentPointsLabel)
        addSubview(DescriptionLabel)
        addSubview(videoFrame)
        addSubview(BlackLine)
        addSubview(VideoView)
        addSubview(OptionImage)
        addSubview(personalStarView)
        addSubview(SoundButton)
        
        
//        let playerLayer = AVPlayerLayer(player: player)
//        playerLayer.frame = videoFrame.bounds

//        videoFrame.layer.addSublayer(playerLayer)

        
        starView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        starView.anchor(width: 30, height: 30)
        
        PointsLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        PointsLabel.anchor(top: starView.bottomAnchor)
        
        TimeLabel.anchor(top: starView.bottomAnchor, right: rightAnchor, paddingRight: 2)
        
        videoFrame.anchor(top: PointsLabel.bottomAnchor, left: leftAnchor, right: rightAnchor,  height: 350)
        
        VideoView.anchor(top: PointsLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, height: 350)
        
        profileImageView.anchor(top: videoFrame.bottomAnchor, left: leftAnchor, paddingLeft: 2, width: 25, height: 25)
        profileImageView.layer.cornerRadius = 25/2
        
        NameLabel.anchor(top: videoFrame.bottomAnchor, left: profileImageView.rightAnchor)
        
        personalStarView.anchor(top: NameLabel.bottomAnchor, left: profileImageView.rightAnchor, bottom: CurrentPointsLabel.bottomAnchor)
        
        CurrentPointsLabel.anchor(top: NameLabel.bottomAnchor, left: personalStarView.rightAnchor)
        
        DescriptionLabel.anchor(top: CurrentPointsLabel.bottomAnchor, left: profileImageView.rightAnchor)
        
        HobbyLabel.anchor(top: VideoView.bottomAnchor, right: rightAnchor, paddingRight: 2)
        
        Comments.anchor(top: HobbyLabel.bottomAnchor, right: rightAnchor, paddingRight: 2)
        
        OptionImage.anchor(right: rightAnchor, paddingTop: 5, paddingRight: 5, width: 25, height: 25)
        
        SoundButton.anchor(bottom: VideoView.topAnchor, paddingLeft: 2, width: 25, height: 25)
        
        BlackLine.anchor(bottom: bottomAnchor, width: 10000, height: 1)
    
        let tap = UITapGestureRecognizer(target: self, action: #selector(AddLike))
        tap.numberOfTapsRequired = 1
        starView.isUserInteractionEnabled = true
        starView.addGestureRecognizer(tap)
        
        let videoTap = UITapGestureRecognizer(target: self, action: #selector(PlayVideo))
        videoTap.numberOfTapsRequired = 1
        videoFrame.isUserInteractionEnabled = true
        videoFrame.addGestureRecognizer(videoTap)
        
        let soundTap = UITapGestureRecognizer(target: self, action: #selector(Sound))
        soundTap.numberOfTapsRequired = 1
        SoundButton.isUserInteractionEnabled = true
        SoundButton.addGestureRecognizer(soundTap)
        
        
        NotificationCenter.default.addObserver(self, selector:#selector(self.playerDidFinishPlaying(note:)),name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)

    }
    
    @objc func playerDidFinishPlaying(note: NSNotification){
    
        player.seek(to: CMTime.zero)
    }
    
    @objc func AddLike()
    {
        let ref = Database.database().reference()
        let Auth = FirebaseAuth.Auth.auth().currentUser!.uid

        if Liked == "No"
        {
            ref.child("Rates").child(vidID).child(Auth).setValue(true)
            ref.child("Users").child("points").child(vidID).child(Auth).setValue(true)
        }else {
            ref.child("Rates").child(vidID).child(Auth).removeValue()
            ref.child("Users").child("points").child(vidID).child(Auth).removeValue()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func PlayVideo()
    {
        if playing == "yes"
        {
            player.play()
            playing = "no"
            VideoView.isHidden = true
        }else {
            player.pause()
            playing = "yes"
        }
    }
    @objc func Sound()
    {
        if sound == "Yes"
        {
            player.isMuted = true
            sound = "No"
        }else {
            player.isMuted = false
            sound = "Yes"
        }
       
    }
}
