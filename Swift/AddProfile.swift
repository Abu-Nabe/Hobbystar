//
//  AddProfile.swift
//  Zinging
//
//  Created by Abu Nabe on 17/1/21.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import SideMenu

class AddProfile: UIViewController{
    
    var Userid = String()
    
    var menuList = MenuListController()
    
    var postdata: [PostData] = [PostData]()
    var picdata: [PicImage] = [PicImage]()
    
    var menu: SideMenuNavigationController?
    
    private var collectionVieww: UICollectionView?
    private var collectionView1: UICollectionView?
    
    let profileImageView: UIImageView = {
        let profileimage = UIImageView()
        
        profileimage.contentMode = .scaleAspectFill
        profileimage.clipsToBounds = true
        profileimage.layer.borderWidth = 1
        profileimage.image = UIImage(systemName: "person.fill")?.withRenderingMode(.alwaysOriginal)
        profileimage.layer.borderColor = UIColor.black.cgColor
        return profileimage
    }()
    
    var toolbar: UINavigationBar = {
        let bar = UINavigationBar()
        bar.backgroundColor = .green
        
        return bar
    }()
    
    let countryImageView: UIImageView = {
        let profileimage = UIImageView()
        
        profileimage.contentMode = .scaleAspectFill
        profileimage.clipsToBounds = true
        profileimage.layer.borderWidth = 1
        profileimage.layer.borderColor = UIColor.black.cgColor
        return profileimage
    }()
    
    let StarImage: UIImageView = {
        var imageview = UIImageView()
        imageview.image = UIImage(systemName: "star.fill")
        
        return imageview
    }()
    
    
    var NameLabel: UILabel = {
        let Label = UILabel()
        Label.textAlignment = .center
        Label.text = "Username"
        Label.textColor = .black
        Label.sizeToFit()
        Label.font = .boldSystemFont(ofSize: 14)
        Label.adjustsFontSizeToFitWidth = true
        Label.minimumScaleFactor = 0.5
        return Label
    }()
    
    let HobbyLabel: UILabel = {
        let Label = UILabel()
        Label.textAlignment = .center
        Label.text = "Hobby"
        Label.textColor = .black
        Label.sizeToFit()
        Label.adjustsFontSizeToFitWidth = true
        Label.minimumScaleFactor = 0.5
        Label.font = .boldSystemFont(ofSize: 14)
        return Label
    }()
    
    let BlackLine1: UIView = {
        let Label = UIView()
        Label.backgroundColor = .black
        return Label
    }()
    
    let BlackLine2: UIView = {
        let Label = UIView()
        Label.backgroundColor = .black
        return Label
    }()
    
    let FriendsLabel: UILabel = {
        let Label = UILabel()
        Label.textAlignment = .center
        Label.text = "Request"
        Label.backgroundColor = .green
        Label.font = .boldSystemFont(ofSize: 12)
        return Label
    }()
    
    let GatherLabel: UILabel = {
        let Label = UILabel()
        Label.textAlignment = .center
        Label.text = "Gather"
        Label.backgroundColor = .green
        Label.font = .boldSystemFont(ofSize: 12)
        return Label
    }()
    
    let InterestLabel: UILabel = {
        let Label = UILabel()
        Label.textAlignment = .center
        Label.text = "Interest"
        Label.backgroundColor = .green
        Label.font = .boldSystemFont(ofSize: 12)
        return Label
    }()
    
    let NumberLabel: UILabel = {
        let Label = UILabel()
        Label.textAlignment = .center
        Label.text = "0"
        Label.font = .boldSystemFont(ofSize: 12)
        return Label
    }()
    
    let PointsLabel: UILabel = {
        let Label = UILabel()
        Label.textAlignment = .center
        Label.text = "Points"
        Label.font = .boldSystemFont(ofSize: 12)
        return Label
    }()
    
    
    
    let PersonalView: UILabel = {
        let Label = UILabel()
        Label.textAlignment = .center
        Label.text = "Personal Posts"
        Label.font = .boldSystemFont(ofSize: 12)
        
        return Label
    }()
    
    let ZingingView: UILabel = {
        let Label = UILabel()
        Label.textAlignment = .center
        Label.text = "Zinging Posts"
        Label.font = .boldSystemFont(ofSize: 12)
        
        return Label
    }()
    
