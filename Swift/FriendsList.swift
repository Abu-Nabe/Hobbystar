//
//  FriendsList.swift
//  Zinging
//
//  Created by Abu Nabe on 28/1/21.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class FriendsList: UIViewController
{
    
    var friendData: [UserData] = [UserData]()
    var reqData: [UserData] = [UserData]()
    let cellid = "Don't Lack"
    var reqid = "Come on"
    
    let FriendReqLabel: UILabel = {
        let text = UILabel()
        text.text = "Friend Request"
        text.font = .systemFont(ofSize: 12.0)
        return text
    }()
    
    let ViewReqLabel: UILabel = {
        let text = UILabel()
        text.text = "View All Request"
        text.font = .systemFont(ofSize: 12.0)
        return text
    }()
    
    private var collectionView: UICollectionView?
    
    private let tableview: UITableView =
        {
            let tableview = UITableView()
            
            return tableview
        }()
    
    private let tableview1: UITableView =
        {
            let tableview = UITableView()
            
            return tableview
        }()
    
    let Title: UILabel = {
        let text = UILabel()
        text.text = "Friends"
        text.textColor = .black
        text.font = .italicSystemFont(ofSize: 14)
        return text
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        friendData.removeAll()
        reqData.removeAll()
        view.addSubview(FriendReqLabel)
        view.addSubview(ViewReqLabel)
        view.addSubview(tableview)
        view.addSubview(tableview1)
        view.addSubview(Title)
        
        self.edgesForExtendedLayout = []
        
        self.navigationItem.hidesBackButton = false
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = false
        
        collectionView?.anchor(top: view.topAnchor,width: view.width, height: 60)
        
        Title.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        Title.anchor(top: FriendReqLabel.bottomAnchor)
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewfriend))
        tap.numberOfTapsRequired = 1
        ViewReqLabel.isUserInteractionEnabled = true
        ViewReqLabel.addGestureRecognizer(tap)
        
        configureTableView()
        configureRequests()
        configureData()
        configureReqData()
    }
    @objc func viewfriend()
    {
        let storyBoard: UIStoryboard = UIStoryboard(name: "AllFriendList", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "AllFriendList") as! AllFriendList
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    func configureRequests()
    {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: view.width, height: 60)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView?.frame = CGRect(x: 0, y: 0, width: view.width, height: 60)
        collectionView?.backgroundColor = .gray
        collectionView?.showsHorizontalScrollIndicator = false
        
        view.addSubview(collectionView!)
        
        FriendReqLabel.anchor(top: collectionView?.bottomAnchor,left: view.leftAnchor)
        ViewReqLabel.anchor(top: collectionView?.bottomAnchor, right: view.rightAnchor)
        
        collectionView?.register(RequestCell.self, forCellWithReuseIdentifier: RequestCell.identifier)
        
        collectionView?.delegate = self
        collectionView?.dataSource = self
    }
    
    func configureReqData()
    {
        let ref = Database.database().reference()
        let Auth = FirebaseAuth.Auth.auth().currentUser!.uid
    
        ref.child("FriendRequest").child(Auth).observe(.value) { (snapshot) in
            for pics in snapshot.children.allObjects as![FirebaseDatabase.DataSnapshot] {
                let key = pics.key
                ref.child("Users").child(key).observe(.value) { (snapshot) in
                    
                    let Objects = snapshot.value as? [String: AnyObject]
                    
                    let picimage = Objects?["profileimage"] as? String ?? ""
                    let picpublisher = Objects?["hobbyname"] as? String ?? ""
                    let username = Objects?["username"] as! String
                    
                    let picList = UserData(image: picimage, text: username, Activity: picpublisher, id: key)
                    
                    
                    self.reqData.append(picList)
                
                    
                    self.collectionView?.reloadData()
                    
                }
            }
        }
    }
    
    func configureData()
    {
        let ref = Database.database().reference()
        let Auth = FirebaseAuth.Auth.auth().currentUser!.uid
        ref.child("Message").child(Auth).observe(.value) { (snapshot) in
            for users in snapshot.children.allObjects as![FirebaseDatabase.DataSnapshot] {
                let friendsid = users.key
                
                ref.child("Users").child(friendsid).observeSingleEvent(of: .value) { (snapshot) in
                    
                    let userObjects = snapshot.value as? [String: AnyObject]
                    let username = userObjects?["username"]
                    let status = userObjects?["online"]  as? String ?? ""
                    
                    let image = userObjects?["profileimage"] as? String ?? ""
                    
                    let key = snapshot.key
                    
                    let MessageUsers = UserData(image: image, text: username as! String, Activity: status , id: key)
                    
                    self.friendData.append(MessageUsers)
                    self.tableview.reloadData()
                }
            }
        }
    }
    
    func configureTableView()
    {
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(FriendlistCell.self, forCellReuseIdentifier: cellid)
        tableview.rowHeight = 60
        tableview.anchor(top: Title.bottomAnchor,width: view.width, height: view.height)
    }
    
}

