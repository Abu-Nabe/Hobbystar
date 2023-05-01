//
//  AllPostsZinging.swift
//  Zinging
//
//  Created by Abu Nabe on 25/1/21.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class AllPostsZinging: UIViewController
{
    var picdata: [AllPostData] = [AllPostData]()
    let ChooseLabel: UILabel = {
        let label = UILabel()
        label.text = "Category"
        
        return label
    }()
    
    let line: UIView = {
        let line = UIView()
        
        return line
    }()
    
    let tableView: UITableView =
    {
        let tableview = UITableView()
            
        return tableview
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(ChooseLabel)
        view.addSubview(line)
        view.addSubview(tableView)
        
        self.edgesForExtendedLayout = []
        
        self.navigationItem.hidesBackButton = false
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = false
        
        configureTableView()
        configureData()
        listenDeletes()
        picdata.removeAll()
        
        ChooseLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        line.frame = CGRect(x: view.width/2-ChooseLabel.width/2, y: ChooseLabel.frame.origin.y+ChooseLabel.frame.size.height, width: ChooseLabel.width, height: 1)
        
    }
    
    func configureTableView()
    {
        
        tableView.register(ZingingPostCell.self, forCellReuseIdentifier: "Cell")
        tableView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        
        tableView.rowHeight = 450
        tableView.showsVerticalScrollIndicator = true
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func configureData()
    {
        let ref = Database.database().reference()
        
        ref.child("Pics").observe(.value) { (snapshot) in
            for pics in snapshot.children.allObjects as![FirebaseDatabase.DataSnapshot] {
                let picid = pics.key
                
                ref.child("Pics").child(picid).observeSingleEvent(of: .value) { (snapshot) in
                    let postList = AllPostData(snapshot: pics)
               
                    self.picdata.insert(postList, at: 0 )
                
                    self.tableView.reloadData()
                    
                }
            }
        }
    }
    
    func listenDeletes() {
        
       let ref = Database.database().reference().child("Pics")

        ref.observe(.value) { (snapshot) in
            for posts in snapshot.children.allObjects as![FirebaseDatabase.DataSnapshot] {
                let key = posts.key
                ref.child(key).observe(.childRemoved, with: { [self] postSnapshot in
                    if let index = self.picdata.firstIndex(where: {$0.timestring == key}) {

                        self.picdata.remove(at: index)
                        print("Wtf?")
                        self.tableView.deleteRows(at: [IndexPath(item: index, section: 0)], with: .none)
                        
                        self.picdata.removeAll()
                 }
               })
            }
        }
    }
    
}

extension AllPostsZinging: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return picdata.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",for: indexPath) as! ZingingPostCell
        let items = picdata[indexPath.row]
        
        let ref = Database.database().reference()
        
        let id = items.publisher
        let timestamp = items.timestamp
        cell.postPublisher = id
        
        cell.contentView.isUserInteractionEnabled = false
        
        let date = Date(timeIntervalSince1970: timestamp / 1000)
        let timeAgo = timeAgoSince(date)
        
        cell.TimeLabel.text = timeAgo
        
        ref.child("Users").child(id).observe(.value) { (snapshot) in
            let postObjects = snapshot.value as? [String: AnyObject]
            
            let name = postObjects?["username"] as! String
            cell.NameLabel.text = name
            
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
                        cell.profileImageView.image = UIImage(systemName: "person.fill")?.withRenderingMode(.alwaysOriginal)
                        print("Something is wrong with the image data")
                    }
                    
                }).resume()
            }
            
            if snapshot.hasChild("hobbyname")
            {
                let hobby = postObjects?["hobbyname"] as! String
                cell.HobbyLabel.text = hobby
            }
            
            ref.child("Users").child(items.publisher).child("points").observe(.value) { (snapshot) in
                if snapshot.exists()
                {
                    let pointcount: Int = Int(snapshot.childrenCount)
                    
                    cell.CurrentPointsLabel.text = String(pointcount)
                }
            }
        }
        
        let postString = items.postid
        
        cell.postID = postString
        
        let Auth = FirebaseAuth.Auth.auth().currentUser!.uid
        
        ref.child("Rates").child(postString).child(Auth).observe(.value) { (snapshot) in
            if snapshot.exists()
            {
                cell.Liked = "Yes"
                cell.starView.image = UIImage(systemName: "star.fill")
                cell.starView.tintColor = .green
            }else {
                cell.Liked = "No"
                cell.starView.image = UIImage(systemName: "star")
                cell.starView.tintColor = .green
            }
        }
        
        
        ref.child("Rates").child(postString).observe(.value) { (snapshot) in
            if snapshot.exists()
            {
                let pointcount: Int = Int(snapshot.childrenCount)
                
                cell.PointsLabel.text = String(pointcount)
            }
        }
        
        cell.DescriptionLabel.text = items.description
        
        let picture = items.postimage
        let url = URL(string: picture)
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
        
        let optionTap = UITapGestureRecognizer(target: self, action: #selector(ImageOption(sender:)))
        optionTap.numberOfTapsRequired = 1
        cell.OptionImage.isUserInteractionEnabled = true
        cell.OptionImage.addGestureRecognizer(optionTap)
        
        return cell
    }
    
    @objc func ImageOption(sender: UITapGestureRecognizer)
    {
        
            let touch = sender.location(in: tableView)
            let ref = Database.database().reference()
        
        if !picdata.isEmpty {
            if let indexPath = tableView.indexPathForRow(at: touch) {
                let items = picdata[indexPath.row]
                    let auth = FirebaseAuth.Auth.auth().currentUser!.uid
                    if items.publisher == auth{
              
                let alert = UIAlertController(title: "Delete this post", message: "Are you sure you want to delete this post?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {(action:UIAlertAction!) in
                    ref.child("Pics").child(items.timestring).removeValue()
                    ref.child("Users").child(items.publisher).child("zingingpost").child(items.timestring).removeValue()
                    ref.child("ZingingPosts").child(items.timestring).removeValue()
                    ref.child("PostNotifications").child(items.timestring).removeValue()
                    self.picdata.removeAll()
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
        
    
    @objc func ExpandImage(sender: UITapGestureRecognizer)
    {
        print("yea")
        let touch = sender.location(in: tableView)
        if let indexPath = tableView.indexPathForRow(at: touch) {
            let items = picdata[indexPath.row]
            
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
            let items = picdata[indexPath.row]
            let id = items.publisher
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "AddProfile", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "AddProfile") as! AddProfile
            newViewController.Userid = id
            self.navigationController?.pushViewController(newViewController, animated: true)
        }
    }
    
    @objc func GoToComments(sender: UITapGestureRecognizer)
    {
        let touch = sender.location(in: tableView)
        if let indexPath = tableView.indexPathForRow(at: touch) {
            let items = picdata[indexPath.row]
            let id = items.timestring
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "CommentPost", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "CommentPost") as! CommentPost
            newViewController.PostID = id
            self.navigationController?.pushViewController(newViewController, animated: true)
        }
    }
    
}
