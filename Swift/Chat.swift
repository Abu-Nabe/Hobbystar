//
//  Chat.swift
//  Zinging
//
//  Created by Abu Nabe on 19/1/21.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class Chat: UIViewController
{
    var friendID = String()
    var MessageHash: [SubMessage] = [SubMessage]()
    var CellID = "ChatId"
    var AuthID = String()
    
    var handleOne = DatabaseHandle()
    let databaseRef = Database.database().reference()
    var observingRefOne = Database.database().reference()
    var compileCounter: Int = 0
    
    var toolbarView = UIView()
    
    //    var messages = [Message]()
    //    var messagesDictionary = [String: Message]()
    
    
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
        profileimage.layer.cornerRadius = 30/2
        
        return profileimage
    }()
    
    private let Namelabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Username"
        label.font = .boldSystemFont(ofSize: 10)
        
        return label
    }()
    
    private let OnlineLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Online"
        label.font = .boldSystemFont(ofSize: 10)
        
        
        return label
    }()
    
    //change border width and decide whether to just use underline also with android studio background grey color
    private let TextField: UITextField = {
        let EmailField = UITextField()
        EmailField.placeholder = "Send Message"
        EmailField.textAlignment = .justified
        EmailField.returnKeyType = .next
        EmailField.layer.cornerRadius = 16;
        EmailField.layer.borderColor = UIColor.black.cgColor
        
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
        imageview.image = UIImage(named: "sendmsg")
        imageview.tintColor = .green
        
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
        
        view.addSubview(ImageButton)
        view.addSubview(SendButton)
        view.addSubview(TextField)
        view.addSubview(BlackLine1)
        view.addSubview(tableView)
        view.addSubview(toolbarView)
        
        configureTableView()
        configureToolbarView()
        configureUser()
        
        toolbarView.backgroundColor = .systemGreen
        
        let ref = Database.database().reference()
        let userID = FirebaseAuth.Auth.auth().currentUser!.uid
        
        ref.child("Unread").child(userID).child(friendID).child("Unread").removeValue()
        
        AuthID = FirebaseAuth.Auth.auth().currentUser?.uid ?? ""
        tableView.anchor(top: toolbarView.bottomAnchor, left: view.leftAnchor, bottom: TextField.topAnchor, right: view.rightAnchor)
        
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
    
    override func viewDidAppear(_ animated: Bool) {
        
        configure()
        
        self.fetchCurrentChatMessages { (isComplete) in
            
            if isComplete == true {
                self.handleSuccess()
            } else if isComplete == false {
                self.handleFailure()
            }
            
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        toolbarView.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height/13+25)
        
        TextField.anchor(top: ImageButton.topAnchor, left: ImageButton.rightAnchor, right: SendButton.leftAnchor, height: 30)
        
        SendButton.anchor(top: ImageButton.topAnchor, right: view.rightAnchor, width: 30, height: 30)
        
        ImageButton.anchor(left: view.leftAnchor,bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingLeft: 2, width: 30, height: 30)
        
        BlackLine1.anchor(left: ImageButton.rightAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: SendButton.leftAnchor, height: 1)
    }
    
    func configureToolbarView()
    {
        toolbarView.addSubview(BackButton)
        toolbarView.addSubview(profileImageView)
        toolbarView.addSubview(Namelabel)
        toolbarView.addSubview(OnlineLabel)
        
        Namelabel.anchor(top: profileImageView.topAnchor, left: profileImageView.rightAnchor, paddingLeft: 2)
        
        BackButton.anchor(left: toolbarView.leftAnchor, bottom: toolbarView.bottomAnchor, width: 30, height: 30)
        
        profileImageView.anchor(left: BackButton.rightAnchor, bottom: toolbarView.bottomAnchor,  paddingLeft: 2, width: 30, height: 30)
        
        OnlineLabel.anchor(left: profileImageView.rightAnchor, bottom: toolbarView.bottomAnchor, paddingLeft: 2)
    }
    
    @objc func ProfilePage()
    {
        let storyBoard: UIStoryboard = UIStoryboard(name: "AddProfile", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "AddProfile") as! AddProfile
        newViewController.Userid = friendID
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    func fetchCurrentChatMessages(completion : @escaping (_ isComplete : Bool)->())
    {
        guard let Auth = FirebaseAuth.Auth.auth().currentUser?.uid else {
            return
        }
        
        let ref = FirebaseDatabase.Database.database().reference()
        
        ref.child("Chats").child(Auth).child(friendID).observe(.value, with: { (snapListener : DataSnapshot) in
            
            self.compileCounter = 0
            self.MessageHash.removeAll()
            
            ref.child("Chats").child(Auth).child(self.friendID).observe(.value) { [self] (snapCount) in
                if snapCount.exists()
                {
                    let snapChildrenCount = snapCount.childrenCount
                    
                    self.observingRefOne = self.databaseRef.child("Chats").child(Auth).child(friendID)
                    
                    self.handleOne = self.observingRefOne.observe(.childAdded, with: { (snapLoop: DataSnapshot) in
                        self.compileCounter += 1
                        
                        guard let userObjects = snapLoop.value as? [String : Any] else {return}
                                                
                        let message = userObjects["message"] as? String ?? ""
                        let sender = userObjects["sender"] as? String ?? ""
                        let receiver = userObjects["receiver"] as? String ?? ""
                        let seen = userObjects["seen"] as? Bool ?? false
                        
                        
                        let TextInfo = SubMessage(message: message, receiver: receiver, seen: seen, sender: sender)
                        
                        
                        self.MessageHash.insert(TextInfo, at:0)
                        self.tableView.reloadData()

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
    
    func configure()
    {
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func configureTableView()
    {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ChatCell.self, forCellReuseIdentifier: CellID)
        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        
        
        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
    }
    
    func configureUser()
    {
        let ref = Database.database().reference()
        
        ref.child("Users").child(friendID).observe(.value) { (snapshot) in
            let objDict = snapshot.value as! [String: AnyObject]
            if snapshot.exists()
            {
                let username = objDict["username"] as! String
                self.Namelabel.text = username
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
                if snapshot.hasChild("online")
                {
                    let online = objDict["online"] as? String ?? ""
                    
                    if online == "Online"
                    {
                        self.OnlineLabel.text = "Online"
                    }else if online == "Texting"
                    {
                        self.OnlineLabel.text = "is Typing..."
                    }else {
                        let text = objDict["online"] as! TimeInterval
                        
                        let date = Date(timeIntervalSince1970: text / 1000)
                        let timeAgo = timeAgoSince(date)
                        
                        self.OnlineLabel.text = timeAgo
                    }
                }
            }
        }
    }
    
    @objc func backtoMessage()
    {
        MessageHash.removeAll()
        tableView.reloadData()
        friendID.removeAll()
        AuthID.removeAll()
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "MessageView") as! MessageView
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
            
            var messagedata2 = [String : AnyObject]()
            messagedata2["message"] = TextField.text! as AnyObject
            messagedata2["receiver"] = friendID as AnyObject
            messagedata2["seen"] = false as AnyObject
            messagedata2["sender"] = userID as AnyObject
            
            ref.child("Chats").child(userID).child(friendID).childByAutoId().setValue(messagedata)
            
            ref.child("Chats").child(friendID).child(userID).childByAutoId().setValue(messagedata2)
            
            ref.child("Users").child(friendID).child("Unread").setValue(TextField.text)
            
            ref.child("Message").child(userID).child(friendID).child("Text").setValue(TextField.text!)
            
            ref.child("Message").child(friendID).child(userID).child("Text").setValue(TextField.text!)
            
            let date = Date() // current date
            let timestamp = date.toMilliseconds()
            
            ref.child("Message").child(userID).child(friendID).child("timestamp").setValue(timestamp);
            ref.child("Message").child(friendID).child(userID).child("timestamp").setValue(timestamp);
            ref.child("Message").child(userID).child(friendID).child("seen").setValue(false);
            ref.child("Message").child(friendID).child(userID).child("seen").setValue(false);
            
            let pushkey = Database.database().reference().childByAutoId()
            let push = pushkey.key!
            ref.child("Unread").child(friendID).child(userID).child(push).setValue(true)
            
//            self.MessageHash.removeAll()
//            self.tableView.reloadData()
            TextField.text = ""
            scrollToBottom()
            
            SendNotifications(String: TextField.text!)
        }
    }
    
    func SendNotifications(String: String)
    {
        let Auth = FirebaseAuth.Auth.auth().currentUser!.uid
        let text = String
        
        let ref = Database.database().reference()
        
        ref.child("Tokens").child(friendID).observe(.value) { [self] (snapshot) in
            if snapshot.exists(){
                for userObj in snapshot.children.allObjects as![FirebaseDatabase.DataSnapshot]
                {
                    let key = userObj.value as! String
                    
                    //                    self.sendPushNotification(to: key, title: "New Message", body : Namelabel.text!+": "+text, user: Auth, icon: UIImage(named: "logo")!, sent: friendID)
                }
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
    
    func scrollToBottom(){
        DispatchQueue.main.async { [self] in
            let indexPath = IndexPath(row: self.MessageHash.count-1, section: 0)
            if MessageHash.count > 10 {
                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }
    
    func sendPushNotification(to token: String, title: String, body: String, user: String, icon: UIImage, sent: String) {
        let urlString = "https://fcm.googleapis.com/fcm/send"
        let url = NSURL(string: urlString)!
        let paramString: [String : Any] = ["to" : token,
                                           "notification" : [title, body],
                                           "data" : [user, icon]
        ]
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject:paramString, options: [.prettyPrinted])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=AAAAthneo50:APA91bEhw_06joRsBVA8x8sTaab4nPyQySXilkOajj33wI59mSVX62p_X5swDgbA4VfhewfYV84KZHnHRhX1mHCi4degFcnWClkrkTWQxlwe6xSqB3LMvIQns4NA6vcBEstxnocYn3qm", forHTTPHeaderField: "Authorization")
        let task =  URLSession.shared.dataTask(with: request as URLRequest)  { (data, response, error) in
            do {
                if let jsonData = data {
                    if let jsonDataDict  = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
                        NSLog("Received data:\n\(jsonDataDict))")
                    }
                }
            } catch let err as NSError {
                print(err.debugDescription)
            }
        }
        task.resume()
    }
}

extension Chat: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellID, for: indexPath) as! ChatCell
        
        let message = MessageHash[indexPath.row]
        
        cell.textView.text = message.message
        
        cell.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        setUpCell(cell: cell, message: message)
        
        if let text = message.message {
            cell.bubbleWidthAnchor?.constant = estimateFrameforText(text: text).width + 32
            cell.bubbleHeightAnchor?.constant = estimateFrameforText(text: text).height + 32
        }
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageHash.count
    }
    
    private func setUpCell(cell: ChatCell, message: SubMessage)
    {
        
        if message.sender == FirebaseAuth.Auth.auth().currentUser!.uid
        {
            cell.bubbleView.backgroundColor = .lightGray
            cell.textView.textColor = UIColor.white
            
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
