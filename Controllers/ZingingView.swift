//
//  ZingingViewController.swift
//  Zinging
//
//  Created by Abu Nabe on 3/1/21.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import AVKit
import AVFoundation

class ZingingView: UIViewController
{
    
    var picdata: [ZingingPicData] = [ZingingPicData]()
    
    var viddata: [ZingingVidData] = [ZingingVidData]()
    
    var postdata: [ZingingData] = [ZingingData]()
    
    var refresh = UIRefreshControl()
    
    var collectionView: UICollectionView?
    
    var PostType = "Explore"
    
    var LayoutType = "Normal"
    
    let Title: UILabel = {
        let text = UILabel()
        text.text = "HobbyStar"
        text.textColor = .green
        text.font = .italicSystemFont(ofSize: 16)
        return text
    }()
    
    let Zings: UILabel = {
        let text = UILabel()
        text.text = "Zings"
        text.textColor = .white
        text.backgroundColor = .green
        text.font = .italicSystemFont(ofSize: 12)
        return text
    }()
    
    let Explore: UILabel = {
        let text = UILabel()
        text.text = "Explore"
        text.textColor = .white
        text.backgroundColor = .green
        text.textAlignment = .center
        text.font = .italicSystemFont(ofSize: 18)
        return text
    }()
    
    let Interest: UILabel = {
        let text = UILabel()
        text.text = "Interest"
        text.textColor = .white
        text.backgroundColor = .green
        text.textAlignment = .center
        text.font = .italicSystemFont(ofSize: 18)
        return text
    }()
    
    let AllPicsView: UILabel = {
        let text = UILabel()
        text.text = "All Pics"
        text.textColor = .green
        text.font = .italicSystemFont(ofSize: 14)
        return text
    }()
    
    let AllVidsView: UILabel = {
        let text = UILabel()
        text.text = "All Vids"
        text.textColor = .green
        text.font = .italicSystemFont(ofSize: 14)
        return text
    }()
    
    let Line: UIView = {
        let text = UIView()
        text.backgroundColor = .black
        return text
    }()
    
    let Line1: UIView = {
        let text = UIView()
        text.backgroundColor = .black
        return text
    }()
    
    let Line2: UIView = {
        let text = UIView()
        text.backgroundColor = .black
        return text
    }()
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(PictureIMG.self, forCellReuseIdentifier: "PictureCell")
        
        return tableView
    }()
    
    private let tableView1: UITableView = {
        let tableView = UITableView()
        tableView.register(VideoIMG.self, forCellReuseIdentifier: "VideoCell")
        
        return tableView
    }()
    
    
    let SquareImage: UIImageView = {
        var imageview = UIImageView()
        imageview.image = UIImage(systemName: "square.grid.3x3.fill")
        
        return imageview
    }()
    
    
    private let StaradView: UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(named: "star_plus")!.withRenderingMode(.alwaysOriginal)

        return imageview
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(Explore)
        view.addSubview(Interest)
        view.addSubview(Line1)
        view.addSubview(Line2)
        view.addSubview(AllPicsView)
        view.addSubview(AllVidsView)
        view.addSubview(tableView)
        view.addSubview(tableView1)
        view.addSubview(SquareImage)