extension FriendsList: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: cellid,for: indexPath) as! FriendlistCell
        let items = friendData[indexPath.row]
        
        cell.NameLabel.text = items.text
        let ref = Database.database().reference()
        let id = items.id
        
        cell.friendid = id
        
        
        cell.contentView.isUserInteractionEnabled = false
        
        let Auth = FirebaseAuth.Auth.auth().currentUser!.uid
        
        ref.child("Message").child(Auth).child(id).observe(.value) { (snapshot) in
            let ObjDict = snapshot.value as? [String: AnyObject]
            
            let status = ObjDict?["status"] as? String ?? "friends"
            
            cell.HobbyLabel.text = status
        }
        ref.child("Users").child(id).observe(.value) { (snapshot) in
            if snapshot.exists()
            {
                if snapshot.hasChild("profileimage")
                {
                    
                    let image = items.image
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
        
        
        //            let Auth = FirebaseAuth.Auth.auth().currentUser!.uid
        ref.child("Crush").child(Auth).observe(.value) { (snapshot) in
            if snapshot.exists()
            {
                cell.HeartImage.image = UIImage(systemName: "heart.circle.fill")
                cell.HeartImage.tintColor = .red
                
                ref.child("Crush").child(Auth).child(id).observe(.value) { (snapshot) in
                    if snapshot.exists()
                    {
                        cell.HeartImage.image = UIImage(systemName: "heart.fill")
                        cell.HeartImage.tintColor = .red
                    }
                }
            }
        }
        return cell
    }
    
    @objc func GoToProfile(sender: UITapGestureRecognizer)
    {
        let touch = sender.location(in: tableview)
        if let indexPath = tableview.indexPathForRow(at: touch) {
            let items = friendData[indexPath.row]
            let id = items.id
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "AddProfile", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "AddProfile") as! AddProfile
            newViewController.Userid = id
            self.navigationController?.pushViewController(newViewController, animated: true)
        }
    }
}


extension FriendsList: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if reqData.count == 0
        {
            collectionView.anchor(height: 0)
        }
        return reqData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RequestCell.identifier, for: indexPath) as! RequestCell
        
        let items = reqData[indexPath.row]
        
        let id = items.id
        
        let ref = Database.database().reference()
        
        cell.NameLabel.text = items.text
        
        ref.child("Users").child(id).observe(.value) { (snapshot) in
            if snapshot.exists()
            {
                if snapshot.hasChild("profileimage")
                {
                    let image = items.image
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
            }
        }
        
        let acceptTap = UITapGestureRecognizer(target: self, action: #selector(acceptRequest(sender:)))
        acceptTap.numberOfTapsRequired = 1
        cell.Acceptbutton.isUserInteractionEnabled = true
        cell.Acceptbutton.addGestureRecognizer(acceptTap)
        
        let declineTap = UITapGestureRecognizer(target: self, action: #selector(declineRequest(sender:)))
        declineTap.numberOfTapsRequired = 1
        cell.DeclineButton.isUserInteractionEnabled = true
        cell.DeclineButton.addGestureRecognizer(declineTap)
        return cell
    }
    
    @objc func acceptRequest(sender: UITapGestureRecognizer)
    {
        if !reqData.isEmpty{
            let touch = sender.location(in: collectionView)
            if let indexPath = collectionView?.indexPathForItem(at: touch) {
                let items = reqData[indexPath.row]
                let id = items.id
                
                let ref = Database.database().reference()
                let Auth = FirebaseAuth.Auth.auth().currentUser!.uid
                
                ref.child("FriendRequest").child(Auth).child(id).removeValue()
                ref.child("FriendRequest").child(id).child(Auth).removeValue()
                
                ref.child("Message").child(Auth).child(id).child("Message").setValue("Saved")
                ref.child("Message").child(id).child(Auth).child("Message").setValue("Saved")
                
                reqData.removeAll()
            }
        }
    }
    @objc func declineRequest(sender: UITapGestureRecognizer)
    {
        if !reqData.isEmpty
        {
            let alert = UIAlertController(title: "Are you sure you want to cancel request?", message: "Select", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: {(action:UIAlertAction!) in
                
                let touch = sender.location(in: self.collectionView)
                if let indexPath = self.collectionView?.indexPathForItem(at: touch) {
                    let items = self.reqData[indexPath.row]
                    let id = items.id
                    
                    let ref = Database.database().reference()
                    let Auth = FirebaseAuth.Auth.auth().currentUser!.uid
                    
                    ref.child("FriendRequest").child(Auth).child(id).removeValue()
                    ref.child("FriendRequest").child(id).child(Auth).removeValue()
                    
                }
                self.reqData.removeAll()
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            self.present(alert, animated: true)
        }
    }
}
