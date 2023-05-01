
//
//  Comment.swift
//  Zinging
//
//  Created by Abu Nabe on 12/2/21.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class CommentPost: UIViewController
{
    
    var commentData: [CommentData] = [CommentData]()
    var CellID = "commentID"
    var PostID: String!
    
    let ref = Database.database().reference()
    let Auth = FirebaseAuth.Auth.auth().currentUser!.uid
    
    let profileImageView: UIImageView = {
        let profileimage = UIImageView()
        
        profileimage.contentMode = .scaleAspectFill
        profileimage.clipsToBounds = true
        profileimage.layer.borderWidth = 1
        profileimage.layer.borderColor = UIColor.black.cgColor
        profileimage.image = UIImage.init(systemName: "person.fill")
        profileimage.layer.cornerRadius = 30/2
        
        return profileimage
    }()
    
    private let TextField: UITextField = {
        let Field = UITextField()
        Field.placeholder = "Comment"
        Field.layer.borderWidth = 1
        Field.layer.borderColor = UIColor.black.cgColor
        Field.layer.cornerRadius = 16
        
        Field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: Field.frame.height))
        Field.leftViewMode = .always
        return Field
    }()
    
    let SendButton: UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage.init(systemName: "chevron.forward.circle.fill")
        
        return imageview
    }()
    
    
    let tableView: UITableView = {
        let tableView = UITableView()
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(profileImageView)
        view.addSubview(TextField)
        view.addSubview(SendButton)
        view.addSubview(tableView)
        

        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = true
        
        configureData()
        configureTableView()
        Placement()
        
        commentData.removeAll()
        
        let commentTap = UITapGestureRecognizer(target: self, action: #selector(sendComment))
        commentTap.numberOfTapsRequired = 1
        SendButton.isUserInteractionEnabled = true
        SendButton.addGestureRecognizer(commentTap)
    }
    
    func Placement()
    {
        TextField.anchor(left: profileImageView.rightAnchor,bottom: view.safeAreaLayoutGuide.bottomAnchor,right: SendButton.leftAnchor,height: 30)
        profileImageView.anchor(left: view.leftAnchor,bottom: view.safeAreaLayoutGuide.bottomAnchor, width: 30, height: 30)
        profileImageView.layer.cornerRadius = 30/2
        SendButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, width: 30, height: 30)
        
        tableView.anchor(top: view.topAnchor,bottom: TextField.topAnchor, width: view.width)
        
        ref.child("Users").child(Auth).observe(.value) { (snapshot) in
            if snapshot.exists()
            {
                let userObjects = snapshot.value as? [String: AnyObject]
                if snapshot.hasChild("profileimage")
                {
                    
                    let image = userObjects?["profileimage"]
                    let url = URL(string: image as! String)
                    URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                        
                        if let error = error {
                            print("There was an error fetching the image from the url: \n", error)
                        }
                        
                        if let data = data, let profilePicture = UIImage(data: data) {
                            DispatchQueue.main.async() {
                                self.profileImageView.image = profilePicture // Set the profile picture
                            }
                        } else {
                            print("Something is wrong with the image data")
                        }
                        
                    }).resume()
                }
                
            }
        }
    }
    
    func configureData()
    {
        ref.child("Comments").child(PostID).observe(.value) { [self] (snapshot) in
            if snapshot.exists(){
                for comments in snapshot.children.allObjects as![FirebaseDatabase.DataSnapshot] {
                    let key = comments.key
                self.ref.child("Comments").child(PostID).child(key).observeSingleEvent(of: .value) { (snapshot) in
                    let objDict = snapshot.value as? [String: AnyObject]
                    
                    let comment = objDict?["comment"] as! String
                    let publisher = objDict?["publisher"] as! String
                    let timestring = objDict?["timestring"] as! String
                    let timestamp = objDict?["timestamp"] as! Int
                    
                    let commentList = CommentData(comment: comment, publisher: publisher, timestring: timestring, timestamp: timestamp)
                    
                    self.commentData.append(commentList)
                    self.tableView.reloadData()
                }
              }
            }
        }
    }
    
    func configureTableView()
    {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CommentPostCell.self, forCellReuseIdentifier: CellID)
        tableView.rowHeight = 50
        tableView.separatorStyle = .none
    }
    
    @objc func sendComment()
    {
        let text = TextField.text
        
        if text == ""
        {
            self.showToast(message: "Comment is empty", font: .systemFont(ofSize: 12.0))
        }else {
            let date = Date() // current date
            let timestamp = date.toMilliseconds()
            
            let timestring = String(timestamp)
            
            let commentData1 = [
                "comment": text!,
                "publisher": Auth,
                "timestring": timestring,
                "timestamp": timestamp,
            ] as [String : Any]
            
            ref.child("Comments").child(PostID).child(timestring).setValue(commentData1)
            
            TextField.text = ""
        }
    }
    
    func showToast(message : String, font: UIFont) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.baselineAdjustment = .alignCenters;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}

