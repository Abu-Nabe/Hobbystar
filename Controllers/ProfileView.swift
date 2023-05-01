//
//  ProfileView.swift
//  Zinging
//
//  Created by Abu Nabe on 3/1/21.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import Firebase
import SideMenu

class ProfileView: UIViewController
{
    
    var postdata: [HomePostData] = [HomePostData]()
    var picdata: [ZingingPicData] = [ZingingPicData]()
    
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
    
    
    let NameLabel: UILabel = {
        let Label = UILabel()
        Label.textAlignment = .center
        Label.text = "Username"
        Label.textColor = .black
        Label.font = .boldSystemFont(ofSize: 14)
        return Label
    }()
    
    let HobbyLabel: UILabel = {
        let Label = UILabel()
        Label.textAlignment = .center
        Label.text = "Hobby"
        Label.textColor = .black
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
        Label.text = "Friends"
        Label.backgroundColor = .green
        Label.font = .boldSystemFont(ofSize: 12)
        return Label
    }()
    
    let GatherLabel: UILabel = {
        let Label = UILabel()
        Label.textAlignment = .center
        Label.text = "Gathering"
        Label.backgroundColor = .green
        Label.font = .boldSystemFont(ofSize: 12)
        return Label
    }()
    
    let InterestLabel: UILabel = {
        let Label = UILabel()
        Label.textAlignment = .center
        Label.text = "Interests"
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
    
    
    lazy var ExtraView: UIView = {
        let view = UIView()
        
        
        return view
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

        configureNavigationBar()
        configurePostView()
        configureUser()
        
        configureCollectionView()
        configureCollectionView1()
        
        listenDeletes()
        
        self.edgesForExtendedLayout = []
        
        let date = Date() // current date
        let timestamp = date.toMilliseconds()
        
        menu = SideMenuNavigationController(rootViewController: SettingsView())
        
        SideMenuManager.default.rightMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
        
        let Auth = FirebaseAuth.Auth.auth().currentUser!.uid
        let ref = Database.database().reference().child("Users").child(Auth).child("online")
        ref.setValue("Online")
        ref.onDisconnectSetValue(timestamp)
        
        postdata.removeAll()
        picdata.removeAll()
        
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
        
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
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(GoToFriendList))
        tap.numberOfTapsRequired = 1
        FriendsLabel.isUserInteractionEnabled = true
        FriendsLabel.addGestureRecognizer(tap)
        
        let gatherTap = UITapGestureRecognizer(target: self, action: #selector(gotoGatherList))
        GatherLabel.isUserInteractionEnabled = true
        GatherLabel.addGestureRecognizer(gatherTap)
        
        let InterestTap = UITapGestureRecognizer(target: self, action: #selector(GoToInterestList))
        InterestLabel.isUserInteractionEnabled = true
        InterestLabel.addGestureRecognizer(InterestTap)
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(GoToEditProfile))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(tap1)
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(CountryChanger))
        tap2.numberOfTapsRequired = 1
        countryImageView.isUserInteractionEnabled = true
        countryImageView.addGestureRecognizer(tap2)
        
        
       
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        
        BlackLine1.frame = CGRect(x: 0, y: NameLabel.frame.origin.y+NameLabel.frame.size.height+2
                                  , width: view.width, height: 1)
        BlackLine2.frame = CGRect(x: 0, y: FriendsLabel.frame.origin.y+FriendsLabel.frame.size.height+2
                                  , width: view.width, height: 1)
        
        postView.anchor(top: BlackLine2.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor,right: view.rightAnchor)
    }
    
