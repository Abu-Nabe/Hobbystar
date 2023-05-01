//
//  AddInterest.swift
//  Zinging
//
//  Created by Abu Nabe on 27/1/21.
//

import SwiftUI
import FirebaseDatabase
import FirebaseAuth

class AddInterest: UIViewController
{
    
    var Userid = String()
    var frienddata: [UserData] = [UserData]()
    
    var interestType = "no"
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
        text.text = "Interest"
        
        
        return text
    }()
    
    private let FriendButton: UIButton = {
        let LoginButton = UIButton()
        LoginButton.backgroundColor = .systemGreen
        LoginButton.setTitleColor(.white, for: .normal)
        LoginButton.setTitle("Interest", for: .normal)
        
        return LoginButton
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
        view.addSubview(FriendButton)
        view.addSubview(blackline)
        view.addSubview(tableView)
        
        self.edgesForExtendedLayout = []
        
        configureTableView()
        
        self.navigationItem.hidesBackButton = false
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = false
        
        profileImageView.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 0, paddingLeft: 15, width: 40, height: 40)
        
        profileImageView.layer.cornerRadius = 40/2
        
        FriendButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        FriendButton.anchor(height: 40)
        
        blackline.anchor(top: FriendButton.bottomAnchor, width: view.width, height: 1)
        
        tableView.anchor(top: blackline.bottomAnchor, width: view.width, height: view.height)
        
        FriendButton.addTarget(self, action: #selector(AddFriend), for: .touchUpInside)
    
        let ref = Database.database().reference()
        
        ref.child("Interest").child(auth).child(Userid).observe(.value) { (snapshot) in
            if snapshot.exists()
            {
                self.textview.text = "Interested"
                self.FriendButton.setTitle("Interested", for: .normal)
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
        
        if Status == "Interest"
        {
            ref.child("Interest").child(auth).child(Userid).child("interest").setValue("saved")
            
            FriendButton.setTitle("Interested", for: .normal)
            textview.text = "Interested"
        }else if Status == "Interested"{
            //Go to his friendslist
            let alert = UIAlertController(title: "Lost Interest?", message: "", preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Uninterested", style: .destructive, handler: {(action:UIAlertAction!) in
                ref.child("Interest").child(self.auth).child(self.Userid).removeValue()
                
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            self.present(alert, animated: true)
            
        }
    }

    func configureTableView()
    {
        tableView.register(AddFriendsCell.self, forCellReuseIdentifier: cellid)
        tableView.rowHeight = 60
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func configureData()
    {
        let ref = Database.database().reference()
        
        ref.child("Interest").child(Userid).observe(.value) { (snapshot) in
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



extension AddInterest: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return frienddata.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellid, for: indexPath) as! AddFriendsCell
        
        let items = frienddata[indexPath.row]
        
        cell.NameLabel.text = items.text
        cell.HobbyLabel.text = items.Activity as? String
        
        
        let id = items.id
        let ref = Database.database().reference()
        
        cell.contentView.isUserInteractionEnabled = false
        
        cell.Button.setTitle("Interest", for: .normal)
        
        let Auth = FirebaseAuth.Auth.auth().currentUser!.uid
        
        ref.child("Interest").child(Auth).child(id).observe(.value) { (snapshot) in
            if snapshot.exists()
            {
                cell.Button.setTitle("Interested", for: .normal)
                self.interestType = "yes"
                print(self.interestType)
            }else {
                cell.Button.setTitle("Interest", for: .normal)
                self.interestType = "no"
            }
          
        }
        
        if id == auth
        {
            cell.Button.isHidden = true
        }
        
        let profileTap = UITapGestureRecognizer(target: self, action: #selector(GoToProfile(sender:)))
        profileTap.numberOfTapsRequired = 1
        cell.profileImageView.isUserInteractionEnabled = true
        cell.profileImageView.addGestureRecognizer(profileTap)
        
        let nameTap = UITapGestureRecognizer(target: self, action: #selector(GoToProfile(sender:)))
        nameTap.numberOfTapsRequired = 1
        cell.NameLabel.isUserInteractionEnabled = true
        cell.NameLabel.addGestureRecognizer(nameTap)
        
        let interestTap = UITapGestureRecognizer(target: self, action: #selector(RequestUser(sender:)))
        interestTap.numberOfTapsRequired = 1
        cell.Button.isUserInteractionEnabled = true
        cell.Button.addGestureRecognizer(interestTap)
        
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
    
    @objc func RequestUser(sender: UITapGestureRecognizer)
    {
        let ref = Database.database().reference()
        let Auth = FirebaseAuth.Auth.auth().currentUser!.uid
        
        let touch = sender.location(in: tableView)
        if let indexPath = tableView.indexPathForRow(at: touch) {
            let items = frienddata[indexPath.row]
            let id = items.id
            let  cell = tableView.dequeueReusableCell(withIdentifier: cellid, for: indexPath) as! AddFriendsCell
            
            if interestType == "yes"
            {
                ref.child("Interest").child(Auth).child(id).removeValue()
                cell.Button.setTitle("Interest", for: .normal)
                interestType = "no"
//                self.frienddata.removeAll()
                
            }else {
                ref.child("Interest").child(Auth).child(id).child("Interest").setValue("Saved")

                cell.Button.setTitle("Interested", for: .normal)
                interestType = "yes"
//                self.frienddata.removeAll()
            }
        }
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
}
