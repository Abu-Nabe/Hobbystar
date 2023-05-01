//
//  HomeViewController.swift
//  Zinging
//
//  Created by Abu Nabe on 3/1/21.
//d
import UIKit
import AVKit
import AVFoundation
import FirebaseAuth
import FirebaseDatabase
import GoogleMobileAds

class HomeView: UIViewController
{
    //    var ads: [Ad] = []
    
    let cellid = "StoryID"
    var storydata: [UserData] = [UserData]()
//    var postdata: [PostData] = [PostData]()
    var tableViewItems = [AnyObject]()
        
    var postArray = [HomePostData]()
    
    var handleOne = DatabaseHandle()
    let databaseRef = Database.database().reference()
    var observingRefOne = Database.database().reference()
    var compileCounter: Int = 0

    var postText = UITextView()
    
    var adLoader: GADAdLoader!
    //    var nativeAd: GADNativeAd!
    
    var nativeAdView1: GADUnifiedNativeAd!
    
    var nativeAds: [GADUnifiedNativeAd] = [GADUnifiedNativeAd]()
    
    
    private let iconView: UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(systemName: "magnifyingglass")
        imageview.contentMode = .scaleAspectFit
        imageview.tintColor = .black
        imageview.clipsToBounds = true
        imageview.layer.borderWidth = 2
        imageview.layer.borderColor = UIColor.systemGreen.cgColor
        imageview.backgroundColor = .white
    
