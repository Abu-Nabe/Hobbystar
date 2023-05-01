//
//  AllVideosZinging.swift
//  Zinging
//
//  Created by Abu Nabe on 25/1/21.
//

import UIKit
import FirebaseAuth
import AVKit
import AVFoundation
import FirebaseDatabase

class ZingingVideo: UIViewController
{
    
    var videodata: [AllVideoData] = [AllVideoData]()
    var videoid: String!
    
    let ChooseLabel: UILabel = {
        let label = UILabel()
        label.text = "Category"
        
        return label
    }()
    
    let line: UIView = {
        let line = UIView()
        
        return line
    }()
    
    let tableView: UITableView =
    {
        let tableview = UITableView()
            
        return tableview
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.addSubview(ChooseLabel)
        view.addSubview(line)
        view.addSubview(tableView)
        
        self.edgesForExtendedLayout = []
        
        configureTableView()
        configureData()
        listenDeletes()
        
        self.navigationItem.hidesBackButton = false
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = false
        
        ChooseLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        line.frame = CGRect(x: view.width/2-ChooseLabel.width/2, y: ChooseLabel.frame.origin.y+ChooseLabel.frame.size.height, width: ChooseLabel.width, height: 1)
        
    }
    func configureTableView()
    {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(ZingingVideoCell.self, forCellReuseIdentifier: "Cell")
        tableView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        
        tableView.rowHeight = view.height
        tableView.showsVerticalScrollIndicator = true
    }
    
    func configureData()
    {
        let ref = Database.database().reference()
        
        ref.child("Videos").child(videoid).observe(.value) { (snapshot) in
            
            let viddata = AllVideoData(snapshot: snapshot)
            
            self.videodata.append(viddata)
        
            self.tableView.reloadData()
                
            }
    }
    
    func listenDeletes() {
        
       let ref = Database.database().reference().child("Videos")

        ref.observe(.value) { (snapshot) in
            for posts in snapshot.children.allObjects as![FirebaseDatabase.DataSnapshot] {
                let key = posts.key
                ref.child(key).observe(.childRemoved, with: { [self] postSnapshot in
                    if let index = self.videodata.firstIndex(where: {$0.timestring == key}) {

                        self.videodata.remove(at: index)
                        self.tableView.deleteRows(at: [IndexPath(item: index, section: 0)], with: .none)
                        
                        self.videodata.removeAll()
                 }
               })
            }
        }
        
    }
}

extension ZingingVideo: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videodata.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",for: indexPath) as! ZingingVideoCell
        
        let items = videodata[indexPath.row]
        
        cell.contentView.isUserInteractionEnabled = false
        
        let ref = Database.database().reference()
        let id = items.publisher
    
        ref.child("Users").child(id).observe(.value) { (snapshot) in
            let postObjects = snapshot.value as? [String: AnyObject]
            
            let name = postObjects?["username"] as! String
            cell.NameLabel.text = name
            
            if snapshot.hasChild("profileimage")
            {
                let image = postObjects?["profileimage"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                    
                    if let error = error {
                        print("There was an error fetching the image from the url: \n", error)
                    }
                    
                    if let data = data, let profilePicture = UIImage(data: data) {
                        DispatchQueue.main.async() {
                            cell.profileImageView.image = profilePicture // Set the profile picture
                        }
                    } else {
                        print("Something is wrong with the image data")
                    }
                    
                }).resume()
            }
            ref.child("Users").child(items.publisher).child("points").observe(.value) { (snapshot) in
                if snapshot.exists()
                {
                    let pointcount: Int = Int(snapshot.childrenCount)
                    
                    cell.CurrentPointsLabel.text = String(pointcount)
                }
            }
            if snapshot.hasChild("hobbyname")
            {
                let hobby = postObjects?["hobbyname"] as! String
                cell.HobbyLabel.text = hobby
            }
        }
        
        cell.DescriptionLabel.text = items.description
        
        let vidString = items.videoid
        
        let timestamp = items.timestamp
        
        
        let date = Date(timeIntervalSince1970: timestamp / 1000)
        let timeAgo = timeAgoSince(date)
        
        cell.TimeLabel.text = timeAgo
        
        let videoID = items.videoimage
        let url = URL(string: videoID)
        
        cell.vidID = videoID
        