    func configureUser()
    {
        let auth = FirebaseAuth.Auth.auth().currentUser!.uid
        let ref = Database.database().reference()
        
        ref.child("Users").child(auth).observe(.value) { (snapshot) in
            if snapshot.exists()
            {
                let userObjects = snapshot.value as? [String: AnyObject]
                let name = userObjects?["username"]
                self.NameLabel.text = name as? String
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
                if snapshot.hasChild("hobby")
                {
                    
                    let image = userObjects?["hobby"]
                    let url = URL(string: image as! String)
                    URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                        
                        if let error = error {
                            print("There was an error fetching the image from the url: \n", error)
                        }
                        
                        if let data = data, let countryPicture = UIImage(data: data) {
                            DispatchQueue.main.async() {
                                self.countryImageView.image = countryPicture // Set the profile picture
                            }
                        } else {
                            print("Something is wrong with the image data")
                        }
                        
                    }).resume()
                }
                if snapshot.hasChild("hobbyname")
                {
                    let hobby = userObjects?["hobbyname"] as! String
                    
                    self.HobbyLabel.text = hobby
                }
            }
        }
        
        ref.child("Users").child(auth).child("points").observe(.value) { (snapshot) in
            if snapshot.exists()
            {
                let pointcount: Int = Int(snapshot.childrenCount)
                
                self.NumberLabel.text = String(pointcount)
            }
        }
        ref.child("Users").child(auth).child("zingingpost").observe(.value) { (snapshot) in
            if snapshot.exists()
            {
                let pointcount: Int = Int(snapshot.childrenCount)

                self.ZingingView.text = String(pointcount) + " Zinging Posts"
            }
        }
        ref.child("Users").child(auth).child("post").observe(.value) { (snapshot) in
            if snapshot.exists()
            {
                let pointcount: Int = Int(snapshot.childrenCount)

                self.PersonalView.text = String(pointcount) + " Posts"
            }
        }
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
        let auth = FirebaseAuth.Auth.auth().currentUser!.uid
        
        ref.child("Posts").observe(.value) { (snapshot) in
            for pics in snapshot.children.allObjects as![FirebaseDatabase.DataSnapshot] {
                let key = pics.key
                ref.child("Posts").child(key).observe(.value) { (snapshot) in
                    
                    let picList = HomePostData(snapshot: pics)
                    
                    if picList.publisher == auth
                    {
                        self.postdata.insert(picList, at:0)
                    }
                    
                    self.collectionVieww!.reloadData()
                }
            }
        }
    }
    
    func listenDeletes() {
        
       let ref = Database.database().reference().child("Posts")

        ref.observe(.value) { (snapshot) in
            for posts in snapshot.children.allObjects as![FirebaseDatabase.DataSnapshot] {
                let key = posts.key
                ref.child(key).observe(.childRemoved, with: { [self] postSnapshot in
                    if let index = self.postdata.firstIndex(where: {$0.timestring == key}) {

                        self.postdata.remove(at: index)
//                        self.compileCounter -= 1
                        self.collectionVieww?.deleteItems(at: [IndexPath(item: index, section: 0)])
                        
                        self.postdata.removeAll()
                 }
               })
            }
        }
        
        let ref1 = Database.database().reference().child("Pics")
        
        ref1.observe(.value) { (snapshot) in
            for posts in snapshot.children.allObjects as![FirebaseDatabase.DataSnapshot] {
                let key = posts.key
                ref1.child(key).observe(.childRemoved, with: { [self] postSnapshot in
                    if let index = self.picdata.firstIndex(where: {$0.timestring == key}) {

                        self.picdata.remove(at: index)
                        self.collectionView1?.deleteItems(at: [IndexPath(item: index, section: 0)])
                        
                        self.picdata.removeAll()
                 }
               })
            }
        }
    }
    
    
    func ConfigureTableViewData1()
    {
        let ref = Database.database().reference()
        let auth = FirebaseAuth.Auth.auth().currentUser!.uid
        
        ref.child("Pics").observe(.value) { (snapshot) in
            for pics in snapshot.children.allObjects as![FirebaseDatabase.DataSnapshot] {
                let key = pics.key
                ref.child("Pics").child(key).observe(.value) { (snapshot) in
                    
                    let picList = ZingingPicData(snapshot: pics)
                    
                    if picList.publisher == auth
                    {
                        self.picdata.insert(picList, at:0)
                    }
                    
                    self.collectionView1!.reloadData()
                    
                }
            }
        }
    }
    
    private func configureNavigationBar()
    {
        let longTitleLabel = UILabel()
            longTitleLabel.text = "Profile"
            longTitleLabel.textColor = .black
            longTitleLabel.font = .boldSystemFont(ofSize: 16.0)
            longTitleLabel.sizeToFit()

            let leftItem = UIBarButtonItem(customView: longTitleLabel)
            self.navigationItem.leftBarButtonItem = leftItem
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .done, target: self, action: #selector(didTapSettingsButton))
        
        self.navigationController?.navigationBar.barTintColor = .green
    }
    
    @objc private func didTapSettingsButton()
    {
        present(menu!, animated: true)
    }
    
    @objc func GoToFriendList()
    {
        let storyBoard: UIStoryboard = UIStoryboard(name: "FriendsList", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "FriendsList") as! FriendsList
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    @objc func gotoGatherList()
    {
        let storyBoard: UIStoryboard = UIStoryboard(name: "GatherChat", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "GatherChat") as! GatherChat
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    @objc func GoToInterestList()
    {
        let storyBoard: UIStoryboard = UIStoryboard(name: "InterestList", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "InterestList") as! InterestList
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    @objc func GoToEditProfile()
    {
        let storyBoard: UIStoryboard = UIStoryboard(name: "EditProfile", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "EditProfile") as! EditProfile
        self.navigationController?.present(newViewController, animated: true)
    }
    @objc func CountryChanger()
    {
        let storyBoard: UIStoryboard = UIStoryboard(name: "CountryPicker", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "CountryPicker") as! CountryPicker
        self.navigationController?.present(newViewController, animated: true)
    }
    
}

extension ProfileView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
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