        return imageview
    }()
    
    private let plusView: UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(systemName: "plus")?.withRenderingMode(.alwaysOriginal)
        
        return imageview
    }()
    
    private var collectionView: UICollectionView?
    
    private let tableview: UITableView =
        {
            let tableview = UITableView()
            
            return tableview
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(iconView)
        view.addSubview(plusView)
        
        
        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.isTranslucent = true
        
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false

        let height = navigationController!.navigationBar.frame.size.height
        let weight = height
        iconView.frame = CGRect(x: view.width/2-height/2, y: 0, width: weight, height: height)
        iconView.layer.cornerRadius = iconView.frame.size.width/2
               
        
        plusView.frame = CGRect(x: 10, y: navigationController!.navigationBar.frame.size.height/4, width: weight/2, height: height/2)
        
        
                
        let tap = UITapGestureRecognizer(target: self, action: #selector(HomeIcon))
        tap.numberOfTapsRequired = 1
        iconView.isUserInteractionEnabled = true
        iconView.addGestureRecognizer(tap)
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(AddPhoto))
        tap1.numberOfTapsRequired = 1
        plusView.isUserInteractionEnabled = true
        plusView.addGestureRecognizer(tap1)
        
        NoUserFound()
        self.edgesForExtendedLayout = []
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        postArray.removeAll()
    }
    
    func configureIcon()
    {
        let ref = Database.database().reference()
        let Auth = FirebaseAuth.Auth.auth().currentUser!.uid
        ref.child("Users").child(Auth).observe(.value) { (snapshot) in
            if snapshot.exists()
            {
                let userObjects = snapshot.value as! [String: AnyObject]
                
                if snapshot.hasChild("profileimage")
                {
                    let image = userObjects["profileimage"]
                    let url = URL(string: image as! String)
                    URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                        
                        if let error = error {
                            print("There was an error fetching the image from the url: \n", error)
                        }
                        
                        if let data = data, let profilePicture = UIImage(data: data) {
                            DispatchQueue.main.async() {
                                self.iconView.image = profilePicture // Set the profile picture
                            }
                        } else {
                            print("Something is wrong with the image data")
                        }
                        
                    }).resume()
                }
            }
        }
    }
    
    func configureFriend()
    {
        let ref = Database.database().reference()
        guard let Auth = FirebaseAuth.Auth.auth().currentUser?.uid else {
            return
        }
        
        ref.child("Message").child(Auth).observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists()
            {
                for users in snapshot.children.allObjects as![FirebaseDatabase.DataSnapshot] {
                    let friendid1 = users.key
                    
                    self.FriendPost(String: friendid1)
                }
            }else {
                
            }
        }
    }
    
    func FriendPost(String: String)
    {
        let ref = Database.database().reference()
    
        let currentDate = Date()
            let since1970 = currentDate.timeIntervalSince1970
        
        ref.child("Posts").observe(.value) { (snapshot) in
            for posts in snapshot.children.allObjects as![FirebaseDatabase.DataSnapshot] {
                
                let postId = posts.key
                ref.child(postId).queryOrdered(byChild: "timestamp").queryStarting(atValue: since1970).observeSingleEvent(of: .value) { (snapshot) in
                    let postData = HomePostData(snapshot: posts)

                    if postData.publisher == String
                    {
                        self.postArray.insert(postData, at: 0)
                    }
                    
                    self.tableview.reloadData()
                }
                
            }
        }
    }
    
    func configureAds()
    {        
        let multipleAdsOptions = GADMultipleAdsAdLoaderOptions()
        multipleAdsOptions.numberOfAds = 5
        
        adLoader = GADAdLoader(adUnitID: "ca-app-pub-3940256099942544/3986624511", rootViewController: self,
                               adTypes: [GADAdLoaderAdType.unifiedNative],
                               options: [multipleAdsOptions])
        adLoader.delegate = self
        adLoader.load(GADRequest())
    }
    
    func configureStory()
    {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 65, height: 60)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView?.frame = CGRect(x: 0, y: navigationController!.navigationBar.frame.height, width: view.width, height: 60)
        collectionView?.backgroundColor = .systemGreen
        collectionView?.showsHorizontalScrollIndicator = false
        
        view.addSubview(collectionView!)
        
        collectionView?.register(StoryCell.self, forCellWithReuseIdentifier: StoryCell.identifier)
        
        collectionView?.delegate = self
        collectionView?.dataSource = self
    }
    
    func configureData()
    {
        guard let Auth = FirebaseAuth.Auth.auth().currentUser?.uid else {
            return
        }
        
        let ref = Database.database().reference()
        
        let currentDate = Date()
        let since1970 = currentDate.timeIntervalSince1970
        
        ref.child("Message").child(Auth).queryOrdered(byChild: "timestamp").queryStarting(atValue: since1970).observeSingleEvent(of: .value) { (snapshot) in
            for users in snapshot.children.allObjects as![FirebaseDatabase.DataSnapshot] {
                let friendid = users.key
                ref.child("Users").child(friendid).observeSingleEvent(of: .value) { (snapshot) in
                    
                    let userObjects = snapshot.value as? [String: AnyObject]
                    let username = userObjects?["username"]
                    let status = userObjects?["online"]  as? String ?? ""
                    
                    let image = userObjects?["profileimage"] as? String ?? ""
                    
                    let key = snapshot.key
                    
                    let MessageUsers = UserData(image: image, text: username as! String, Activity: status , id: key)
                    
                    self.storydata.insert(MessageUsers, at: 0)
                    self.collectionView?.reloadData()
                }
            }
        }
    }
    
    func configureTableView()
    {
        tableview.register(HomePostCell.self, forCellReuseIdentifier: cellid)
        //
        //        tableview.register(NativeAds.self, forCellReuseIdentifier: "NativeAds")
        tableview.register(UINib(nibName: "UnifiedNativeAdView", bundle: nil),
                           forCellReuseIdentifier: "UnifiedNativeAdView")
        
        view.addSubview(tableview)
        tableview.anchor(top: collectionView?.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        
        tableview.separatorStyle = .none
        tableview.showsVerticalScrollIndicator = false
        
        //previos was 450
        tableview.rowHeight = 450
        
        //        tableview.scrollsToTop = NO;
        
        tableview.dataSource = self
        tableview.delegate = self
    }
    
    func configurePost()
    {
        let ref = Database.database().reference()
        ref.child("Posts").observe(.value) { (snapshot) in
            self.postArray.removeAll()
            for posts in snapshot.children.allObjects as![FirebaseDatabase.DataSnapshot] {
                self.loadPost(posts)
            }
        }
    }
    
    func checkHobby()
    {
        let ref = Database.database().reference()
        guard let Auth = FirebaseAuth.Auth.auth().currentUser?.uid else {
            return
        }
        
        ref.child("Users").child(Auth).child("hobbyname").observe(.value) { (snapshot) in
            if snapshot.exists()
            {
                
            }else{
                let storyboard = UIStoryboard(name: "HobbyPicker", bundle: nil)
                let secondViewController = storyboard.instantiateViewController(withIdentifier: "HobbyPicker") as! HobbyPicker
                secondViewController.modalPresentationStyle = .fullScreen
                self.present(secondViewController, animated: true)
            }
        }
    }
    
//    func configurePostData()
//    {
//        guard let Auth = FirebaseAuth.Auth.auth().currentUser?.uid else
//        {
//            return
//        }
//
//        //        print(friendid)
//        let ref = Database.database().reference()
//
//        ref.child("Posts").observe(.value) { (snapshot) in
//            for posts in snapshot.children.allObjects as![FirebaseDatabase.DataSnapshot] {
//                self.postdata.removeAll()
//                let postid = posts.key
//                ref.child("Posts").child(postid).observe(.value) { (snapshot) in
//
//
//                    let postObjects = snapshot.value as? [String: AnyObject]
//
//                    let postimage = postObjects?["postimage"] as? String ?? ""
//                    let postpublisher = postObjects?["publisher"] as? String ?? ""
//                    let timestamp = postObjects?["timestamp"] as? TimeInterval ?? 0
//
//                    let postList = PostData(postimage: postimage, publisher: postpublisher, timestring: postid, timestamp: timestamp)
//
//                    if postpublisher == Auth
//                    {
//                        self.postdata.insert(postList, at: 0)
//                    }
//                    self.tableview.reloadData()
//                }
//            }
//        }
//    }
    
    func listenDeletes() {
        
       let ref = Database.database().reference().child("Posts")

        ref.observe(.value) { (snapshot) in
            for posts in snapshot.children.allObjects as![FirebaseDatabase.DataSnapshot] {
                let key = posts.key
                ref.child(key).observe(.childRemoved, with: { [self] postSnapshot in
                    if let index = self.postArray.firstIndex(where: {$0.postID == key}) {

                        self.postArray.remove(at: index)
                        self.compileCounter -= 1
                        self.tableview.deleteRows(at: [IndexPath(item: index, section: 0)], with: .none)
                        
                        
                 }
               })
            }
        }
     }
    
    @objc private func AddPhoto()
    {
        
        let storyboard = UIStoryboard(name: "HomeIcon", bundle: nil)
        let VC = storyboard.instantiateViewController(identifier: "HomeIcon") as! HomeIcon
        self.present(VC, animated: true, completion: nil)
    }
    
    @objc private func HomeIcon()
    {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Search", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "Search") as! Search
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    func loadPost(_ postSnapshot: DataSnapshot) {
        let postId = postSnapshot.key
        
        let auth = FirebaseAuth.Auth.auth().currentUser!.uid
        let ref = Database.database().reference().child("Posts")
        
        let currentDate = Date()
            let since1970 = currentDate.timeIntervalSince1970
        
        ref.child(postId).queryOrdered(byChild: "timestamp").queryStarting(atValue: since1970).observeSingleEvent(of: .value) { (snapshot) in
            let postData = HomePostData(snapshot: postSnapshot)

            if postData.publisher == auth
            {
                self.postArray.insert(postData, at: 0)
            }
            self.tableview.reloadData()
        }
    }
    
    private func NoUserFound()
    {
        if Auth.auth().currentUser == nil{
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let secondViewController = storyboard.instantiateViewController(withIdentifier: "Login") as! Login
            self.navigationController?.pushViewController(secondViewController, animated: true)
            
            
        }else {
            let Auth = FirebaseAuth.Auth.auth().currentUser!.uid
            let pushManager = PushNotificationManager(userID: Auth)
            pushManager.registerForPushNotifications()

            let date = Date() // current date
            let timestamp = date.toMilliseconds()

            let ref1 = Database.database().reference().child("Users").child(Auth).child("online")
            ref1.setValue("Online")
            ref1.onDisconnectSetValue(timestamp)


            self.postArray.removeAll()
            self.storydata.removeAll()

            configureData()
            configureStory()
            checkHobby()

//            configurePostData()
            listenDeletes()
            configureIcon()
            
//            loadFeed()
            configurePost()
            
            configureFriend()
            
            configureTableView()
            configureAds()
        }
    }
    
}

extension HomeView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return storydata.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoryCell.identifier, for: indexPath) as! StoryCell
        
        let items = storydata[indexPath.row]
        
        let name = items.text
        cell.NameLabel.text = name
        let id = items.id
        let ref = Database.database().reference()
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ShowStory(sender:)))
        tap.numberOfTapsRequired = 1
        cell.profileImageView.isUserInteractionEnabled = true
        cell.profileImageView.addGestureRecognizer(tap)
        
        ref.child("Users").child(id).observe(.value) { (snapshot) in
            if snapshot.exists()
            {
                if snapshot.hasChild("profileimage")
                {
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
                            cell.profileImageView.image = UIImage(systemName: "person.fill")?.withRenderingMode(.alwaysOriginal)
                            print("Something is wrong with the image data")
                        }
                        
                    }).resume()
                }
            }
        }
        
        return cell
    }
    
    @objc func ShowStory(sender: UITapGestureRecognizer)
    {
        let touch = sender.location(in: collectionView)
        if let indexPath = collectionView?.indexPathForItem(at: touch){
            let data = storydata[indexPath.row]
            let id = data.id
            let popupVC = Story()
            popupVC.modalPresentationStyle = .overCurrentContext
            popupVC.modalTransitionStyle = .crossDissolve
            popupVC.StoryID = id
            present(popupVC, animated: true, completion: nil)
        }
        
    }
}

