//
//  AddFriendsList.swift
//  Zinging
//
//  Created by Abu Nabe on 27/1/21.
//

import SwiftUI
import FirebaseDatabase
import FirebaseAuth

class AddFriendsList: UIViewController
{
    
    var Userid = String()
    var frienddata: [UserData] = [UserData]()
    
    let cellid = "friendcell"
    
    var auth = FirebaseAuth.Auth.auth().currentUser!.uid
    
    let profileImageView: UIImageView = {
        let profileimage = UIImageView()
        
        profileimage.contentMode = .scaleAspectFill
        profileimage.clipsToBounds = true
        profileimage.layer.borderWidth = 3
        profileimage.image = UIImage.init(systemName: "person.fill")
        profileimage.layer.borderColor = UIColor.black.cgColor
        return profileimage
    }()
    
    let textview: UITextView =
    {
        let text = UITextView()
        text.text = "Request"
        
        
        return text
    }()
    
    private let FriendButton: UIButton = {
        let LoginButton = UIButton()
        LoginButton.backgroundColor = .systemGreen
        LoginButton.setTitleColor(.white, for: .normal)
        LoginButton.setTitle("Request", for: .normal)
        
        return LoginButton
    }()
    
    private let MessageButton: UIButton = {
        let LoginButton = UIButton()
        LoginButton.backgroundColor = .systemGreen
        LoginButton.setTitleColor(.white, for: .normal)
        LoginButton.setTitle("Message", for: .normal)
        
        return LoginButton
    }()
    
    private let line:  UIView =
        {
            let line = UIView()
            
            return line
        }()
    
    private let blackline:  UIView =
        {
            let line = UIView()
            line.backgroundColor = .black
            return line
        }()
    
    private let tableView: UITableView =
        {
            let tableview = UITableView()
            
            return tableview
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(profileImageView)
        view.addSubview(line)
        view.addSubview(FriendButton)
        view.addSubview(MessageButton)
        view.addSubview(blackline)
        view.addSubview(tableView)
        
        self.edgesForExtendedLayout = []
        
        self.navigationItem.hidesBackButton = false
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = false
        
        configureTableView()
        
        profileImageView.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 0, paddingLeft: 15, width: 40, height: 40)
        
        profileImageView.layer.cornerRadius = 40/2
        
        line.frame = CGRect(x: view.width/2, y: 0, width: 0, height: 0)
        
        FriendButton.anchor(right: line.leftAnchor, paddingRight: 2, height: 40)
        MessageButton.anchor(left: line.rightAnchor, paddingLeft: 2, height: 40)
        
        blackline.anchor(top: FriendButton.bottomAnchor, width: view.width, height: 1)
        
        tableView.anchor(top: blackline.bottomAnchor, width: view.width, height: view.height)
        
