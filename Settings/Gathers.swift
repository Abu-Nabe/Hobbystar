//
//  Gathers.swift
//  Zinging
//
//  Created by Abu Nabe on 25/1/21.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class Gathers: UIViewController
{
    
    let cellid = "GathersID"
    var gathedata: [UserData] = [UserData]()
    let gatherLabel: UILabel =
    {
        let label = UILabel()
        label.text = "Gathers"
        
        return label
    }()
    
    let line: UIView =
    {
        let line = UIView()
        
        return line
    }()
    
    let tableview: UITableView =
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
        label.text = "You don't have anyone added in your gather :("
        label.font = .systemFont(ofSize: 16, weight : .semibold)
        
        return label
    }()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(gatherLabel)
        view.addSubview(line)
        view.addSubview(tableview)
        view.addSubview(label)
        view.addSubview(imageview)
        
        self.edgesForExtendedLayout = []
        
        gatherLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        gatherLabel.anchor(top: view.topAnchor)
        
        imageview.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        imageview.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageview.anchor(width: 90, height: 90)
        
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.anchor(top: imageview.bottomAnchor, paddingTop: 10)
        
        configureTableView()
        configureData()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        line.frame = CGRect(x: 0, y: gatherLabel.frame.origin.y+gatherLabel.frame.size.height
                            , width: view.width/2-gatherLabel.width/2, height: 1)
    }
    
    func configureTableView()
    {
        tableview.anchor(top: line.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(PersonalGather.self, forCellReuseIdentifier: cellid)
        tableview.separatorStyle = .none
    }
    
    func configureData()
    {
        let ref = Database.database().reference()
        
        let Auth = FirebaseAuth.Auth.auth().currentUser?.uid
        
        
        ref.child("PersonalGather").child(Auth!).observe(.value) { (snapshot) in
            for users in snapshot.children.allObjects as![FirebaseDatabase.DataSnapshot] {
                let key = users.key
                
                ref.child("Users").child(key).observe(.value) { (snapshot) in
                    let data = snapshot.value as! [String: AnyObject]
                    
                    let username = data["username"] as! String
                    
                    let gathername = data["gathername"] as? String ?? "Gather"
                    
                    let image = data["profileimage"] as? String ?? ""
                    
                    let data1 = UserData(image: image, text: username, Activity: gathername, id: key)
                    
                    self.gathedata.append(data1)
                    
                    if !self.gathedata.isEmpty
                    {
                        self.label.isHidden = true
                        self.imageview.isHidden = true
                    }
                    
                    self.tableview.reloadData()
                }
            }
        }
    }

    
}
extension Gathers: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gathedata.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: cellid, for: indexPath) as! PersonalGather
        
        let items = gathedata[indexPath.row]
        
        cell.HobbyLabel.text = items.text
        cell.NameLabel.text = items.Activity as! String
        
        return cell
    }
    
    
}