extension HomeView: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
//            + nativeAds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row % 100 == 0 && nativeAds.count > indexPath.row / 100
        {
            /// Set the native ad's rootViewController to the current view controller.
            
            //            let nativeAdCell = tableView.dequeueReusableCell(
            //                withIdentifier: "UnifiedNativeAdView", for: indexPath) as! NativeAds
            //            let nativeAd = nativeAds[indexPath.row]
            //            nativeAdCell.layer.masksToBounds = true
            //
            //            (nativeAdCell.headlineView!).text = nativeAd.headline
            //            (nativeAdCell.priceView!).text = nativeAd.price
            //            nativeAdCell.mediaView.mediaContent = nativeAd.mediaContent
            //
            //            (nativeAdCell.IconView)?.image = nativeAd.icon?.image
            //            nativeAdCell.IconView?.isHidden = nativeAd.icon == nil
            ////                 if let starRating = nativeAd.starRating {
            ////                   (nativeAdCell.starRatingView as! UILabel).text =
            ////                       starRating.description + "\u{2605}"
            ////                 } else {
            ////                   (nativeAdCell.starRatingView as! UILabel).text = nil
            ////                 }
            ////            nativeAdCell.mediaView = nativeAd.images
            //            (nativeAdCell.bodyView!).text = nativeAd.body
            //            (nativeAdCell.AdvertiserView!).text = nativeAd.advertiser
            //                 // The SDK automatically turns off user interaction for assets that are part of the ad, but
            //                 // it is still good to be explicit.
            //            (nativeAdCell.callToActionView!).isUserInteractionEnabled = false
            //            (nativeAdCell.callToActionView!).setTitle(
            //                    nativeAd.callToAction, for: UIControl.State.normal)
            
            //            return nativeAdCell
            return UITableViewCell()
        }else {
            let cell = tableview.dequeueReusableCell(withIdentifier: cellid, for: indexPath) as! HomePostCell
           
            let items = postArray[indexPath.row]
            
            let picture = items.postimage
            let postString = items.timestring
            
            let timestamp = items.timestamp
            
            
            let url = URL(string: picture)
            
            cell.contentView.isUserInteractionEnabled = false
            
            cell.postPublisher = items.publisher
            
            cell.postID = self.postArray[indexPath.row].timestring
            
            cell.profileImageView.tag = indexPath.row
            
            let ref = Database.database().reference()
            let Auth = FirebaseAuth.Auth.auth().currentUser!.uid
            
            
            let date = Date(timeIntervalSince1970: timestamp / 1000)
            let timeAgo = timeAgoSince(date)
            
            cell.TimeLabel.text = timeAgo
            
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
            
            ref.child("Dislikes").child(postString).child(Auth).observe(.value) { (snapshot) in
                if snapshot.exists()
                {
                    cell.Disliked = "Yes"
                    cell.DislikeImage.image = UIImage(systemName: "face.smiling")
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
            
            
            ref.child("Users").child(items.publisher).child("points").observe(.value) { (snapshot) in
                if snapshot.exists()
                {
                    let pointcount: Int = Int(snapshot.childrenCount)
                    
                    cell.PointsLabel.text = String(pointcount)
                }
            }
            
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
                            cell.profileImageView.image = UIImage(systemName: "person.fill")?.withRenderingMode(.alwaysOriginal)
                            print("Something is wrong with the image data")
                        }
                        
                    }).resume()
                }
              }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        // Delete the row from the data source