extension CommentPost: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellID, for: indexPath) as! CommentPostCell
        
        let items = commentData[indexPath.row]
        
        cell.contentView.isUserInteractionEnabled = false
        
        cell.commentLabel.text = items.comment
        
        let commentString = items.timestring
        
        let date = Date(timeIntervalSince1970: TimeInterval(items.timestamp / 1000))
        let timeAgo = timeAgoSince(date)
        
        cell.timeAgo.text = timeAgo
        
        cell.timestring = items.timestring
        
        ref.child("Users").child(items.publisher).observe(.value) { (snapshot) in
            let postObjects = snapshot.value as? [String: AnyObject]
            let username = postObjects?["username"] as? String ?? ""
            cell.Namelabel.text = username
            
            
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
        
        ref.child("CommentLikes").child(commentString).child(Auth).observe(.value) { (snapshot) in
            if snapshot.exists()
            {
                cell.heartImage.image = UIImage(systemName: "heart.fill")
                cell.heartImage.tintColor = .systemGreen
            }
        }
        
        
        
        ref.child("CommentLikes").child(commentString).observe(.value) { (snapshot) in
            if snapshot.exists()
            {
                let pointcount: Int = Int(snapshot.childrenCount)
                
                cell.likeLabel.text = String(pointcount) + " yessss"
            }
        }
        
        let profileTap = UITapGestureRecognizer(target: self, action: #selector(GoToProfile(sender:)))
        cell.profileImageView.isUserInteractionEnabled = true
        cell.profileImageView.addGestureRecognizer(profileTap)
        
        let nameTap = UITapGestureRecognizer(target: self, action: #selector(GoToProfile(sender:)))
        cell.Namelabel.isUserInteractionEnabled = true
        cell.Namelabel.addGestureRecognizer(nameTap)
        
//        let likeTap = UITapGestureRecognizer(target: self, action: #selector(LikeComment(sender:)))
//        likeTap.numberOfTapsRequired = 1
//        cell.heartImage.isUserInteractionEnabled = true
//        cell.heartImage.addGestureRecognizer(likeTap)
        
        return cell
    }
    @objc func GoToProfile(sender: UITapGestureRecognizer)
    {
        let touch = sender.location(in: tableView)
        if let indexPath = tableView.indexPathForRow(at: touch) {
            let items = commentData[indexPath.row]
            let id = items.publisher
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "AddProfile", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "AddProfile") as! AddProfile
            newViewController.Userid = id
            self.navigationController?.pushViewController(newViewController, animated: true)
        }
    }
    
//    @objc func LikeComment(sender: UITapGestureRecognizer)
//    {
//        let touch = sender.location(in: tableView)
//        if let indexPath = tableView.indexPathForRow(at: touch) {
//            let cell = tableView.dequeueReusableCell(withIdentifier: CellID, for: indexPath) as! CommentPostCell
//            let items = commentData[indexPath.row]
//            let timestring = items.timestring
//            
//            ref.child("CommentLikes").child(timestring).child(self.Auth).observe(.value) { (snapshot) in
//                if snapshot.exists()
//                {
//                    self.ref.child("CommentLikes").child(timestring).child(self.Auth).removeValue()
//                    cell.heartImage.image = UIImage(systemName: "heart")
//                    print("why ")
//                }else {
//                    self.ref.child("CommentLikes").child(timestring).child(self.Auth).setValue(true)
//                    cell.heartImage.image = UIImage(systemName: "heart.fill")
//                    print("tf?")
//                }
//            }
//        }
//    }
}