//        view.addSubview(StaradView)
        let date = Date() // current date
        let timestamp = date.toMilliseconds()
        
        let Auth = FirebaseAuth.Auth.auth().currentUser!.uid
        let ref = Database.database().reference().child("Users").child(Auth).child("online")
        ref.setValue("Online")
        ref.onDisconnectSetValue(timestamp)
        
        NavigationBar()
        
        SetUpMenuBar()
        
        picdata.removeAll()
        viddata.removeAll()
        postdata.removeAll()
        
        tableView.delegate = self
        tableView.dataSource = self
        ConfigureTableViewData()
        
        tableView1.delegate = self
        tableView1.dataSource = self
        ConfigureTableView1Data()
        
        listenDeletes()
        
        Line2.isHidden = true
        
        
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
        
        
        self.edgesForExtendedLayout = []
        
        let AllPics = UITapGestureRecognizer(target: self, action: #selector(AllPics1))
        AllPics.numberOfTapsRequired = 1
        AllPicsView.isUserInteractionEnabled = true
        AllPicsView.addGestureRecognizer(AllPics)
        
        let AllVids = UITapGestureRecognizer(target: self, action: #selector(AllVids1))
        AllVids.numberOfTapsRequired = 1
        AllVidsView.isUserInteractionEnabled = true
        AllVidsView.addGestureRecognizer(AllVids)
        
        AllPicsView.anchor(top: Line1.bottomAnchor, left: view.leftAnchor, paddingTop: 2)
        AllVidsView.anchor(top: Line1.bottomAnchor, right: view.rightAnchor, paddingTop: 2)
        
        refresh.addTarget(self, action: #selector(ConfigureTableView1Data), for: .valueChanged)
        
        let Squaretap = UITapGestureRecognizer(target: self, action: #selector(ChangeLayout))
        Squaretap.numberOfTapsRequired = 1
        SquareImage.isUserInteractionEnabled = true
        SquareImage.addGestureRecognizer(Squaretap)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        Explore.frame = CGRect(x: 0, y: 0, width: view.width/2, height: menuBar.height)
        Interest.frame = CGRect(x: view.width/2, y: 0, width: view.width/2, height: menuBar.height)
        let tap = UITapGestureRecognizer(target: self, action: #selector(ExploreData))
        tap.numberOfTapsRequired = 1
        Explore.isUserInteractionEnabled = true
        Explore.addGestureRecognizer(tap)
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(InterestData))
        tap1.numberOfTapsRequired = 1
        Interest.isUserInteractionEnabled = true
        Interest.addGestureRecognizer(tap1)
        
        tableView.anchor(top: AllPicsView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, width: view.width/2)
        tableView.rowHeight = view.height/2-30
        tableView.showsVerticalScrollIndicator = false
        
        tableView1.anchor(top: AllPicsView.bottomAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, width: view.width/2)
        
        tableView1.rowHeight = view.height/2-30
        tableView1.showsVerticalScrollIndicator = false
        
        SquareImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        SquareImage.anchor(top: Line1.bottomAnchor)
        
        Line.frame = CGRect(x: view.width/2, y: 0, width: 1, height: menuBar.height)
        Line1.frame = CGRect(x: 0, y: Explore.frame.origin.y+Explore.frame.size.height, width: view.width/2, height: 1)
        Line2.frame = CGRect(x: view.width/2, y: Interest.frame.origin.y+Interest.frame.size.height, width: view.width/2, height:1)
        
//        StaradView.centerYAnchor.constraint(equalTo: navigationController!.navigationBar.centerYAnchor).isActive = true
//        StaradView.anchor(paddingTop: 10,paddingLeft: 5, width: 35, height: 35)
    }
    
    @objc func ChangeLayout()
    {
        if LayoutType == "Normal"
        {
            LayoutType = "Grid"
            
            configureData()

            tableView.isHidden = true
            tableView1.isHidden = true

            collectionView?.isHidden = false
            
            let layout = UICollectionViewFlowLayout()
            collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
            
            collectionView?.backgroundColor = .white
            collectionView?.showsVerticalScrollIndicator = false
            collectionView?.frame = view.bounds
            
            view.addSubview(collectionView!)
            
            collectionView?.anchor(top: AllPicsView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
            
            collectionView?.register(ProfileCell.self, forCellWithReuseIdentifier: ProfileCell.identifier)
            
            collectionView?.delegate = self
            collectionView?.dataSource = self
            
            
        }else if LayoutType == "Grid"{
            print("wtf")
            LayoutType = "Normal"

            postdata.removeAll()
            collectionView?.reloadData()
            
            tableView.isHidden = false
            tableView1.isHidden = false
            
            collectionView?.backgroundColor = .black
            collectionView!.alpha = 0

            tableView.backgroundColor = .black
        }
    }
    
    func configureData()
    {
        let ref = Database.database().reference()
        
        ref.child("ZingingPosts").observe(.value) { (snapshot) in
            for users in snapshot.children.allObjects as![FirebaseDatabase.DataSnapshot] {
                self.postdata.removeAll()
                let notifid = users.key
                ref.child("ZingingPosts").child(notifid).observeSingleEvent(of: .value) { (snapshot) in
                    let postnotiflist = ZingingData(snapshot: users)
                    self.postdata.insert(postnotiflist, at: 0)
                    
                    self.collectionView?.reloadData()
                }
            }
        }
    }
    
    @objc func ExploreData()
    {
        PostType = "Explore"
        
        Line1.isHidden = false
        Line2.isHidden = true
        
        picdata.removeAll()
        viddata.removeAll()
        tableView.reloadData()
        tableView1.reloadData()
        
        ConfigureTableViewData()
        ConfigureTableView1Data()
        
    }
    
    @objc func InterestData()
    {
        PostType = "Interest"
        
        if LayoutType == "Normal"
        {
            Line1.isHidden = true
            Line2.isHidden = false
            
            picdata.removeAll()
            viddata.removeAll()
            tableView.reloadData()
            tableView1.reloadData()
            
            let ref = Database.database().reference()
            let Auth = FirebaseAuth.Auth.auth().currentUser!.uid
            ref.child("Interest").child(Auth).observe(.value) { [self] (snapshot) in
                if snapshot.exists(){
                    for obj in snapshot.children.allObjects as! [FirebaseDatabase.DataSnapshot]
                    {
                        let key = obj.key
                        ConfigureInterestData(String: key)
                        ConfigureInterestData1(String: key)
                    }
                }
            }
        }else
        {
            Line1.isHidden = true
            Line2.isHidden = false
            
            let ref = Database.database().reference()
            let Auth = FirebaseAuth.Auth.auth().currentUser!.uid
            ref.child("Interest").child(Auth).observe(.value) { [self] (snapshot) in
                if snapshot.exists(){
                    for obj in snapshot.children.allObjects as! [FirebaseDatabase.DataSnapshot]
                    {
                        let key = obj.key
                        ConfigureInterestData2(String: key)
                    }
                }
            }
        }
    }
    
    func ConfigureInterestData2(String: String)
    {
        let ref = Database.database().reference()
        
        ref.child("ZingingPosts").observe(.value) { (snapshot) in
            for users in snapshot.children.allObjects as![FirebaseDatabase.DataSnapshot] {
                let notifid = users.key
                ref.child("ZingingPosts").child(notifid).observeSingleEvent(of: .value) { (snapshot) in
                    
                    let postnotiflist = ZingingData(snapshot: users)
                    
                    if postnotiflist.publisher == String{
                        self.postdata.insert(postnotiflist, at: 0)
                    }
                }
                self.collectionView?.reloadData()
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
//                        self.compileCounter -= 1
                        print("Wtf?")
                        self.tableView.deleteRows(at: [IndexPath(item: index, section: 0)], with: .none)
                        
                        self.picdata.removeAll()
                 }
               })
            }
        }
        
        let ref1 = Database.database().reference().child("Videos")

         ref1.observe(.value) { (snapshot) in
             for posts in snapshot.children.allObjects as![FirebaseDatabase.DataSnapshot] {
                 let key = posts.key
                 ref1.child(key).observe(.childRemoved, with: { [self] postSnapshot in
                     if let index = self.viddata.firstIndex(where: {$0.timestring == key}) {

                         self.viddata.remove(at: index)
 //                        self.compileCounter -= 1
                         print("Wtf?")
                         self.tableView1.deleteRows(at: [IndexPath(item: index, section: 0)], with: .none)
                         
                         self.viddata.removeAll()
                  }
                })
             }
         }
        
        let ref2 = Database.database().reference().child("ZingingPosts")

         ref2.observe(.value) { (snapshot) in
             for posts in snapshot.children.allObjects as![FirebaseDatabase.DataSnapshot] {
                 let key = posts.key
                 ref2.child(key).observe(.childRemoved, with: { [self] postSnapshot in
                     if let index = self.postdata.firstIndex(where: {$0.timestring == key}) {

                         self.postdata.remove(at: index)
 //                        self.compileCounter -= 1
                         print("Wtf?")
                         self.collectionView?.deleteItems(at: [IndexPath(item: index, section: 0)])
                         
                         self.postdata.removeAll()
                  }
                })
             }
         }
     }
    
    
    func ConfigureInterestData(String: String)
    {
        let ref = Database.database().reference()
        
        ref.child("Pics").observe(.value) { (snapshot) in
            self.picdata.removeAll()
            for pics in snapshot.children.allObjects as![FirebaseDatabase.DataSnapshot] {
                let key = pics.key
                ref.child("Pics").child(key).observe(.value) { (snapshot) in
                    
                    let picList = ZingingPicData(snapshot: pics)
                    
                    if picList.publisher == String
                    {
                        self.picdata.insert(picList, at: 0)
                    }
                    
                    self.tableView.reloadData()
                    
                }
            }
        }
    }
    
    func ConfigureInterestData1(String: String)
    {
        let ref = Database.database().reference()
        
        ref.child("Videos").observe(.value) { (snapshot) in
            self.viddata.removeAll()
            for pics in snapshot.children.allObjects as![FirebaseDatabase.DataSnapshot] {
                let key = pics.key
                ref.child("Videos").child(key).observe(.value) { (snapshot) in
                    
                    let picList = ZingingVidData(snapshot: pics)
                                        
                    if picList.publisher == String
                    {
                        self.viddata.insert(picList, at: 0)
                    }
                    
                    self.tableView1.reloadData()
                    
                }
                self.refresh.endRefreshing()
            }
        }
    }
    
    @objc func ConfigureTableViewData()
    {
        let ref = Database.database().reference()
                
        ref.child("Pics").observe(.value) { (snapshot) in
            self.picdata.removeAll()
            for pics in snapshot.children.allObjects as![FirebaseDatabase.DataSnapshot] {
                let key = pics.key
                ref.child("Pics").child(key).observeSingleEvent(of: .value) { (snapshot) in
                    let zingingData = ZingingPicData(snapshot: pics)
                    
                        if self.PostType == "Explore"
                        {
                            self.picdata.insert(zingingData, at: 0)
                        }
                        
                        self.tableView.reloadData()
                        
                    }
                }
            }
    }
    
    @objc func ConfigureTableView1Data()
    {
        let ref = Database.database().reference()
        
        ref.child("Videos").observe(.value) { (snapshot) in
            self.viddata.removeAll()
            for pics in snapshot.children.allObjects as![FirebaseDatabase.DataSnapshot] {
                let key = pics.key
                ref.child("Videos").child(key).observe(.value) { (snapshot) in
                    
                    let picList = ZingingVidData(snapshot: pics)
                    
                    if self.PostType == "Explore"
                    {
                        self.viddata.insert(picList, at: 0)
                    }
                    
                    self.tableView1.reloadData()
                    
                }
                self.refresh.endRefreshing()
            }
        }
    }
    
    @objc func AllPics1()
    {
        let storyBoard: UIStoryboard = UIStoryboard(name: "AllPostsZinging", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "AllPostsZinging") as! AllPostsZinging
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    @objc func AllVids1()
    {
        let storyBoard: UIStoryboard = UIStoryboard(name: "AllVideosZinging", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "AllVideosZinging") as! AllVideosZinging
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    let menuBar: MenuBar = {
        let mb = MenuBar()
        
        return mb
    }()
    
    private func SetUpMenuBar()
    {
        view.addSubview(menuBar)
        menuBar.isUserInteractionEnabled = false
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: menuBar)
        view.addConstraintsWithFormat(format: "V:|[v0(50)]|", views: menuBar)
    }
    func NavigationBar(){
        self.navigationItem.titleView = Title
        self.navigationController!.navigationBar.backgroundColor = .white
        self.navigationController!.navigationBar.isTranslucent = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done, target: self, action: #selector(Upload))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "star_plus")!.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(AdsVid))
        
        self.navigationItem.rightBarButtonItem!.tintColor = .black
    }
    
    @objc private func AdsVid()
    {
        print("mf")
        let storyBoard: UIStoryboard = UIStoryboard(name: "VideoRewardAd", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "VideoRewardAd") as! VideoRewardAd
        self.present(newViewController, animated: true)
    }
    
    @objc private func Upload()
    {
        let alert = UIAlertController(title: "Want to post a Video or an Image?", message: "Select", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Pictures", style: .default, handler: {(action:UIAlertAction!) in
            let storyBoard: UIStoryboard = UIStoryboard(name: "UploadPic", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "UploadPic") as! UploadPic
            self.present(newViewController, animated: true)
            
        }))
        alert.addAction(UIAlertAction(title: "Videos", style: .default, handler: {(action:UIAlertAction!) in
            let storyboard = UIStoryboard(name: "UploadVid", bundle: nil)
            let secondViewController = storyboard.instantiateViewController(withIdentifier: "UploadVid") as! UploadVid
            self.present(secondViewController, animated:true, completion:nil)
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
    
}
class MenuBar: UIView
{
    override init(frame:CGRect){
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIView {
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
}

extension ZingingView: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView == self.tableView
        {
            return picdata.count
        }else {
            return viddata.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PictureCell") as! PictureIMG
            
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
            return  cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell") as! VideoIMG
            
            let items = viddata[indexPath.row]
            
            let image = items.picimage
            
            let url = URL(string: image)
            
            self.getThumbnailFromImage(url: url!) { (thumbImage) in
                cell.VideoView.image = thumbImage
            }
            
            return  cell
        }
    }
    func getThumbnailFromImage(url: URL, completion: @escaping((_ image: UIImage)-> Void))
    {
        DispatchQueue.global().async {
            let asset = AVAsset(url: url)
            let avAssetImageGenerator = AVAssetImageGenerator(asset: asset)
            avAssetImageGenerator.appliesPreferredTrackTransform = true
            
            let thumbnailTime = CMTimeMake(value: 1, timescale: 1)
            do {
                let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumbnailTime, actualTime: nil)
                let thumbImage = UIImage(cgImage: cgThumbImage)
                
                DispatchQueue.main.async {
                    completion(thumbImage)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tableView{
            let items = picdata[indexPath.row]
            let id = items.timestring
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "ZingingPost", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "ZingingPost") as! ZingingPost
            newViewController.postid = id
            self.navigationController?.pushViewController(newViewController, animated: true)
        }else {
            let items = viddata[indexPath.row]
            let id = items.timestring
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "ZingingVideo", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "ZingingVideo") as! ZingingVideo
            newViewController.videoid = id
            self.navigationController?.pushViewController(newViewController, animated: true)
        }
    }
}

extension ZingingView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postdata.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileCell.identifier, for: indexPath) as! ProfileCell
        
        let items = postdata[indexPath.row]
        let picture = items.postimage
        
        print(picture)
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
                self.getThumbnailFromImage(url: url!) { (thumbImage) in
                    cell.PictureView.image = thumbImage
                }
            }
        }).resume()
        
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width/3.0
        let height = width
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}
