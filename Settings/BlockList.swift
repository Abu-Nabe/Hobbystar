//
//  BlockList.swift
//  Zinging
//
//  Created by Abu Nabe on 25/1/21.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class BlockList: UIViewController
{
    
    var blockdata: [UserData] = [UserData]()
    let cellid = "blockid"
    let tableView: UITableView =
    {
        let tableview = UITableView()
        
        return tableview
    }()
    
    private let imageview: UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(systemName: "person.fill.xmark")
        imageview.contentMode = UIView.ContentMode.scaleAspectFit
        
        return imageview
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "You don't have anyone blocked!"
        label.font = .systemFont(ofSize: 16, weight : .semibold)
        
        return label
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        
        configureTableView()
        configureData()
        self.edgesForExtendedLayout = []
        
        imageview.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        imageview.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageview.anchor(width: 90, height: 90)
        
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.anchor(top: imageview.bottomAnchor, paddingTop: 10)
    }
    func configureTableView()
    {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.anchor(width: view.width, height: view.height)
        tableView.register(SearchCell.self, forCellReuseIdentifier: cellid)
    }
    
    func configureData()
    {
        let ref = Database.database().reference()
        let Auth = FirebaseAuth.Auth.auth().currentUser!.uid
        ref.child("Block").child(Auth).observe(.value) { (snapshot) in
            for users in snapshot.children.allObjects as![FirebaseDatabase.DataSnapshot] {
                
                let blockid = users.key
                
                ref.child("Users").child(blockid).observeSingleEvent(of: .value) { (snapshot) in
                    
                    let userObjects = snapshot.value as? [String: AnyObject]
                    let username = userObjects?["username"]
                    let status = userObjects?["hobbyname"]  as? String ?? ""

                    let image = userObjects?["profileimage"] as? String ?? ""

                    let key = snapshot.key
            
                    let MessageUsers = UserData(image: image, text: username as! String, Activity: status , id: key)

                    self.blockdata.append(MessageUsers)
                    self.tableView.reloadData()
                }
            }
        }
    }
}

extension BlockList: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blockdata.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellid, for: indexPath) as! SearchCell
        
        let items = blockdata[indexPath.row]
        
        cell.NameLabel.text = items.text
        cell.HobbyLabel.text = items.Activity as! String
            
        let id = items.id
        let ref = Database.database().reference()
        
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
                }else {
                    cell.profileImageView.image = UIImage.init(systemName: "person.fill")
                }
            }
        }
       
        return cell
    }
    
    
}
