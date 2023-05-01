//
//  GatherFriendList.swift
//  Zinging
//
//  Created by Abu Nabe on 29/1/21.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class GatherFriendList: UIViewController
{
    var gatherData: [UserData] = [UserData]()
    let cellid = "gatherid"
    
    let label: UILabel =
    {
        let label = UILabel()
        label.text = "Gather Requests"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black
        
        return label
    }()
    
    let tableView: UITableView =
    {
        let tableview = UITableView()
        
        return tableview
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(label)
        view.addSubview(tableView)
        
        configureData()
        
        self.navigationItem.hidesBackButton = false
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = false
        
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.anchor(top: view.topAnchor)
        tableView.anchor(top: label.bottomAnchor, width: view.width, height: view.height)
        tableView.register(GatherRequestsCell.self, forCellReuseIdentifier: cellid)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        
    }
    
    func configureData()
    {
        let ref = Database.database().reference()
        let Auth = FirebaseAuth.Auth.auth().currentUser!.uid
        
        ref.child("GatherRequest").child(Auth).observe(.value) { (snapshot) in
            for pics in snapshot.children.allObjects as![FirebaseDatabase.DataSnapshot] {
                let key = pics.key
                ref.child("Users").child(key).observe(.value) { (snapshot) in
                    
                    let Objects = snapshot.value as? [String: AnyObject]
                    
                    let picimage = Objects?["profileimage"] as? String ?? ""
                    let picpublisher = Objects?["hobbyname"] as? String ?? ""
                    let username = Objects?["username"] as! String
                    
                    let picList = UserData(image: picimage, text: username, Activity: picpublisher, id: key)
                
                   
                    self.gatherData.append(picList)
    
                
                    self.tableView.reloadData()
    
                }
            }
        }
    }
}

extension GatherFriendList: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gatherData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellid,for: indexPath) as! GatherRequestsCell
        let items = gatherData[indexPath.row]
        
        cell.NameLabel.text = items.text
        let ref = Database.database().reference()
        let id = items.id
        
        cell.contentView.isUserInteractionEnabled = false
        
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
                }else {
                    cell.profileImageView.image = UIImage.init(systemName: "person.fill")
                }
                if snapshot.hasChild("hobbyname")
                {
                    cell.HobbyLabel.text = items.Activity as! String
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
        
        let acceptTap = UITapGestureRecognizer(target: self, action: #selector(AcceptRequest(sender:)))
            acceptTap.numberOfTapsRequired = 1
            cell.Acceptbutton.isUserInteractionEnabled = true
            cell.Acceptbutton.addGestureRecognizer(acceptTap)
        
        let declineTap = UITapGestureRecognizer(target: self, action: #selector(declineRequest(sender:)))
            declineTap.numberOfTapsRequired = 1
            cell.DeclineButton.isUserInteractionEnabled = true
            cell.DeclineButton.addGestureRecognizer(declineTap)
        
        return cell
        
    }
    
    @objc func AcceptRequest(sender: UITapGestureRecognizer)
    {
        let ref = Database.database().reference()
        let Auth = FirebaseAuth.Auth.auth().currentUser!.uid
        let touch = sender.location(in: tableView)
        if let indexPath = tableView.indexPathForRow(at: touch) {
            if indexPath != nil{
            let items = gatherData[indexPath.row]
            let id = items.id
            
            ref.child("GatherRequest").child(Auth).child(id).removeValue()
            ref.child("GatherRequest").child(id).child(Auth).removeValue()
            
            ref.child("Gather").child(Auth).child(id).child("Gather").setValue("Saved")
            
                gatherData.removeAll()
                self.tableView.reloadData()
            }
        }
    }
    
    @objc func declineRequest(sender: UITapGestureRecognizer)
    {
        let ref = Database.database().reference()
        let Auth = FirebaseAuth.Auth.auth().currentUser!.uid
        let alert = UIAlertController(title: "Are you sure you want to cancel request?", message: "Select", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: {(action:UIAlertAction!) in
            let touch = sender.location(in: self.tableView)
            if let indexPath = self.tableView.indexPathForRow(at: touch) {
                if self.gatherData != nil{
                let items = self.gatherData[indexPath.row]
                let id = items.id
                
                ref.child("GatherRequest").child(Auth).child(id).removeValue()
                ref.child("GatherRequest").child(id).child(Auth).removeValue()
            
                self.gatherData.removeAll()
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    @objc func GoToProfile(sender: UITapGestureRecognizer)
    {
        let touch = sender.location(in: tableView)
        if let indexPath = tableView.indexPathForRow(at: touch) {
            if self.gatherData != nil{
            let items = gatherData[indexPath.row]
            let id = items.id
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "AddProfile", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "AddProfile") as! AddProfile
            newViewController.Userid = id
            self.navigationController?.pushViewController(newViewController, animated: true)
            }
        }
    }
}
