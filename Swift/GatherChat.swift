//
//  GatherChat.swift
//  Zinging
//
//  Created by Abu Nabe on 25/2/21.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class GatherChat: UIViewController
{
    
    let ref = Database.database().reference()
    let Auth = FirebaseAuth.Auth.auth().currentUser!.uid
    let cellid = "GatherChat"
    
    struct getKey{
        var key: String
    }
    
    var gatherList: [getKey] = [getKey]()
    
    
    var GatherLabel: UILabel = {
        let Label = UILabel()
        Label.textAlignment = .center
        Label.text = "Gather"
        Label.textColor = .black
        Label.font = .boldSystemFont(ofSize: 16)
        return Label
    }()
    
    var nameLabel: UILabel = {
        let Label = UILabel()
        Label.textAlignment = .center
        Label.text = "username"
        Label.font = .boldSystemFont(ofSize: 12)
        return Label
    }()
    
    let Blackline: UIView = {
        let Label = UIView()
        Label.backgroundColor = .black
        return Label
    }()
    
    let Blackline1: UIView = {
        let Label = UIView()
        Label.backgroundColor = .black
        return Label
    }()
    
    var View = UIView()
    
    
    let GathersLabel: UILabel = {
        let Label = UILabel()
        Label.textAlignment = .center
        Label.text = "Gatherers"
        Label.font = .boldSystemFont(ofSize: 16)
        return Label
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(GatherLabel)
        view.addSubview(GathersLabel)
        view.addSubview(Blackline)
        view.addSubview(Blackline1)
        view.addSubview(nameLabel)
        view.addSubview(tableView)
        view.addSubview(View)
        
        self.edgesForExtendedLayout = []
        
        self.navigationItem.hidesBackButton = true
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = false
        
        configureData()
        configureGatherData()
        configureTableView()
        
        gatherList.removeAll()
        
        View.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: Blackline.topAnchor, right: view.rightAnchor)
        
        GatherLabel.anchor(top: view.topAnchor, left: view.leftAnchor, paddingLeft: 2)
        nameLabel.anchor(top: GatherLabel.bottomAnchor, left: view.leftAnchor, paddingLeft: 2)
        Blackline.anchor(top: nameLabel.bottomAnchor, width: view.width, height: 1)
        GathersLabel.anchor(top: Blackline.bottomAnchor, width: view.width)
        Blackline1.anchor(top: GathersLabel.bottomAnchor, width: view.width, height: 1)
        
        tableView.anchor(top: Blackline1.bottomAnchor, width: view.width, height: view.height)
        
        let GatherTap = UITapGestureRecognizer(target: self, action: #selector(GoChat))
        GatherTap.numberOfTapsRequired = 1
        View.isUserInteractionEnabled = true
        View.addGestureRecognizer(GatherTap)
        
    }
    
    @objc func GoChat()
    {
        let storyBoard: UIStoryboard = UIStoryboard(name: "GatherMessage", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "GatherMessage") as! GatherMessage
        newViewController.friendID = Auth
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    func configureData()
    {
        ref.child("Users").child(Auth).observe(.value) { (snapshot) in
            let userObj = snapshot.value as! [String: AnyObject]
            
            let name = userObj["username"] as! String
            self.nameLabel.text = name
            
            if snapshot.hasChild("gathername")
            {
                let gathername = userObj["gathername"] as! String
                self.GatherLabel.text = gathername
            }
            if snapshot.hasChild("gatherername")
            {
                let gathername = userObj["gatherername"] as! String
                self.GathersLabel.text = gathername
            }
        }
    }
    
    func configureTableView()
    {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.register(GatherItemCell.self, forCellReuseIdentifier: cellid)
    }
    
    func configureGatherData()
    {
        ref.child("Gather").child(Auth).observe(.value) { [self] (snapshot) in
            for users in snapshot.children.allObjects as![FirebaseDatabase.DataSnapshot] {
                let key = users.key
                
                let List = getKey(key: key)
                
                gatherList.append(List)
                self.tableView.reloadData()
            }
            
        }
    }
}

extension GatherChat: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gatherList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellid, for: indexPath) as! GatherItemCell
        
        let items = gatherList[indexPath.row]
        
        let id = items.key
        
        ref.child("Users").child(id).observe(.value) { [self] (snapshot) in
            let userObj = snapshot.value as! [String: AnyObject]
            
            let name = userObj["username"] as! String
            cell.NameLabel.text = name
            
            if snapshot.hasChild("profileimage")
            {
                let image = userObj["profileimage"] as! String
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
            
            let declineTap = UITapGestureRecognizer(target: self, action: #selector(declineRequest(sender:)))
            declineTap.numberOfTapsRequired = 1
            cell.removeButton.isUserInteractionEnabled = true
            cell.removeButton.addGestureRecognizer(declineTap)
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(GoToProfile(sender:)))
            tap.numberOfTapsRequired = 1
            cell.NameLabel.isUserInteractionEnabled = true
            cell.NameLabel.addGestureRecognizer(tap)
            
            let tap1 = UITapGestureRecognizer(target: self, action: #selector(GoToProfile(sender:)))
            tap1.numberOfTapsRequired = 1
            cell.HobbyLabel.isUserInteractionEnabled = true
            cell.HobbyLabel.addGestureRecognizer(tap1)
            
        }
        return cell
    }
    
    @objc func declineRequest(sender: UITapGestureRecognizer)
    {
        let alert = UIAlertController(title: "Are you sure you want to remove this user?", message: "Select", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { [self](action:UIAlertAction!) in
            let touch = sender.location(in: self.tableView)
            if self.gatherList != nil{
                if let indexPath = self.tableView.indexPathForRow(at: touch) {
                    let items = self.gatherList[indexPath.row]
                    let id = items.key
                    
                    ref.child("Gather").child(Auth).child(id).removeValue()
                    
                    self.gatherList.removeAll()
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
            if self.gatherList != nil{
            let items = gatherList[indexPath.row]
            let id = items.key
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "AddProfile", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "AddProfile") as! AddProfile
            newViewController.Userid = id
            self.navigationController?.pushViewController(newViewController, animated: true)
            }
        }
    }
    
    
}
