//
//  NotificationView.swift
//  Zinging
//
//  Created by Abu Nabe on 3/1/21.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import AVKit
import AVFoundation


class NotificationView: UIViewController
{
    var NotifRef: FirebaseDatabase.DatabaseReference!
    
    let cellId = "notifid"
    let postnotifid = "postid"
    
    var postdata: [PostNotif] = [PostNotif]()
    var notifdata: [UserData1] = [UserData1]()
    
    private var collectionView: UICollectionView?
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        self.edgesForExtendedLayout = []
        
        let date = Date() // current date
        let timestamp = date.toMilliseconds()
        
        
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
        
        let Auth = FirebaseAuth.Auth.auth().currentUser!.uid
        let ref = Database.database().reference().child("Users").child(Auth).child("online")
        ref.setValue("Online")
        ref.onDisconnectSetValue(timestamp)
        
        notifdata.removeAll()
        configureNavigationBar()
        configureTableView()
        configureCollectionView()
        configureFriend()
        configureData()
        
        tableView.register(SearchCell.self, forCellReuseIdentifier: cellId)
        
    }
    
    override func didReceiveMemoryWarning() {
     super.didReceiveMemoryWarning()
     // Dispose of any resources that can be recreated.
     }
    
    func configureCollectionView()
    {        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 150, height: 245)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView?.frame = CGRect(x: 0, y: 0, width: view.width, height: 0)
        collectionView?.backgroundColor = .white
        collectionView?.showsHorizontalScrollIndicator = false
        
        view.addSubview(collectionView!)
        
        tableView.anchor(top: collectionView?.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        
        collectionView?.register(PostNotifications.self, forCellWithReuseIdentifier: postnotifid)
        
        collectionView?.delegate = self
        collectionView?.dataSource = self
    }
    
    func configureTableView()
    {
        view.addSubview(tableView)
        setTableViewDelegates()
        tableView.rowHeight = 60
        
    }
  
    func setTableViewDelegates()
    {
        tableView.dataSource = self
        tableView.delegate = self
    }

    private func configureNavigationBar()
    {
        let longTitleLabel = UILabel()
            longTitleLabel.text = "Notifications"
            longTitleLabel.textColor = .black
            longTitleLabel.font = .boldSystemFont(ofSize: 16.0)
            longTitleLabel.sizeToFit()

            let leftItem = UIBarButtonItem(customView: longTitleLabel)
            self.navigationItem.leftBarButtonItem = leftItem
        navigationController?.navigationBar.barTintColor = .green
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.fill.badge.plus"), style: .done, target: self, action: #selector(didTapSettingsButton))
    }
    @objc private func didTapSettingsButton()
    {
        let storyboard = UIStoryboard(name: "GatherFriendList", bundle: nil)
        let secondViewController = storyboard.instantiateViewController(withIdentifier: "GatherFriendList") as! GatherFriendList
        self.present(secondViewController, animated:true, completion:nil)
    }
    
    func configureFriend()
    {
        let ref = Database.database().reference()
        guard let Auth = FirebaseAuth.Auth.auth().currentUser?.uid else {
            return
        }
        
        ref.child("Message").child(Auth).observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists()
            {
                for users in snapshot.children.allObjects as![FirebaseDatabase.DataSnapshot] {
                    let friendid1 = users.key
                    
                    self.configurePostData(String: friendid1)
                }
            }else {
                
            }
        }
    }
    
    func configurePostData(String: String)
    {
        let friendid = String
        print(friendid)
        let ref = Database.database().reference()

        ref.child("PostNotifications").observe(.value) { (snapshot) in
            for users in snapshot.children.allObjects as![FirebaseDatabase.DataSnapshot] {
                let notifid = users.key
                ref.child("PostNotifications").child(notifid).observeSingleEvent(of: .value) { (snapshot) in
                    
                    let postnotiflist = PostNotif(snapshot: users)
                    
                    if friendid == postnotiflist.publisher
                    {
                        self.collectionView?.frame = CGRect(x: 0, y: 0, width: self.view.width, height: 245)

                        self.tableView.anchor(top: self.collectionView?.bottomAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor)
                                            
                        self.postdata.insert(postnotiflist, at: 0)
                        
                    }
                    
                    self.collectionView?.reloadData()
                }
            }
        }
    }
    
    func configureData()
    {
        let ref = Database.database().reference()
        let Auth = FirebaseAuth.Auth.auth().currentUser!.uid
        
        ref.child("Notifications").child(Auth).observe(.value) { (snapshot) in
            for users in snapshot.children.allObjects as![FirebaseDatabase.DataSnapshot] {
                let notifid = users.key
                ref.child("Notifications").child(Auth).child(notifid).observeSingleEvent(of: .value) { (snapshot) in
                    let obj = snapshot.value as? [String: AnyObject]
                
                    let timestring = obj?["date"] as? TimeInterval ?? 0
                    let text = obj?["text"]
                    let userid = obj?["userid"] as! String
                    let timestamp = obj?["timestamp"] as! String
                    
                    let notifList = UserData1(image: timestamp, text: text as! String, Activity: timestamp, id: userid, timeAgo: timestring)
                    
                    self.notifdata.insert(notifList, at: 0)
                    
                    self.tableView.reloadData()
                }
            }
        }
    }
    
}

