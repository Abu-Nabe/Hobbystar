//
//  GatherList.swift
//  Zinging
//
//  Created by Abu Nabe on 27/2/21.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class GatherList: UIViewController
{
    var GatherID: String!
    
    let cellid = "cellid"
    let ref = Database.database().reference()
    let Auth = FirebaseAuth.Auth.auth().currentUser!.uid
    
    struct getKey{
        var key: String
    }
    
    var gatherList: [getKey] = [getKey]()
    
    private let GatherLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Gather"
        label.font = .boldSystemFont(ofSize: 16)
        
        return label
    }()
    
    private let GathererLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Gatherer"
        label.font = .boldSystemFont(ofSize: 16)
        
        return label
    }()
    
    let BlackLine: UIView = {
        let Label = UIView()
        Label.backgroundColor = .green
        return Label
    }()
    
    let BlackLine1: UIView = {
        let Label = UIView()
        Label.backgroundColor = .green
        return Label
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(GatherLabel)
        view.addSubview(GathererLabel)
        view.addSubview(BlackLine)
        view.addSubview(BlackLine1)
        view.addSubview(tableView)
        
        self.edgesForExtendedLayout = []
        
        self.navigationItem.hidesBackButton = false
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = false
        
        configureData()
        configureTableView()
        configureGatherData()
    
        GatherLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        GatherLabel.anchor(top: view.topAnchor)
        BlackLine.anchor(top: GatherLabel.bottomAnchor, width: view.width, height: 1)
        GathererLabel.anchor(top: BlackLine.bottomAnchor, left: view.leftAnchor, paddingLeft: 2)
        BlackLine1.anchor(top: GathererLabel.bottomAnchor,width: view.width, height: 1)
        
        tableView.anchor(top: BlackLine1.bottomAnchor, width: view.width, height: view.height)
    }
    func configureData()
    {
        ref.child("Users").child(Auth).observe(.value) { (snapshot) in
            let userObj = snapshot.value as! [String: AnyObject]
            
            if snapshot.hasChild("gathername")
            {
                let gathername = userObj["gathername"] as! String
                self.GatherLabel.text = gathername
            }
            if snapshot.hasChild("gatherername")
            {
                let gathername = userObj["gatherername"] as! String
                self.GathererLabel.text = gathername
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
        ref.child("Gather").child(GatherID).observe(.value) { [self] (snapshot) in
            for users in snapshot.children.allObjects as![FirebaseDatabase.DataSnapshot] {
                let key = users.key
                
                let List = getKey(key: key)
                
                gatherList.append(List)
                self.tableView.reloadData()
            }
            
        }
    }
}

extension GatherList: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gatherList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellid, for: indexPath) as! GatherItemCell
        
        let items = gatherList[indexPath.row]
        
        let id = items.key
        
        cell.removeButton.isHidden = true
        
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
                
                if snapshot.hasChild("hobbyname")
                {
                    let name = userObj["hobbyname"] as! String
                    cell.HobbyLabel.text = name
                }
            }
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(GoToProfile(sender:)))
            tap.numberOfTapsRequired = 1
            cell.NameLabel.isUserInteractionEnabled = true
            cell.NameLabel.addGestureRecognizer(tap)
            
            let tap1 = UITapGestureRecognizer(target: self, action: #selector(GoToProfile(sender:)))
            tap1.numberOfTapsRequired = 1
            cell.profileImageView.isUserInteractionEnabled = true
            cell.profileImageView.addGestureRecognizer(tap1)
            
        }
        return cell
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