    let PostLine: UIView = {
        let Label = UIView()
        Label.backgroundColor = .black
        return Label
    }()
    
    let ZingingLine: UIView = {
        let Label = UIView()
        Label.backgroundColor = .black
        return Label
    }()
    
    let postView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        view.addSubview(profileImageView)
        view.addSubview(NameLabel)
        view.addSubview(countryImageView)
        view.addSubview(HobbyLabel)
        view.addSubview(BlackLine1)
        view.addSubview(BlackLine2)
        view.addSubview(FriendsLabel)
        view.addSubview(GatherLabel)
        view.addSubview(InterestLabel)
        view.addSubview(StarImage)
        view.addSubview(PointsLabel)
        view.addSubview(NumberLabel)
        view.addSubview(toolbar)
        view.addSubview(postView)
        
        self.edgesForExtendedLayout = []
        
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
        
        menu = SideMenuNavigationController(rootViewController: MenuListController())
        
        SideMenuManager.default.rightMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
        
        self.navigationItem.rightBarButtonItem = .init(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(OpenSetting))
        
        configurePostView()
        
        configureCollectionView()
        configureCollectionView1()
        
        
        guard let auth = FirebaseAuth.Auth.auth().currentUser?.uid else {
            
            return
        }
        
        let date = Date() // current date
        let timestamp = date.toMilliseconds()
        
        let Auth = FirebaseAuth.Auth.auth().currentUser!.uid
        let ref = Database.database().reference().child("Users").child(Auth).child("online")
        ref.setValue("Online")
        ref.onDisconnectSetValue(timestamp)
        