extension NotificationView: UICollectionViewDelegate, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postdata.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: postnotifid, for: indexPath) as! PostNotifications
        
        let items = postdata[indexPath.row]
        cell.contentView.isUserInteractionEnabled = false
        
        let ref = Database.database().reference()
        
        ref.child("Users").child(items.publisher).observe(.value) { (snapshot) in
            if snapshot.exists()
            {
                let obj = snapshot.value as! [String: AnyObject]
                
                let name = obj["username"] as! String
                cell.NameLabel.text = name
                
                if snapshot.hasChild("profileimage")
                {
                    let image = obj["profileimage"]
                    let url = URL(string: image as! String)
                    URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                        
                        if let error = error {
                            print("There was an error fetching the image from the url: \n", error)
                        }
                        
                        if let data = data, let profilePicture = UIImage(data: data) {
                            DispatchQueue.main.async() {
                                cell.profileImageView.image = profilePicture // Set the profile picture
                            }
                        } else {
                            cell.profileImageView.image = UIImage(systemName: "person.fill")?.withRenderingMode(.alwaysOriginal)
                            print("Something is wrong with the image data")
                        }
                        
                    }).resume()
                }
            }
        }
        
        let picture = items.post
        print(picture)
        let url = URL(string: picture)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            
            if let error = error {
                print("There was an error fetching the image from the url: \n", error)
            }
            
            if let data = data, let profilePicture = UIImage(data: data) {
                DispatchQueue.main.async() {
                    cell.postView.image = profilePicture // Set the profile picture
                }
            } else {
                self.getThumbnailFromImage(url: url!) { (thumbImage) in
                    cell.postView.image = thumbImage
                }
            }
        }).resume()
        
        let date = Date(timeIntervalSince1970: items.timestamp / 1000)
        let timeAgo = timeAgoSince(date)
        
        cell.TimeAgoLabel.text = timeAgo
        
        let profileTap = UITapGestureRecognizer(target: self, action: #selector(GoToProfile1(sender:)))
        profileTap.numberOfTapsRequired = 1
        cell.profileImageView.isUserInteractionEnabled = true
        cell.profileImageView.addGestureRecognizer(profileTap)
        
        let nameTap = UITapGestureRecognizer(target: self, action: #selector(GoToProfile1(sender:)))
        nameTap.numberOfTapsRequired = 1
        cell.NameLabel.isUserInteractionEnabled = true
        cell.NameLabel.addGestureRecognizer(nameTap)
        
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(GoToImage(sender:)))
        imageTap.numberOfTapsRequired = 1
        cell.postView.isUserInteractionEnabled = true
        cell.postView.addGestureRecognizer(imageTap)
        
        return cell
    }
    func getThumbnailFromImage(url: URL, completion: @escaping((_ image: UIImage)-> Void))
    {
        DispatchQueue.global().async {
            let asset = AVAsset(url: url)
            let avAssetImageGenerator = AVAssetImageGenerator(asset: asset)
            avAssetImageGenerator.appliesPreferredTrackTransform = true
            
            let thumbnailTime = CMTimeMake(value: 1, timescale: 1)
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
    
}

extension NotificationView: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return notifdata.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! SearchCell
       
        let items = notifdata[indexPath.row]
        cell.contentView.isUserInteractionEnabled = false
        
        cell.HobbyLabel.text = items.text
        let id = items.id
        let timestamp = items.timeAgo
        
        cell.NotifLabel.isHidden = false
        
        let date = Date(timeIntervalSince1970: timestamp / 1000)
        let timeAgo = timeAgoSince(date)
        
        cell.NotifLabel.text = timeAgo
        
        let ref = Database.database().reference()
        ref.child("Users").child(id).observe(.value) { (snapshot) in
            let data = snapshot.value as? [String: AnyObject]
            
            let name = data?["username"] as! String
            cell.NameLabel.text = name
            
            if snapshot.hasChild("profileimage")
            {
            
                let image = data?["profileimage"]

                let url = URL(string: image as! String)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

                                   if let error = error {
                                       print("There was an error fetching the image from the url: \n", error)
                                   }

                                   if let data = data, let profilePicture = UIImage(data: data) {
                                       DispatchQueue.main.async() {
                                        cell.profileImageView.image = profilePicture // Set the profile picture
                                       }
                                   } else {
                                    cell.profileImageView.image = UIImage(systemName: "person.fill")?.withRenderingMode(.alwaysOriginal)
                                       print("Something is wrong with the image data")
                                   }

                               }).resume()
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
        
        return cell
    }
    @objc func GoToProfile(sender: UITapGestureRecognizer)
    {
        let touch = sender.location(in: tableView)
        if let indexPath = tableView.indexPathForRow(at: touch) {
            let items = notifdata[indexPath.row]
            let id = items.id
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "AddProfile", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "AddProfile") as! AddProfile
            newViewController.Userid = id
            self.navigationController?.pushViewController(newViewController, animated: true)
        }
    }
    @objc func GoToProfile1(sender: UITapGestureRecognizer)
    {
        let touch = sender.location(in: collectionView)
        if let indexPath = collectionView!.indexPathForItem(at: touch) {
            let items = postdata[indexPath.row]
            let id = items.publisher
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "AddProfile", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "AddProfile") as! AddProfile
            newViewController.Userid = id
            self.navigationController?.pushViewController(newViewController, animated: true)
        }
    }
    @objc func GoToImage(sender: UITapGestureRecognizer)
    {
        let touch = sender.location(in: collectionView)
        if let indexPath = collectionView!.indexPathForItem(at: touch) {
            let items = postdata[indexPath.row]
            let id = items.timestring
           
            let storyBoard: UIStoryboard = UIStoryboard(name: "ClickPost", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "ClickPost") as! ClickPost
            newViewController.postid = id
            self.navigationController?.pushViewController(newViewController, animated: true)
        }
    }
}



