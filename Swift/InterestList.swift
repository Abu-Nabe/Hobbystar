//
//  InterestList.swift
//  Zinging
//
//  Created by Abu Nabe on 11/2/21.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class InterestList: UIViewController {
    
    var friendData: [UserData] = [UserData]()
    let cellid = "cell"
    private let tableview: UITableView =
        {
            let tableview = UITableView()
            
            return tableview
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableview)
        
        friendData.removeAll()
        
        self.navigationItem.hidesBackButton = false
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = false
        
        self.edgesForExtendedLayout = []
        tableview.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        
        configureTableView()
        configureData()
    }
    
    func configureTableView()
    {
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(InterestListCell.self, forCellReuseIdentifier: cellid)
        tableview.rowHeight = 60
    }
    
    func configureData()
    {
        let ref = Database.database().reference()
        let Auth = FirebaseAuth.Auth.auth().currentUser!.uid
        ref.child("Interest").child(Auth).observe(.value) { (snapshot) in
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
}


extension InterestList: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: cellid,for: indexPath) as! InterestListCell
        
        let items = friendData[indexPath.row]
        
        cell.NameLabel.text = items.text
        let ref = Database.database().reference()
        let id = items.id
        
        cell.interestID = id
        
    
        
        let buttonTap = UITapGestureRecognizer(target: self, action: #selector(Uninterest(sender:)))
            buttonTap.numberOfTapsRequired = 1
        cell.Button.isUserInteractionEnabled = true
        cell.Button.addGestureRecognizer(buttonTap)
        
            
        cell.contentView.isUserInteractionEnabled = false
        
        let Auth = FirebaseAuth.Auth.auth().currentUser!.uid
        ref.child("Interest").child(Auth).child(id).observe(.value) { (snapshot) in
            if snapshot.exists()
            {
                cell.Button.setTitle("Interested", for: .normal)
            }else {
                cell.Button.setTitle("Interest", for: .normal)
            }
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
    @objc func Uninterest(sender: UITapGestureRecognizer)
    {
        let touch = sender.location(in: tableview)
        if let indexPath = tableview.indexPathForRow(at: touch) {
            let cell = tableview.dequeueReusableCell(withIdentifier: cellid) as! InterestListCell
            if !friendData.isEmpty
            {
            let items = friendData[indexPath.row]
            let id = items.id
            
            let ref = Database.database().reference()
            let Auth = FirebaseAuth.Auth.auth().currentUser!.uid
            
            ref.child("Interest").child(Auth).child(id).observe(.value) { (snapshot) in
                if snapshot.exists()
                {
                    cell.type = "Yes"
                }else {
                    cell.type = "No"
                }
            }
            
            if cell.type == "Yes"
            {
                let alert = UIAlertController(title: "Are you sure you want to Uninterest this person?", message: "Select", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: {(action:UIAlertAction!) in
                    ref.child("Interest").child(Auth).child(id).removeValue()
                    cell.Button.setTitle("Interest", for: .normal)
                    self.friendData.removeAll()
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                
                self.present(alert, animated: true)
            }else {
                ref.child("Interest").child(Auth).child(id).setValue(true)
                cell.Button.setTitle("Interested", for: .normal)
                friendData.removeAll()
            }
          }
        }
    }
}

