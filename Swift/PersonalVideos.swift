//
//  PersonalVideos.swift
//  Zinging
//
//  Created by Abu Nabe on 11/4/21.
//

import UIKit
import Firebase
import FirebaseAuth
import AVFoundation
import AVKit

class PersonalVideos: UIViewController
{
    var videodata: [AllVideoData] = [AllVideoData]()
    
    var videoUserID = String()
    var player = AVPlayer()
    
    let tableView: UITableView =
        {
            let tableview = UITableView()
            
            return tableview
        }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        
        self.edgesForExtendedLayout = []
        
        configureTableView()
        configureData()
        listenDeletes()
        
        self.navigationItem.hidesBackButton = false
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = false
        
        
    }
    func configureTableView()
    {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(ZingingVideoCell.self, forCellReuseIdentifier: "Cell")
        tableView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        
    }
    
    func configureData()
    {
        let ref = Database.database().reference()
        
        
        let currentDate = Date()
        let since1970 = currentDate.timeIntervalSince1970
        
        
        ref.child("Videos").observe(.value) { (snapshot) in
            for pics in snapshot.children.allObjects as![FirebaseDatabase.DataSnapshot] {
                self.videodata.removeAll()
                let picid = pics.key
                
                ref.child("Videos").queryOrdered(byChild: picid).queryStarting(atValue: since1970).observeSingleEvent(of: .value) { (snapshot) in
                    
                    let viddata = AllVideoData(snapshot: pics)
                    
                    if viddata.publisher == FirebaseAuth.Auth.auth().currentUser!.uid
                    {
                    DispatchQueue.main.async {
                        
                        self.videodata.insert(viddata, at: 0)
                        self.tableView.reloadData()
                    }
                    }
                }
            }
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
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        if let indexPath = self.tableView.indexPathsForVisibleRows {
            for i in indexPath {
                
                let cell : ZingingVideoCell = self.tableView.cellForRow(at: i) as! ZingingVideoCell
                
                cell.player.pause()
                
            }
        }
    }

    
}

extension PersonalVideos: UITableViewDelegate, UITableViewDataSource
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
        
        let videoID = items.videoimage
        let url = URL(string: videoID)
        
        cell.vidID = videoID
        
        //use loading circulation and then play video
        let timestamp = items.timestamp
        
        let videoURL = URL(string: videoID)
        cell.player = AVPlayer(url: videoURL!)
        
        DispatchQueue.main.async {
            let playerLayer = AVPlayerLayer(player: cell.player)
            playerLayer.frame = cell.videoFrame.bounds
            cell.videoFrame.layer.addSublayer(playerLayer)
            
            cell.player.pause()
        }
        
        self.getThumbnailFromImage(url: url!) { (thumbImage) in
            cell.VideoView.image = thumbImage
        }
        let date = Date(timeIntervalSince1970: timestamp / 1000)
        let timeAgo = timeAgoSince(date)
        
        cell.TimeLabel.text = timeAgo
        
        let vidString = items.videoid
        
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
            
            if snapshot.hasChild("hobbyname")
            {
                let hobby = postObjects?["hobbyname"] as! String
                cell.HobbyLabel.text = hobby
            }
            ref.child("Users").child(items.publisher).child("points").observe(.value) { (snapshot) in
                if snapshot.exists()
                {
                    let pointcount: Int = Int(snapshot.childrenCount)
                    
                    cell.CurrentPointsLabel.text = String(pointcount)
                }
            }
            
            ref.child("Rates").child(vidString).observe(.value) { (snapshot) in
                if snapshot.exists()
                {
                    let pointcount: Int = Int(snapshot.childrenCount)
                    
                    cell.PointsLabel.text = String(pointcount)
                }
            }
        }
        
        cell.DescriptionLabel.text = items.description
        
        cell.vidID = vidString
        
        let Auth = FirebaseAuth.Auth.auth().currentUser!.uid
        
        ref.child("Rates").child(vidString).child(Auth).observe(.value) { (snapshot) in
            if snapshot.exists()
            {
                cell.Liked = "Yes"
                cell.starView.image = UIImage(systemName: "star.fill")
                cell.starView.tintColor = .green
            }else {
                cell.Liked = "No"
                cell.starView.image = UIImage(systemName: "star")
                cell.starView.tintColor = .green
            }
        }
        
        let profileTap = UITapGestureRecognizer(target: self, action: #selector(GoToProfile(sender:)))
        profileTap.numberOfTapsRequired = 1
        cell.profileImageView.isUserInteractionEnabled = true
        cell.profileImageView.addGestureRecognizer(profileTap)
        
        let nameTap = UITapGestureRecognizer(target: self, action: #selector(GoToProfile(sender:)))
        nameTap.numberOfTapsRequired = 1
        cell.NameLabel.isUserInteractionEnabled = true
        cell.NameLabel.addGestureRecognizer(nameTap)
        
        let optionTap = UITapGestureRecognizer(target: self, action: #selector(ImageOption(sender:)))
        optionTap.numberOfTapsRequired = 1
        cell.OptionImage.isUserInteractionEnabled = true
        cell.OptionImage.addGestureRecognizer(optionTap)
        
        let commentTap = UITapGestureRecognizer(target: self, action: #selector(GoToComments(sender:)))
        commentTap.numberOfTapsRequired = 1
        cell.Comments.isUserInteractionEnabled = true
        cell.Comments.addGestureRecognizer(commentTap)
        
        return cell
    }
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Dequeue the cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",for: indexPath) as! ZingingVideoCell
        // Check the player object is set (unwrap it)
        
        if cell.playing == "no"
        {
            cell.player.pause()
        }
    }
    
    @objc func ImageOption(sender: UITapGestureRecognizer)
    {
        
        let touch = sender.location(in: tableView)
        let ref = Database.database().reference()
        
        if !videodata.isEmpty {
            if let indexPath = tableView.indexPathForRow(at: touch) {
                let items = videodata[indexPath.row]
                let auth = FirebaseAuth.Auth.auth().currentUser!.uid
                if items.publisher == auth{
                    
                    let alert = UIAlertController(title: "Delete this post", message: "Are you sure you want to delete this post?", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {(action:UIAlertAction!) in
                        ref.child("Pics").child(items.timestring).removeValue()
                        ref.child("Users").child(items.publisher).child("zingingvid").child(items.timestring).removeValue()
                        ref.child("ZingingPosts").child(items.timestring).removeValue()
                        ref.child("PostNotifications").child(items.timestring).removeValue()
                        self.videodata.removeAll()
                        self.tableView.reloadData()
                    }))
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    
                    self.present(alert, animated: true)
                }else {
                    let alert = UIAlertController(title: "Report Post", message: "Are you sure you want to report this post?", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Report", style: .destructive, handler: {(action:UIAlertAction!) in
                        ref.child("Report").child(items.publisher).child(items.timestring).setValue("reported")
                    }))
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    
                    self.present(alert, animated: true)
                }
            }
        }
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
    //    override func viewDidDisappear(_ animated: Bool) {
    //        <#code#>
    //    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 450
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
