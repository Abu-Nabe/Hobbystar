//
//  MessageViewController.swift
//  Zinging
//
//  Created by Abu Nabe on 3/1/21.
//.

import UIKit
import FirebaseDatabase
import Firebase

class MessageView: UIViewController, UITableViewDelegate, UITableViewDataSource
{    
    var messageList : [UserData1] = [UserData1]()
    let cellid = "MessageCell"
    
    private let tableview: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.tabBarController?.tabBar.isHidden = false
        
        let date = Date() // current date
        let timestamp = date.toMilliseconds()
        
        let Auth = FirebaseAuth.Auth.auth().currentUser!.uid
        let ref = Database.database().reference().child("Users").child(Auth).child("online")
        ref.setValue("Online")
        ref.onDisconnectSetValue(timestamp)
        
        tableview.register(MessageCell.self, forCellReuseIdentifier: cellid)
        
//        configureFriends()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        configure()
        
        configureTableView()
        
        setTableViewDelegates()
        configureNavigationBar()
        
        listenDeletes()
        
        messageList.removeAll()
        
        guard let Auth = FirebaseAuth.Auth.auth().currentUser?.uid else {
            print("you fucked up")
            
            return
        }
        
        let ref = Database.database().reference()
    
        let currentDate = Date()
            let since1970 = currentDate.timeIntervalSince1970
        