        FriendButton.addTarget(self, action: #selector(AddFriend), for: .touchUpInside)
        MessageButton.addTarget(self, action: #selector(MessageFriend), for: .touchUpInside)
        let ref = Database.database().reference()
        
        ref.child("Message").child(auth).child(Userid).observe(.value) { (snapshot) in
            if snapshot.exists()
            {
                ref.child("Message").child(self.Userid).child(self.auth).observe(.value) { (snapshot) in
                    if(snapshot.exists())
                    {
                        self.textview.text = "Friends"
                        self.FriendButton.setTitle("Friends", for: .normal)
                    }
                    
                }
            }
          
        }
        ref.child("FriendRequest").child(auth).child(self.Userid).observe(.value) { (snapshot) in
            if snapshot.exists()
            {
                ref.child("FriendRequest").child(self.Userid).child(self.auth).observe(.value) { (snapshot) in
                    if(snapshot.exists())
                    {
                        self.textview.text = "Requested"
                        self.FriendButton.setTitle("Requested", for: .normal)
                    }
                    
                }
            }
            
        }
        
        configureData()
    }
    
    @objc func MessageFriend()
    {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Chat", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "Chat") as! Chat
        newViewController.friendID = Userid
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    @objc func AddFriend()
    {
        let Status = textview.text
        
        let ref = Database.database().reference()
        
        if Status == "Request"
        {
            ref.child("FriendRequest").child(Userid).child(auth).child("request_type").setValue("received")
            ref.child("FriendRequest").child(auth).child(Userid).child("request_type").setValue("sent")
            FriendButton.setTitle("Requested", for: .normal)
            textview.text = "Requested"
        }else if Status == "Friends"{
            //Go to his friendslist
            let alert = UIAlertController(title: "Are you sure you want to unfriend this person?", message: "", preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Unfriend", style: .destructive, handler: {(action:UIAlertAction!) in
                ref.child("Message").child(self.Userid).child(self.auth).removeValue()
                ref.child("Message").child(self.auth).child(self.Userid).removeValue()
                
                
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            self.present(alert, animated: true)
            
        }else if Status == "Requested"{
            ref.child("FriendRequest").child(auth).child(Userid).removeValue()
            ref.child("FriendRequest").child(Userid).child(auth).removeValue()
        }
    }

    func configureTableView()
    {
        tableView.register(AddFriendsCell.self, forCellReuseIdentifier: cellid)
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func configureData()
    {
        let ref = Database.database().reference()
        
        ref.child("Message").child(Userid).observe(.value) { (snapshot) in
            for users in snapshot.children.allObjects as![FirebaseDatabase.DataSnapshot] {
                
                let id = users.key
                
                ref.child("Users").child(id).observeSingleEvent(of: .value) { (snapshot) in
                    let friendid = snapshot.value as? [String: AnyObject]
                    let username = friendid?["username"]
                    
                    let points = friendid?["points"]?.childrenCount as? Int ?? 0

                    let image = friendid?["profileimage"] as? String ?? ""
                    
                    
                    let MessageUsers = UserData(image: image, text: username as! String, Activity: points , id: id)
                    
                    self.frienddata.append(MessageUsers)
                    self.tableView.reloadData()
                }
            }
        }
    }
}



extension AddFriendsList: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return frienddata.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellid, for: indexPath) as! AddFriendsCell
        
        let items = frienddata[indexPath.row]
        
        cell.NameLabel.text = items.text
        cell.HobbyLabel.text = items.Activity as? String
        
        cell.contentView.isUserInteractionEnabled = false
        
        let id = items.id
        let ref = Database.database().reference()
        
        ref.child("Message").child(auth).child(id).observe(.value) { (snapshot) in
            if snapshot.exists()
            {
                ref.child("Message").child(id).child(self.auth).observe(.value) { (snapshot) in
                    if(snapshot.exists())
                    {
                        cell.Button.setTitle("Friends", for: .normal)
                    }
                    
                }
            }
        }
        let Auth = FirebaseAuth.Auth.auth().currentUser!.uid
        ref.child("FriendRequest").child(Auth).child(id).observe(.value) { (snapshot) in
            if snapshot.exists(){
                let objDict = snapshot.value as? [String: AnyObject]
                    
                let type = objDict?["request_type"] as! String
                    
                if type == "sent"
                {
                    cell.Button.setTitle("Requested", for: .normal)
                }else {
                    cell.Button.setTitle("Respond", for: .normal)
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
        
        let requestTap = UITapGestureRecognizer(target: self, action: #selector(RequestUser(sender:)))
        requestTap.numberOfTapsRequired = 1
        cell.Button.isUserInteractionEnabled = true
        cell.Button.addGestureRecognizer(requestTap)
        
        if id == auth
        {
            cell.Button.isHidden = true
        }
        
        ref.child("Users").child(id).observe(.value) { (snapshot) in
            if snapshot.exists()
            {
                if snapshot.hasChild("profileimage")
                {
                
//                            let image = userObjects?["profileimage"]
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
                                        cell.profileImageView.image = UIImage(systemName: "person.fill")?.withRenderingMode(.alwaysOriginal)
                                           print("Something is wrong with the image data")
                                       }

                                   }).resume()
                }
            }

        }
        
        
        
        return cell
    }
    
    @objc func GoToProfile(sender: UITapGestureRecognizer)
    {
        let touch = sender.location(in: tableView)
        if let indexPath = tableView.indexPathForRow(at: touch) {
            let items = frienddata[indexPath.row]
            let id = items.id
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "AddProfile", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "AddProfile") as! AddProfile
            newViewController.Userid = id
            self.navigationController?.pushViewController(newViewController, animated: true)
        }
    }
    
    @objc func RequestUser(sender: UITapGestureRecognizer)
    {
        let ref = Database.database().reference()
        let Auth = FirebaseAuth.Auth.auth().currentUser!.uid
        
        let touch = sender.location(in: tableView)
        if let indexPath = tableView.indexPathForRow(at: touch) {
            let items = frienddata[indexPath.row]
            let id = items.id
            let  cell = tableView.dequeueReusableCell(withIdentifier: cellid, for: indexPath) as! AddFriendsCell
            
            ref.child("Message").child(Auth).child(id).observe(.value) { (snapshot) in
                if snapshot.exists()
                {
                    print("Nigga No")
                }else {
                    ref.child("FriendRequest").child(id).child(Auth).child("request_type").setValue("received")
                    ref.child("FriendRequest").child(Auth).child(id).child("request_type").setValue("sent")
                    
                    cell.Button.setTitle("Requested", for: .normal)
                }
            }
        }
    }
}