//        //use loading circulation and then play video
        
        let videoURL = URL(string: videoID)
        cell.player = AVPlayer(url: videoURL!)
        
        DispatchQueue.main.async {
            let playerLayer = AVPlayerLayer(player: cell.player)
            playerLayer.frame = cell.videoFrame.bounds
            cell.videoFrame.layer.addSublayer(playerLayer)

            cell.player.pause()
        }
                
        let Auth = FirebaseAuth.Auth.auth().currentUser!.uid

        ref.child("Rates").child(vidString).child(Auth).observe(.value) { (snapshot) in
            if snapshot.exists()
            {
                cell.Liked = "Yes"
                cell.starView.image = UIImage(systemName: "star.fill")
            }else {
                cell.Liked = "No"
                cell.starView.image = UIImage(systemName: "star")
            }
        }
        
        ref.child("Rates").child(vidString).observe(.value) { (snapshot) in
            if snapshot.exists()
            {
                let pointcount: Int = Int(snapshot.childrenCount)
                
                cell.PointsLabel.text = String(pointcount)
            }
        }
        
        self.getThumbnailFromImage(url: url!) { (thumbImage) in
            cell.VideoView.image = thumbImage
        }
        
        let profileTap = UITapGestureRecognizer(target: self, action: #selector(GoToProfile(sender:)))
        profileTap.numberOfTapsRequired = 1
        cell.profileImageView.isUserInteractionEnabled = true
        cell.profileImageView.addGestureRecognizer(profileTap)
        
        let nameTap = UITapGestureRecognizer(target: self, action: #selector(GoToProfile(sender:)))
        nameTap.numberOfTapsRequired = 1
        cell.NameLabel.isUserInteractionEnabled = true
        cell.NameLabel.addGestureRecognizer(nameTap)
        
        let commentTap = UITapGestureRecognizer(target: self, action: #selector(GoToComments(sender:)))
        commentTap.numberOfTapsRequired = 1
        cell.Comments.isUserInteractionEnabled = true
        cell.Comments.addGestureRecognizer(commentTap)
        
        return cell
    }
    
    func getThumbnailFromImage(url: URL, completion: @escaping((_ image: UIImage)-> Void))
    {
        DispatchQueue.global().async {
            let asset = AVAsset(url: url)
            let avAssetImageGenerator = AVAssetImageGenerator(asset: asset)
            avAssetImageGenerator.appliesPreferredTrackTransform = true
            
            let thumbnailTime = CMTimeMake(value: 7, timescale: 1)
            do {
                let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumbnailTime, actualTime: nil)
                let thumbImage = UIImage(cgImage: cgThumbImage)

                DispatchQueue.main.async {
                    completion(thumbImage)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    @objc func GoToProfile(sender: UITapGestureRecognizer)
    {
        let touch = sender.location(in: tableView)
        if let indexPath = tableView.indexPathForRow(at: touch) {
            let items = videodata[indexPath.row]
            let id = items.publisher
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "AddProfile", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "AddProfile") as! AddProfile
            newViewController.Userid = id
            self.navigationController?.pushViewController(newViewController, animated: true)
        }
    }
    @objc func GoToComments(sender: UITapGestureRecognizer)
    {
        let touch = sender.location(in: tableView)
        if let indexPath = tableView.indexPathForRow(at: touch) {
            let items = videodata[indexPath.row]
            let id = items.timestring
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "CommentPost", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "CommentPost") as! CommentPost
            newViewController.PostID = id
            self.navigationController?.pushViewController(newViewController, animated: true)
        }
    }
}