        if Userid == auth
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let secondViewController = storyboard.instantiateViewController(withIdentifier: "ProfileView") as! ProfileView
            self.navigationController?.pushViewController(secondViewController, animated: true)
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(CheckForConnections))
        tap.numberOfTapsRequired = 1
        FriendsLabel.isUserInteractionEnabled = true
        FriendsLabel.addGestureRecognizer(tap)
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(GatherConnections))
        tap1.numberOfTapsRequired = 1
        GatherLabel.isUserInteractionEnabled = true
        GatherLabel.addGestureRecognizer(tap1)
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(InterestConnections))
        tap2.numberOfTapsRequired = 1
        InterestLabel.isUserInteractionEnabled = true
        InterestLabel.addGestureRecognizer(tap2)
        
        
        PositionViews()
        
        configureUser()
    }
    
    @objc func OpenSetting()
    {
        present(menu!, animated: true)
    }
    
    func PositionViews()
    {
        profileImageView.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 0, paddingLeft: 15, width: 60, height: 60)
        
        profileImageView.layer.cornerRadius = 60/2
        
        countryImageView.anchor(top: view.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingRight: 15, width: 60, height: 60)
        
        countryImageView.layer.cornerRadius = 60/2
        
        StarImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        StarImage.anchor(top: view.topAnchor, paddingTop: 0)
        
        NumberLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        NumberLabel.anchor(top: StarImage.bottomAnchor, paddingTop: 2)
        
        PointsLabel.centerXAnchor.constraint(equalTo: StarImage.centerXAnchor).isActive = true
        PointsLabel.anchor(top: NumberLabel.bottomAnchor, paddingTop: 2)
        
        NameLabel.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor).isActive = true
        NameLabel.anchor(top: profileImageView.bottomAnchor, paddingTop: 10)
        
        HobbyLabel.centerXAnchor.constraint(equalTo: countryImageView.centerXAnchor).isActive = true
        HobbyLabel.anchor(top: countryImageView.bottomAnchor, paddingTop: 10)
        
        FriendsLabel.anchor(top: BlackLine1.bottomAnchor, left: view.leftAnchor, paddingLeft: 20)
        
        GatherLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        GatherLabel.anchor(top: BlackLine1.bottomAnchor)
        
        InterestLabel.anchor(top: BlackLine1.bottomAnchor, right: view.rightAnchor, paddingRight: 20)
        
        let ref = Database.database().reference()
        
        ref.child("Users").child(Userid).child("points").observe(.value) { (snapshot) in
            if snapshot.exists()
            {
                let pointcount: Int = Int(snapshot.childrenCount)
                
                self.NumberLabel.text = String(pointcount)
            }
        }
        ref.child("Users").child(Userid).child("post").observe(.value) { (snapshot) in
            if snapshot.exists()
            {
                let pointcount: Int = Int(snapshot.childrenCount)
                
                self.PersonalView.text = String(pointcount) + " Posts"
            }
        }
        ref.child("Users").child(Userid).child("zingingposts").observe(.value) { (snapshot) in
            if snapshot.exists()
            {
                let pointcount: Int = Int(snapshot.childrenCount)
                
                self.ZingingView.text = String(pointcount) + " Zinging Posts"
            }
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        
        BlackLine1.frame = CGRect(x: 0, y: NameLabel.frame.origin.y+NameLabel.frame.size.height+2
                                  , width: view.width, height: 1)
        BlackLine2.frame = CGRect(x: 0, y: FriendsLabel.frame.origin.y+FriendsLabel.frame.size.height+2
                                  , width: view.width, height: 1)
        
        postView.anchor(top: BlackLine2.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor,right: view.rightAnchor)
        
        
    }
    
    func configurePostView()
    {
        postView.addSubview(PostLine)
        postView.addSubview(PersonalView)
        postView.addSubview(ZingingView)
        postView.addSubview(ZingingLine)
        
        PersonalView.centerXAnchor.constraint(equalTo: postView.centerXAnchor).isActive = true
        PersonalView.anchor(top: postView.topAnchor)
        
        PostLine.anchor(top: PersonalView.bottomAnchor, left: PersonalView.leftAnchor, right: PersonalView.rightAnchor, height: 1)
        
        ZingingView.centerYAnchor.constraint(equalTo: postView.centerYAnchor).isActive = true
        ZingingView.centerXAnchor.constraint(equalTo: postView.centerXAnchor).isActive = true
        ZingingView.anchor(paddingTop: 0)
        
        ZingingLine.anchor(top: ZingingView.bottomAnchor, left: ZingingView.leftAnchor, right: ZingingView.rightAnchor, height: 1)
    }
    
    func configureCollectionView()
    {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: view.width/2, height: 100)
        //        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        collectionVieww = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionVieww?.backgroundColor = .white
        collectionVieww?.showsHorizontalScrollIndicator = false
        collectionVieww?.frame = view.bounds
        
        postView.addSubview(collectionVieww!)
        
        collectionVieww?.anchor(top: PostLine.bottomAnchor, left: postView.leftAnchor, bottom: ZingingView.topAnchor, right: postView.rightAnchor)
        
        
        collectionVieww?.register(ProfileCell.self, forCellWithReuseIdentifier: ProfileCell.identifier)
        
        collectionVieww?.delegate = self
        collectionVieww?.dataSource = self
        
        ConfigureTableViewData()
        
    }
    
    func configureCollectionView1()
    {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: view.width/2, height: 0)
        
        collectionView1 = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView1?.backgroundColor = .white
        collectionView1?.showsHorizontalScrollIndicator = false
        collectionView1?.frame = view.bounds
        
        postView.addSubview(collectionView1!)
        
        collectionView1?.anchor(top: ZingingLine.bottomAnchor, left: postView.leftAnchor, bottom: postView.bottomAnchor, right: postView.rightAnchor)
        
        collectionView1?.register(ProfileCell1.self, forCellWithReuseIdentifier: ProfileCell1.identifier)
        
        collectionView1?.delegate = self
        collectionView1?.dataSource = self
        
        ConfigureTableViewData1()
        
    }
    
    func ConfigureTableViewData()
    {
        let ref = Database.database().reference()
        
        ref.child("Posts").observe(.value) { (snapshot) in
            for pics in snapshot.children.allObjects as![FirebaseDatabase.DataSnapshot] {
                let key = pics.key
                ref.child("Posts").child(key).observe(.value) { [self] (snapshot) in
                    
                    let Objects = snapshot.value as? [String: AnyObject]
                    
                    let picimage = Objects?["postimage"] as! String
                    let picpublisher = Objects?["publisher"] as! String
                    let picid = Objects?["postid"] as! String
                    let timestring = Objects?["timestring"] as! String
                    let timestamp = Objects?["timestamp"] as! TimeInterval
                    
                    let picList = PostData(postimage: picimage, publisher: picpublisher, timestring: timestring, timestamp: timestamp)
                    if picpublisher == Userid{
                        self.postdata.insert(picList, at:0)
                    }
                    
                    self.collectionVieww!.reloadData()
                }
            }
        }
    }
    
    func ConfigureTableViewData1()
    {
        let ref = Database.database().reference()
        
        ref.child("Pics").observe(.value) { (snapshot) in
            for pics in snapshot.children.allObjects as![FirebaseDatabase.DataSnapshot] {
                let key = pics.key
                ref.child("Pics").child(key).observe(.value) { [self] (snapshot) in
                    
                    let Objects = snapshot.value as? [String: AnyObject]
                    
                    let picimage = Objects?["picimage"] as! String
                    let picpublisher = Objects?["publisher"] as! String
                    let picid = Objects?["picid"] as! String
                    let timestring = Objects?["timestring"] as! String
                    
                    let picList = PicImage(picimage: picimage, picid: picid, publisher: picpublisher, timestring: timestring)
                    
                    if picpublisher == Userid
                    {
                        self.picdata.insert(picList, at:0)
                    }
                    
                    self.collectionView1!.reloadData()
                    
                }
            }
        }
    }
    
    func configureUser()
    {
        guard let auth = FirebaseAuth.Auth.auth().currentUser?.uid else {
            
            return
        }
        
        let ref = Database.database().reference()
        
        ref.child("Users").child(Userid).observe(.value) { (snapshot) in
            if snapshot.exists()
            {
                let objDict = snapshot.value as! [String: AnyObject]
                
                let name = objDict["username"]
                self.NameLabel.text = name as? String
                if snapshot.hasChild("profileimage")
                {
                    let image = objDict["profileimage"]
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
                if snapshot.hasChild("hobbyname")
                {
                    let label = objDict["hobbyname"] as! String
                    self.HobbyLabel.text = label
                }
                if snapshot.hasChild("hobby")
                {
                    let image = objDict["hobby"]
                    let url = URL(string: image as! String)
                    URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                        
                        if let error = error {
                            print("There was an error fetching the image from the url: \n", error)
                        }
                        
                        if let data = data, let profilePicture = UIImage(data: data) {
                            DispatchQueue.main.async() {
                                self.countryImageView.image = profilePicture // Set the profile picture
                            }
                        } else {
                            print("Something is wrong with the image data")
                        }
                        
                    }).resume()
                }else {
                    self.countryImageView.backgroundColor = .black
                }
            }
        }
        ref.child("Message").child(auth).child(Userid).observe(.value) { (snapshot) in
            if snapshot.exists()
            {
                ref.child("Message").child(self.Userid).child(auth).observe(.value) { (snapshot) in
                    if(snapshot.exists())
                    {
                        self.FriendsLabel.text = "Friends"
                    }
                    
                }
            }
            
        }
        ref.child("FriendRequest").child(auth).child(self.Userid).observe(.value) { (snapshot) in
            if snapshot.exists()
            {
                ref.child("FriendRequest").child(self.Userid).child(auth).observe(.value) { (snapshot) in
                    if(snapshot.exists())
                    {
                        self.FriendsLabel.text = "Requested"
                    }
                    
                }
            }
            
        }
        ref.child("Gather").child(self.Userid).child(auth).observe(.value) { (snapshot) in
            if snapshot.exists()
            {
                self.GatherLabel.text = "Gathering"
            }
            
        }
        ref.child("GatherRequest").child(auth).child(self.Userid).observe(.value) { (snapshot) in
            if snapshot.exists()
            {
                ref.child("GatherRequest").child(self.Userid).child(auth).observe(.value) { (snapshot) in
                    if(snapshot.exists())
                    {
                        self.GatherLabel.text = "Requested"
                    }
                    
                }
            }
            
        }
        ref.child("Interest").child(auth).child(self.Userid).observe(.value) { (snapshot) in
            if snapshot.exists()
            {
                self.InterestLabel.text = "Interested"
            }
            
        }
        
    }
    
    @objc func CheckForConnections()
    {   
        let storyboard = UIStoryboard(name: "AddFriendsList", bundle: nil)
        let secondViewController = storyboard.instantiateViewController(withIdentifier: "AddFriendsList") as! AddFriendsList
        secondViewController.Userid = Userid
        secondViewController.profileImageView.image = profileImageView.image
        self.navigationController?.pushViewController(secondViewController, animated: true)
        
    }
    
    @objc func GatherConnections()
    {
        guard let auth = FirebaseAuth.Auth.auth().currentUser?.uid else {
            
            return
        }
        
        let Gather = GatherLabel.text
        let ref = Database.database().reference()
        
        if Gather == "Gather"
        {
            ref.child("GatherRequest").child(Userid).child(auth).child("gather_type").setValue("received")
            ref.child("GatherRequest").child(auth).child(Userid).child("gather_type").setValue("sent")
            FriendsLabel.text = "Requested"
            
        }else if Gather == "Gathering"{
            //Go to his gatherlist
            let storyboard = UIStoryboard(name: "GatherMessage", bundle: nil)
            let secondViewController = storyboard.instantiateViewController(withIdentifier: "GatherMessage") as! GatherMessage
            secondViewController.friendID = Userid
            secondViewController.friendName = NameLabel.text!
            self.present(secondViewController, animated: true)
            
        }else if Gather == "Requested"{
            ref.child("GatherRequest").child(auth).child(Userid).removeValue()
            ref.child("GatherRequest").child(Userid).child(auth).removeValue()
        }
    }
    
    @objc func InterestConnections()
    {
        let storyboard = UIStoryboard(name: "AddInterest", bundle: nil)
        let secondViewController = storyboard.instantiateViewController(withIdentifier: "AddInterest") as! AddInterest
        secondViewController.Userid = Userid
        secondViewController.profileImageView.image = profileImageView.image
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
    
    class MenuListController: UITableViewController
    {
        var items = ["Videos", "Report", "Block"]
        
        var addProfileVars: AddProfile!
        
        override func viewDidLoad() {
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SettingCell")
        }
        
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return items.count
        }
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath)
            
            cell.textLabel?.text = items[indexPath.row]
            
            return cell
        }
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath)
            
            
            cell.textLabel?.text = items[indexPath.row]
            
            let settingText =  cell.textLabel?.text
            
            if settingText == "Videos"
            {
//                let storyBoard: UIStoryboard = UIStoryboard(name: "PersonalVideos", bundle: nil)
//                let newViewController = storyBoard.instantiateViewController(withIdentifier: "PersonalVideos") as! PersonalVideos
//                print(addProfileVars.Userid)
//                newViewController.videoUserID = addProfileVars.Userid
//                self.navigationController?.pushViewController(newViewController, animated: true)
            }else if settingText == "Report"
            {
                print("yea you")
            }else if settingText == "Block"
            {
                print("not us")
            }
        }
    }
    
}

extension AddProfile: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionVieww
        {
            return postdata.count
        }else {
            return picdata.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionVieww
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileCell.identifier, for: indexPath) as! ProfileCell
            
            cell.backgroundColor = .white
            let items = postdata[indexPath.row]
            
            let image = items.postimage
            let url = URL(string: image)
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
            
            
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileCell1.identifier, for: indexPath) as! ProfileCell1
            
            cell.backgroundColor = .white
            let items = picdata[indexPath.row]
            
            let image = items.picimage
            let url = URL(string: image)
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
            
            
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionVieww
        {
            return CGSize(width: view.width/2, height: collectionView.height)
        }
        else {
            return CGSize(width: view.width/2, height: collectionView1!.height)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectionVieww{
            let items = postdata[indexPath.row]
            let id = items.timestring
            let storyBoard: UIStoryboard = UIStoryboard(name: "ClickPost", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "ClickPost") as! ClickPost
            newViewController.postid = id
            self.navigationController?.pushViewController(newViewController, animated: true)
        }else {
            let items = picdata[indexPath.row]
            let id = items.timestring
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "ZingingPost", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "ZingingPost") as! ZingingPost
            newViewController.postid = id
            self.navigationController?.pushViewController(newViewController, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

