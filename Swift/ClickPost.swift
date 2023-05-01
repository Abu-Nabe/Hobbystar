//
//  ClickPost.swift
//  Zinging
//
//  Created by Abu Nabe on 9/2/21.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class ClickPost: UIViewController{
    
    var postid: String!
    
    var postdata: [PostData] = [PostData]()
    
    
    let tableView: UITableView =
    {
        let tableview = UITableView()
            
        return tableview
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        
        configureTableView()
        configureData()
        
        self.navigationItem.hidesBackButton = false
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = false
    }
    func configureTableView()
    {
        
        tableView.register(HomePostCell.self, forCellReuseIdentifier: "Cell")
        tableView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        
        tableView.rowHeight = view.height
        tableView.showsVerticalScrollIndicator = true
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    func configureData()
    {
        let ref = Database.database().reference()
        
        ref.child("PostNotifications").child(postid).observe(.value) { (snapshot) in
            let postObjects = snapshot.value as? [String: AnyObject]
            
            let postimage = postObjects?["post"] as! String
            let publisher = postObjects?["publisher"] as! String
            let timestamp = postObjects?["timestamp"] as! TimeInterval
            let timestring = postObjects?["timestring"] as! String
            
            
            let postList = PostData(postimage: postimage, publisher: publisher, timestring: timestring, timestamp: timestamp)
            
            self.postdata.append(postList)
        
            self.tableView.reloadData()
        }
    }
}

extension ClickPost: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postdata.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",for: indexPath) as! HomePostCell
        let items = postdata[indexPath.row]
        
        let picture = items.postimage
        let postString = items.timestring
        let url = URL(string: picture)
        
        cell.contentView.isUserInteractionEnabled = false
        
        cell.postPublisher = items.publisher
        
        cell.postID = self.postdata[indexPath.row].timestring
        
        cell.profileImageView.tag = indexPath.row
        
        let ref = Database.database().reference()
        let Auth = FirebaseAuth.Auth.auth().currentUser!.uid
        
        ref.child("Rates").child(postString).child(Auth).observe(.value) { (snapshot) in
            if snapshot.exists()
            {
                cell.Liked = "Yes"
                cell.LikeImage.image = UIImage(systemName: "face.smiling.fill")
            }else {
                cell.Liked = "No"
                cell.LikeImage.image = UIImage(systemName: "face.smiling")
            }
        }
        
        ref.child("Dislike").child(postString).child(Auth).observe(.value) { (snapshot) in
            if snapshot.exists()
            {
                cell.Disliked = "Yes"
                cell.DislikeImage.backgroundColor = .red
            }else {
                cell.Disliked = "No"
                cell.DislikeImage.backgroundColor = .none
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
        
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(ExpandImage(sender:)))
        imageTap.numberOfTapsRequired = 1
        cell.PictureView.isUserInteractionEnabled = true
        cell.PictureView.addGestureRecognizer(imageTap)
        
        let linkTap = UITapGestureRecognizer(target: self, action: #selector(GoToLink(sender:)))
        linkTap.numberOfTapsRequired = 1
        cell.LinkButton.isUserInteractionEnabled = true
        cell.LinkButton.addGestureRecognizer(linkTap)
        
        
        let optionTap = UITapGestureRecognizer(target: self, action: #selector(ImageOption(sender:)))
        optionTap.numberOfTapsRequired = 1
        cell.OptionImage.isUserInteractionEnabled = true
        cell.OptionImage.addGestureRecognizer(optionTap)
        
        
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            
            if let error = error {
                print("There was an error fetching the image from the url: \n", error)
            }
            
            if let data = data, let profilePicture = UIImage(data: data) {
                DispatchQueue.main.async() {
                    cell.PictureView.image = profilePicture // Set the profile picture
                }
            } else {
                print("Something is wrong with the image data")
            }
            
        }).resume()
        
        ref.child("Users").child(items.publisher).observe(.value) { (snapshot) in
            let postObjects = snapshot.value as? [String: AnyObject]
            let username = postObjects?["username"] as? String ?? ""
            cell.NameLabel.text = username
            
            
            if snapshot.hasChild("profileimage")
            {
                let image = postObjects?["profileimage"] as! String
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
        
        return cell
    }
    
    @objc func GoToProfile(sender: UITapGestureRecognizer)
    {
        let touch = sender.location(in: tableView)
        if let indexPath = tableView.indexPathForRow(at: touch) {
            let items = postdata[indexPath.row]
            let id = items.publisher
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "AddProfile", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "AddProfile") as! AddProfile
            newViewController.Userid = id
            self.navigationController?.pushViewController(newViewController, animated: true)
        }
    }
    @objc func GoToLink(sender: UITapGestureRecognizer)
    {
        let touch = sender.location(in: tableView)
        if let indexPath = tableView.indexPathForRow(at: touch) {
            let items = postdata[indexPath.row]
            let id = items.publisher
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "PersonalLinks", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "PersonalLinks") as! PersonalLinks
            newViewController.Userid = id
            self.navigationController?.present(newViewController, animated: true)
        }
    }
    @objc func ExpandImage(sender: UITapGestureRecognizer)
    {
        let touch = sender.location(in: tableView)
        if let indexPath = tableView.indexPathForRow(at: touch) {
            let items = postdata[indexPath.row]
            
            let image = items.postimage
            let storyBoard: UIStoryboard = UIStoryboard(name: "PictureOnClick", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "PictureOnClick") as! PictureOnClick
            newViewController.PictureString = image
            newViewController.modalPresentationStyle = .fullScreen
            self.present(newViewController, animated: false)
        }
    }
    

    @objc func ImageOption(sender: UITapGestureRecognizer)
    {
        
            let touch = sender.location(in: tableView)
            let ref = Database.database().reference()
        
        if !postdata.isEmpty {
            if let indexPath = tableView.indexPathForRow(at: touch) {
                let items = postdata[indexPath.row]
                    let auth = FirebaseAuth.Auth.auth().currentUser!.uid
                    if items.publisher == auth{
              
                let alert = UIAlertController(title: "Delete this post", message: "Are you sure you want to delete this post?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {(action:UIAlertAction!) in
                    ref.child("Posts").child(items.timestring).removeValue()
                    ref.child("Users").child(items.publisher).child("post").child(items.timestring).removeValue()
                    ref.child("PostNotifications").child(items.timestring).removeValue()
                    self.tableView.reloadData()
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                
                self.present(alert, animated: true)
                }else {
                    let alert = UIAlertController(title: "Report Post", message: "Are you sure you want to report this post?", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Report", style: .destructive, handler: {(action:UIAlertAction!) in
                        ref.child("Report").child(items.publisher).child(items.timestring).setValue("reported")
                    }))
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    
                    self.present(alert, animated: true)
                }
            }
        }
    }
}
