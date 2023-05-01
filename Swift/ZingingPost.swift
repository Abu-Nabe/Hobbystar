//
//  ZingingPost.swift
//  Zinging
//
//  Created by Abu Nabe on 9/2/21.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class ZingingPost: UIViewController{
    
    var postid: String!
    
    var postdata: [AllPostData] = [AllPostData]()
    
    
    let tableView: UITableView =
    {
        let tableview = UITableView()
            
        return tableview
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        
        self.navigationItem.hidesBackButton = false
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = false
        
        configureTableView()
        configureData()
    }
    func configureTableView()
    {
        
        tableView.register(ZingingPostCell.self, forCellReuseIdentifier: "Cell")
        tableView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        
        tableView.rowHeight = view.height
        tableView.showsVerticalScrollIndicator = true
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    func configureData()
    {
        let ref = Database.database().reference()
        
        ref.child("Pics").child(postid).observe(.value) { (snapshot) in
            let postlist = AllPostData(snapshot: snapshot)
            
            self.postdata.append(postlist)
        
            self.tableView.reloadData()
        }
    }
}

extension ZingingPost: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postdata.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",for: indexPath) as! ZingingPostCell
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
        
        
        
        let date = Date(timeIntervalSince1970: items.timestamp / 1000)
        let timeAgo = timeAgoSince(date)
        
        cell.TimeLabel.text = timeAgo
        
        
        ref.child("Rates").child(postString).child(Auth).observe(.value) { (snapshot) in
            if snapshot.exists()
            {
                cell.Liked = "Yes"
                cell.starView.image = UIImage(systemName: "star.fill")
            }else {
                cell.Liked = "No"
                cell.starView.image = UIImage(systemName: "star")
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
        
        let commentTap = UITapGestureRecognizer(target: self, action: #selector(GoToComments(sender:)))
        commentTap.numberOfTapsRequired = 1
        cell.Comments.isUserInteractionEnabled = true
        cell.Comments.addGestureRecognizer(commentTap)
        
        
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
        
        ref.child("Users").child(items.publisher).child("points").observe(.value) { (snapshot) in
            if snapshot.exists()
            {
                let pointcount: Int = Int(snapshot.childrenCount)
                
                cell.CurrentPointsLabel.text = String(pointcount)
            }
        }
        
        ref.child("Rates").child(postString).observe(.value) { (snapshot) in
            if snapshot.exists()
            {
                let pointcount: Int = Int(snapshot.childrenCount)
                
                cell.PointsLabel.text = String(pointcount)
            }
        }
        return cell
    }
    
    @objc func ExpandImage(sender: UITapGestureRecognizer)
    {
        print("yea")
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
    
    @objc func GoToComments(sender: UITapGestureRecognizer)
    {
        let touch = sender.location(in: tableView)
        if let indexPath = tableView.indexPathForRow(at: touch) {
            let items = postdata[indexPath.row]
            let id = items.timestring
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "CommentPost", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "CommentPost") as! CommentPost
            newViewController.PostID = id
            self.navigationController?.pushViewController(newViewController, animated: true)
        }
    }
}
