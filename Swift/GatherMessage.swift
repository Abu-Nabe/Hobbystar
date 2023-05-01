//
//  GAtherMessage.swift
//  Zinging
//
//  Created by Abu Nabe on 25/2/21.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class GatherMessage: UIViewController
{
    var friendID = String()
    var friendName = String()
    var Username = String()
    var MessageHash: [SubGather] = [SubGather]()
    var CellID = "ChatId"
    var AuthID = String()
    
    var handleOne = DatabaseHandle()
    let databaseRef = Database.database().reference()
    var observingRefOne = Database.database().reference()
    var compileCounter: Int = 0
    
    let BackButton: UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage.init(systemName: "arrow.backward")
        
        return imageview
    }()
    
    let profileImageView: UIImageView = {
        let profileimage = UIImageView()
        
        profileimage.contentMode = .scaleAspectFill
        profileimage.clipsToBounds = true
        profileimage.layer.borderWidth = 1
        profileimage.layer.borderColor = UIColor.black.cgColor
        profileimage.image = UIImage.init(systemName: "person.fill")
        profileimage.tintColor = .systemGreen
        profileimage.layer.cornerRadius = 30/2
    
        return profileimage
    }()
    
    private let Namelabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Gather"
        label.font = .boldSystemFont(ofSize: 10)
        
        
        return label
    }()
    
    private let TextField: UITextField = {
        let EmailField = UITextField()
        EmailField.placeholder = "Message"
        EmailField.layer.borderWidth = 1
        EmailField.returnKeyType = .next
        EmailField.layer.cornerRadius = 8;
        EmailField.layer.borderColor = UIColor.black.cgColor
        EmailField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
        return EmailField
    }()
    
    
    let ImageButton: UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage.init(systemName: "plus")
        imageview.tintColor = .systemGreen
        return imageview
    }()
    
    let SendButton: UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage.init(systemName: "chevron.forward.circle.fill")
        imageview.tintColor = .systemGreen
        return imageview
    }()
    
    let BlackLine1: UIView = {
        let Label = UIView()
        Label.backgroundColor = .green
        return Label
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(BackButton)
        view.addSubview(profileImageView)
        view.addSubview(Namelabel)
        view.addSubview(ImageButton)
        view.addSubview(SendButton)
        view.addSubview(TextField)
        view.addSubview(BlackLine1)
        view.addSubview(tableView)
        
        configure()
        configureTableView()
        configureUser()
        
        MessageHash.removeAll()
        
        self.fetchCurrentChatMessages { (isComplete) in
            
            if isComplete == true {
                self.handleSuccess()
            } else if isComplete == false {
                self.handleFailure()
            }
            
        }
        
        AuthID = FirebaseAuth.Auth.auth().currentUser?.uid ?? ""
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(backtoMessage))
        tap.numberOfTapsRequired = 1
        BackButton.isUserInteractionEnabled = true
        BackButton.addGestureRecognizer(tap)
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(sendMessage))
        tap1.numberOfTapsRequired = 1
        SendButton.isUserInteractionEnabled = true
        SendButton.addGestureRecognizer(tap1)
        
        let ProfileTap = UITapGestureRecognizer(target: self, action: #selector(ProfilePage))
        ProfileTap.numberOfTapsRequired = 1
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(ProfileTap)
        
        let ProfileTap1 = UITapGestureRecognizer(target: self, action: #selector(ProfilePage))
        ProfileTap1.numberOfTapsRequired = 1
        Namelabel.isUserInteractionEnabled = true
        Namelabel.addGestureRecognizer(ProfileTap1)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        Namelabel.anchor(top: profileImageView.topAnchor, left: profileImageView.rightAnchor, paddingTop: 10, paddingLeft: 2)
        
        TextField.anchor(top: ImageButton.topAnchor, left: ImageButton.rightAnchor, right: SendButton.leftAnchor, height: 30)
        
        SendButton.anchor(top: ImageButton.topAnchor, right: view.rightAnchor, width: 30, height: 30)
        
        BackButton.frame = CGRect(x: 0, y: view.height/13, width: 30, height: 30)
        profileImageView.frame = CGRect(x: BackButton.frame.origin.x+BackButton.frame.width+2, y: view.height/13, width: 30, height: 30)
        ImageButton.frame = CGRect(x: 2, y: view.height-60, width: 30, height: 25)
        
        BlackLine1.frame = CGRect(x: 0, y: BackButton.frame.origin.y+TextField.frame.height+1, width: view.width, height: 1)
        
    }
    
    func fetchCurrentChatMessages(completion : @escaping (_ isComplete : Bool)->())
    {
        let ref = FirebaseDatabase.Database.database().reference()
        
        ref.child("Gathers").child(friendID).observe(.value, with: { (snapListener : DataSnapshot) in
            
            self.compileCounter = 0
            self.MessageHash.removeAll()
            
            ref.child("Gathers").child(self.friendID).observe(.value) { [self] (snapCount) in
                if snapCount.exists()
                {
                    let snapChildrenCount = snapCount.childrenCount
                    
                    self.observingRefOne = self.databaseRef.child("Gathers").child(friendID)
                    
                    self.handleOne = self.observingRefOne.observe(.childAdded, with: { (snapLoop: DataSnapshot) in
                        self.compileCounter += 1
                        
                        let userObjects = snapLoop.value as? [String: AnyObject]
                        let message = userObjects?["message"] as? String ?? ""
                        let sender = userObjects?["sender"] as? String ?? ""
                        let receiver = userObjects?["receiver"] as? String ?? ""
                        let seen = userObjects?["seen"] as? Bool ?? false
                        let username = userObjects?["username"] as? String ?? ""
                        
                        let TextInfo = SubGather(message: message, receiver: receiver, seen: seen, sender: sender, username: username)
                        
                        
                        self.MessageHash.insert(TextInfo, at:0)

                        if self.compileCounter == snapChildrenCount {
                            completion(true)
                        }
                        
                    }, withCancel: { (error) in
                        completion(false)
                    })
                    
                    if !snapCount.exists()
                    {
                        completion(false)
                    }
                }
            }
        }) { (error) in
            completion(false)
        }
    }
    
    func handleSuccess() {
        self.compileCounter = 0
        self.observingRefOne.removeObserver(withHandle: self.handleOne)
        DispatchQueue.main.async {
            //RELOAD YOUR COLLECTION OR TABLE VIEW
            self.tableView.reloadData()
        }
    }
    func handleFailure() {
        self.compileCounter = 0
        self.MessageHash.removeAll() // REPLACE THIS WITH YOUR DATASOURCE
        self.observingRefOne.removeObserver(withHandle: self.handleOne)
        DispatchQueue.main.async {
            //RELOAD YOUR COLLECTION OR TABLE VIEW
            self.tableView.reloadData()
        }
    }
    
    
    @objc func ProfilePage()
    {
        let Auth = FirebaseAuth.Auth.auth().currentUser!.uid
        if Auth == friendID
        {
            let storyBoard: UIStoryboard = UIStoryboard(name: "GatherEdit", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "GatherEdit") as! GatherEdit
            self.navigationController?.pushViewController(newViewController, animated: true)
        }else {
            let storyBoard: UIStoryboard = UIStoryboard(name: "GatherList", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "GatherList") as! GatherList
            newViewController.GatherID = friendID
            self.present(newViewController, animated: true)
        }
    }
    
    func configure()
    {
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func configureTableView()
    {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.anchor(top: BackButton.bottomAnchor, left: view.leftAnchor, bottom: TextField.topAnchor, right: view.rightAnchor)
        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        
        
        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        tableView.register(GatherCell.self, forCellReuseIdentifier: CellID)
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
    }
    
    func configureUser()
    {
        let ref = Database.database().reference()
        let Auth = FirebaseAuth.Auth.auth().currentUser!.uid
        
        ref.child("Users").child(Auth).observe(.value) { (snapshot) in
            let objDict = snapshot.value as! [String: AnyObject]
            
            let username = objDict["username"] as! String
            self.Username.append(username)
        }
        
        ref.child("Users").child(friendID).observe(.value) { (snapshot) in
            let objDict = snapshot.value as! [String: AnyObject]
            if snapshot.exists()
            {
                if snapshot.hasChild("gathername")
                {
                    let username = objDict["gathername"] as! String
                    self.Namelabel.text = username
                }
                
                if snapshot.hasChild("profileimage")
                {
                    let image = objDict["profileimage"] as! String
                    let url = URL(string: image)
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
    
    @objc func backtoMessage()
    {
        let storyBoard: UIStoryboard = UIStoryboard(name: "GatherChat", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "GatherChat") as! GatherChat
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    @objc func sendMessage()
    {
        guard let userID = FirebaseAuth.Auth.auth().currentUser?.uid else {
            
            return
        }
        let ref = Database.database().reference()
        
        if let text = TextField.text, text.isEmpty
        {
            self.showToast(message: "Message is Empty", font: .systemFont(ofSize: 12.0))
        }else {
            
            var messagedata = [String : AnyObject]()
            messagedata["message"] = TextField.text! as AnyObject
            messagedata["receiver"] = friendID as AnyObject
            messagedata["seen"] = false as AnyObject
            messagedata["sender"] = userID as AnyObject
            messagedata["username"] = Username as AnyObject
            
            let date = Date() // current date
            let timestamp = date.toMilliseconds()
            
            let timestring = String(timestamp)
            
            ref.child("Gathers").child(friendID).child(timestring).setValue(messagedata)
            
//            self.MessageHash.removeAll()
//            self.tableView.reloadData()
//
            scrollToBottom()
            
            TextField.text = ""
        }
    }
    
    func scrollToBottom(){
        DispatchQueue.main.async { [self] in
            let indexPath = IndexPath(row: self.MessageHash.count-1, section: 0)
            if MessageHash.count > 10 {
                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
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

extension GatherMessage: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellID, for: indexPath) as! GatherCell
        
        let items = MessageHash[indexPath.row]
        
        let id = items.sender
        
        cell.Namelabel.text = items.username
        cell.textView.text = items.message
        
        setUpCell(cell: cell, message: items)
        
        cell.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        if let text = items.message
        {
            cell.bubbleWidthAnchor?.constant = estimateFrameforText(text: text).width + 32
            cell.bubbleHeightAnchor?.constant = estimateFrameforText(text: text).height + 32
        }
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageHash.count
    }
    
    private func setUpCell(cell: GatherCell, message: SubGather)
    {
        
        if message.sender == FirebaseAuth.Auth.auth().currentUser!.uid
        {
            cell.bubbleView.backgroundColor = .lightGray
            cell.textView.textColor = UIColor.white
            
            cell.Namelabel.isHidden = true
            cell.bubbleViewRightAnchor?.isActive = true
            cell.bubbleViewLeftAnchor?.isActive = false
        }
        else {
            cell.bubbleView.backgroundColor = .systemGreen
            cell.textView.textColor = UIColor.black
            cell.bubbleViewRightAnchor?.isActive = false
            cell.bubbleViewLeftAnchor?.isActive = true
        }
        
        
    }
    
    private func estimateFrameforText(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
}