//        if editingStyle == UITableViewCell.EditingStyle.delete {
//
//                if let table = self.table {
//
//                self.postdata.remove(at: [(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row])
//
//                    table.deleteRows(at: [indexPath], with: UITableView.RowAnimation.left )
//
//                }
//        }
    }
    
    private func tableView(_ tableView: UITableView, willDisplay cell: UITableView,
                                   forRowAt indexPath: IndexPath) {
        if indexPath.row == (compileCounter - 1) {
            loadFeed()
        }
        
      }
    
    func loadFeed() {
        
        let postsRef = Database.database().reference().child("Posts")
       if !postArray.isEmpty {
        
         for post in postArray {
            postsRef.child(post.postID).observeSingleEvent(of: .value, with: {
                
             if $0.exists() {
//               self.updatePost(post, postSnapshot: $0)
//               self.listenPost(post)
             } else {
               if let index = self.postArray.firstIndex(where: {$0.postID == post.postID}) {
                 self.postArray.remove(at: index)
                 self.compileCounter -= 1
                self.tableview.deleteRows(at: [IndexPath(item: index, section: 0)], with: .none)
               }
             }
           })
         }
       } else {
        
//         compileCounter = postArray.count + HomeView.postsPerLoad
//         query?.queryLimited(toLast: HomeView.postsLimit).observeSingleEvent(of: .value, with: { snapshot in
           
//           if let reversed = snapshot.children.allObjects as? [DataSnapshot], !reversed.isEmpty {
//             self.collectionView?.backgroundView = nil
//             self.nextEntry = reversed[0].key
//             var results = [Int: DataSnapshot]()
//             let myGroup = DispatchGroup()
//             let extraElement = reversed.count > FPFeedViewController.postsPerLoad ? 1 : 0
//             self.collectionView?.performBatchUpdates({
//               for index in stride(from: reversed.count - 1, through: extraElement, by: -1) {
//                 let item = reversed[index]
//                 if self.showFeed {
//                   self.loadPost(item)
//                 } else {
//                   myGroup.enter()
//                   let current = reversed.count - 1 - index
//                   self.postsRef.child(item.key).observeSingleEvent(of: .value) {
//                     results[current] = $0
//                     myGroup.leave()
//                   }
//                 }
//               }
//               myGroup.notify(queue: .main) {
//                 if !self.showFeed {
//                   for index in 0..<(reversed.count - extraElement) {
//                     if let snapshot = results[index] {
//                       if snapshot.exists() {
//                         self.loadPost(snapshot)
//                       } else {
//                         self.loadingPostCount -= 1
//                         self.database.reference(withPath: "feed/\(self.uid)/\(snapshot.key)").removeValue()
//                       }
//                     }
//                   }
//                 }
//               }
//             }, completion: nil)
//           } else if self.posts.isEmpty && !self.showFeed {
//             if self.isFirstOpen {
//               self.feedAction()
//               self.isFirstOpen = false
//             } else {
//               self.collectionView?.backgroundView = self.emptyHomeLabel
//             }
//           }
//         })
       }
    }
    
    @objc func ImageOption(sender: UITapGestureRecognizer)
    {
        
            let touch = sender.location(in: tableview)
            let ref = Database.database().reference()
        
        if !postArray.isEmpty {
            if let indexPath = tableview.indexPathForRow(at: touch) {
                let items = postArray[indexPath.row]
                    let auth = FirebaseAuth.Auth.auth().currentUser!.uid
                    if items.publisher == auth{
              
                let alert = UIAlertController(title: "Delete this post", message: "Are you sure you want to delete this post?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {(action:UIAlertAction!) in
                    ref.child("Posts").child(items.timestring).removeValue()
                    ref.child("Users").child(items.publisher).child("post").child(items.timestring).removeValue()
                    ref.child("PostNotifications").child(items.timestring).removeValue()
                    self.listenDeletes()
                    self.tableview.reloadData()
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
        let touch = sender.location(in: tableview)
        if let indexPath = tableview.indexPathForRow(at: touch) {
            let items = postArray[indexPath.row]
            
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
        let touch = sender.location(in: tableview)
        if let indexPath = tableview.indexPathForRow(at: touch) {
            let items = postArray[indexPath.row]
            let id = items.publisher
            let auth = FirebaseAuth.Auth.auth().currentUser!.uid
            if id == auth
            {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let secondViewController = storyboard.instantiateViewController(withIdentifier: "ProfileView") as! ProfileView
                self.navigationController?.pushViewController(secondViewController, animated: true)
            }else {
                let storyBoard: UIStoryboard = UIStoryboard(name: "AddProfile", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "AddProfile") as! AddProfile
                newViewController.Userid = id
                self.navigationController?.pushViewController(newViewController, animated: true)
            }
        }
    }
    @objc func GoToLink(sender: UITapGestureRecognizer)
    {
        let touch = sender.location(in: tableview)
        if let indexPath = tableview.indexPathForRow(at: touch) {
            let items = postArray[indexPath.row]
            let id = items.publisher
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "PersonalLinks", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "PersonalLinks") as! PersonalLinks
            newViewController.Userid = id
            self.navigationController?.present(newViewController, animated: true)
        }
    }
}

extension HomeView: GADUnifiedNativeAdLoaderDelegate, GADNativeAdDelegate
{
    
    func adLoader(_ adLoader: GADAdLoader,
                  didFailToReceiveAdWithError error: GADRequestError) {
        print("\(adLoader) failed with error: \(error.localizedDescription)")
        
    }
    
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADUnifiedNativeAd) {
        print("Received native ad: \(nativeAd)")
        
        //         Add the native ad to the list of native ads.
//        nativeAds.append(nativeAd)
        
        //        tableViewItems = nativeAds + postArray
        
    }
    
    func adLoaderDidFinishLoading(_ adLoader: GADAdLoader) {
        //      enableMenuButton()
        print("yessir")
        //        postdata.removeAll()
        //        addNativeAds()
        //        print(nativeAds)
    }
}
//code to center, hope to find how to