        ref.child("Message").child(Auth).queryOrdered(byChild: "timestamp").queryStarting(atValue: since1970).observeSingleEvent(of: .value) { (snapshot) in
                for users in snapshot.children.allObjects as![FirebaseDatabase.DataSnapshot] {
                    
                    let friendsid = users.key
                                    
                    ref.child("Users").child(friendsid).observeSingleEvent(of: .value) { (snapshot) in
                        
                        let userObjects = snapshot.value as? [String: AnyObject]
                        let username = userObjects?["username"] as! String
                        let status = userObjects?["online"]  as? String ?? ""
                        
                        let timestring = userObjects?["online"] as? TimeInterval ?? 0
                        
                        let image = userObjects?["profileimage"] as? String ?? ""
    
                        let key = snapshot.key
                
                        let MessageUsers = UserData1(image: image, text: username, Activity: status, id: key, timeAgo: timestring)
                        self.messageList.insert(MessageUsers, at: 0)
                        self.tableview.reloadData()
                    }
                }
        }
    }
    func setTableViewDelegates()
    {
        tableview.dataSource = self
        tableview.delegate = self
    }
    func configure()
    {
        let longTitleLabel = UILabel()
            longTitleLabel.text = "Message"
            longTitleLabel.textColor = .black
            longTitleLabel.font = .boldSystemFont(ofSize: 16.0)
            longTitleLabel.sizeToFit()

            let leftItem = UIBarButtonItem(customView: longTitleLabel)
            self.navigationItem.leftBarButtonItem = leftItem
        
        self.navigationItem.hidesBackButton = true
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.barTintColor = .green 
    }
    
    func listenDeletes()
    {
        let ref = Database.database().reference().child("Messages")
        let auth = FirebaseAuth.Auth.auth().currentUser!.uid
        
        ref.child(auth).observe(.value) { (snapshot) in
             for posts in snapshot.children.allObjects as![FirebaseDatabase.DataSnapshot] {
                 let key = posts.key
                 ref.child(key).observe(.childRemoved, with: { [self] postSnapshot in
                    if let index = self.messageList.firstIndex(where: {$0.id == key}) {

                         self.messageList.remove(at: index)
//                         self.compileCounter -= 1
                         self.tableview.deleteRows(at: [IndexPath(item: index, section: 0)], with: .none)
                  }
                })
             }
         }
    }
    
    func configureFriends()
    {
        guard let Auth = FirebaseAuth.Auth.auth().currentUser?.uid else {
            
            return
        }
        
        let ref = Database.database().reference()
    
        let currentDate = Date()
            let since1970 = currentDate.timeIntervalSince1970
        
        ref.child("Message").child(Auth).queryOrdered(byChild: "timestamp").queryStarting(atValue: since1970).observeSingleEvent(of: .value) { (snapshot) in
                for users in snapshot.children.allObjects as![FirebaseDatabase.DataSnapshot] {
                    
                    let friendsid = users.key
                                    
                    ref.child("Users").child(friendsid).observeSingleEvent(of: .value) { (snapshot) in
                        
                        let userObjects = snapshot.value as? [String: AnyObject]
                        let username = userObjects?["username"] as! String
                        let status = userObjects?["online"]  as? String ?? ""
                        
                        let timestring = userObjects?["online"] as? TimeInterval ?? 0
                        
                        let image = userObjects?["profileimage"] as? String ?? ""
    
                        let key = snapshot.key
                    
                        let MessageUsers = UserData1(image: image, text: username, Activity: status, id: key, timeAgo: timestring)
                        
                        DispatchQueue.main.async {
                            self.messageList.insert(MessageUsers, at: 0)
                            self.tableview.reloadData()
                        }
                    }
                    
                }
        }
    }
    
    func configureTableView()
    {
        view.addSubview(tableview)
        tableview.rowHeight = 60
        tableview.separatorStyle = .none
        
        tableview.anchor(top: view.topAnchor, width: view.width, height: view.height)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellid, for: indexPath) as! MessageCell
        
        let items = messageList[indexPath.row]
        
        cell.NameLabel.text = items.text
            
        let id = items.id
        let ref = Database.database().reference()
        let Auth = FirebaseAuth.Auth.auth().currentUser!.uid
        
        let status = items.Activity
                
        ref.child("Users").child(id).observe(.value) { (snapshot) in
            if snapshot.exists()
            {
                let userObj = snapshot.value as! [String: AnyObject]
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
                                        cell.profileImageView.image = UIImage(systemName: "person.fill")?.withRenderingMode(.alwaysOriginal)
                                           print("Something is wrong with the image data")
                                       }

                                   }).resume()
                }
                if snapshot.hasChild("online")
                {
                    let onlinestatus = userObj["online"] as? String ?? ""
                    if onlinestatus == "Online"
                    {
                        cell.OnlineLabel.text = onlinestatus
                    }else if onlinestatus == "Texting"{
                        
                        cell.OnlineLabel.text = "Is Typing..."
                    }else {
                        let text = userObj["online"] as? TimeInterval

                        let date = Date(timeIntervalSince1970: text! / 1000)
                        let timeAgo = timeAgoSince(date)

                        cell.OnlineLabel.text = timeAgo
                    }
                }
            }
        }
        
        ref.child("Message").child(Auth).child(id).observe(.value) { (snapshot) in
            if snapshot.exists()
            {
                let userObj = snapshot.value as! [String: AnyObject]
                
                if snapshot.hasChild("Text")
                {
                    let text = userObj["Text"] as! String
                    cell.TextLabel.text = text
                    
                }
                if snapshot.hasChild("timestamp")
                {
                    let text = userObj["timestamp"] as! TimeInterval
                    
                    let date = Date(timeIntervalSince1970: text / 1000)
                    let timeAgo = timeAgoSince(date)
                    
                    cell.TextAgoLabel.text = timeAgo
                }
            }
        }
       
        ref.child("Unread").child(Auth).child(id).observe(.value) { (snapshot) in
            if snapshot.exists(){
                let count: Int = Int(snapshot.childrenCount)
            
                cell.UnreadLabel.text = String(count)
            }
            
        }
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(messageOption(sender:)))
        cell.contentView.addGestureRecognizer(recognizer)
        
        return cell
    }
    private func configureNavigationBar()
    {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.fill.badge.plus"), style: .done, target: self, action: #selector(didTap))
    }
    @objc func didTap()
    {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "FriendsList", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "FriendsList") as! FriendsList
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let items = messageList[indexPath.row]
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Chat", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "Chat") as! Chat
        newViewController.friendID = items.id
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    @objc func messageOption(sender: UILongPressGestureRecognizer)
    {
        let touch = sender.location(in: tableview)
        if let indexPath = tableview.indexPathForRow(at: touch) {
            let items = messageList[indexPath.row]
            let id = items.id
            let auth = FirebaseAuth.Auth.auth().currentUser!.uid
            let ref = Database.database().reference()
            
            let alert = UIAlertController(title: "Clear Chat", message: "Are you sure you want to delete all previous messages?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {(action:UIAlertAction!) in
                ref.child("Chats").child(id).child(auth).removeValue()
                ref.child("Users").child(auth).child(id).removeValue()
                
                self.tableview.reloadData()
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            self.present(alert, animated: true)
            
        }
    }
}
