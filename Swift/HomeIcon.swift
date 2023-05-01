//
//  HomeIcon.swift
//  Zinging
//
//  Created by Abu Nabe on 5/1/21.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth


class HomeIcon: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    
    var url = URL.self
    var imagepicker: UIImagePickerController!
    var VALIDATION = "no"
    
    var bioLabel: UILabel = {
        let Label = UILabel()
        Label.text = ""
        Label.textColor = .black
        Label.numberOfLines = 0
        Label.sizeToFit()
        Label.font = .systemFont(ofSize: 12)
        Label.backgroundColor = .green
        return Label
    }()
    
    let profileImageView: UIImageView = {
        let profileimage = UIImageView()
        
        profileimage.contentMode = .scaleAspectFill
        profileimage.clipsToBounds = true
        profileimage.layer.borderWidth = 1
        profileimage.layer.borderColor = UIColor.black.cgColor
        profileimage.image = UIImage.init(systemName: "person.fill")?.withRenderingMode(.alwaysOriginal)
        
        return profileimage
    }()
    
    let Namelabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Username"
        label.font = .boldSystemFont(ofSize: 10)
        
        
        return label
    }()
    
    let pointLabel: UILabel = {
        let Label = UILabel()
        Label.textAlignment = .center
        Label.text = "0 points"
        Label.font = .boldSystemFont(ofSize: 12)
        return Label
    }()
    
    
    private let Search: UITextView = {
        let Search = UITextView()
        Search.textColor = .systemGreen
        Search.text = "Search"
        Search.textAlignment = .center
        return Search
    }()
    
    private let imageview: UIImageView = {
        let imageview = UIImageView()
        imageview.backgroundColor = .gray
        imageview.contentMode = UIView.ContentMode.scaleAspectFit
        
        return imageview
    }()
    
    private let textview: UITextView = {
        let textview = UITextView()
        
        return textview
    }()
    
    let fillImage: UIImageView = {
        var imageview = UIImageView()
        imageview.image = UIImage(systemName: "plus")
        imageview.tintColor = .white
        return imageview
    }()
    
    
    let NoPicLabel: UILabel = {
        let text = UILabel()
        text.text = "Choose A Picture"
        text.font = .systemFont(ofSize: 12.0)
        return text
    }()
    
    private let Publish: UIButton = {
        let Publish = UIButton()
        Publish.backgroundColor = .systemGreen
        Publish.setTitleColor(.white, for: .normal)
        Publish.layer.cornerRadius = 24;
        Publish.setTitle("Publish", for: .normal)
        
        return Publish
    }()
    
    
    @IBOutlet weak var LoadingBar: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(imageview)
        view.addSubview(Publish)
        view.addSubview(LoadingBar)
        view.addSubview(fillImage)
        view.addSubview(NoPicLabel)
        view.addSubview(bioLabel)
        view.addSubview(Namelabel)
        view.addSubview(profileImageView)
        view.addSubview(pointLabel)
        
        LoadingBar.isHidden = true
        
        configureData()
    
        let tap = UITapGestureRecognizer(target: self, action: #selector(SelectGallery))
        tap.numberOfTapsRequired = 1
        imageview.isUserInteractionEnabled = true
        imageview.addGestureRecognizer(tap)
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(SearchForUsers))
        tap1.numberOfTapsRequired = 1
        Search.isUserInteractionEnabled = true
        Search.addGestureRecognizer(tap1)
        
        Publish.addTarget(self, action: #selector(UploadPic), for: .touchUpInside)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        imageview.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        imageview.anchor(width: view.width, height: 400)
    
        Publish.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        Publish.anchor(top: imageview.bottomAnchor, paddingTop: 5, width: view.width-160, height: 52)
        
        NoPicLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        NoPicLabel.anchor(top: fillImage.bottomAnchor)
        
        fillImage.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        fillImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        fillImage.anchor(width: 200, height: 200)
        
        
        
        pointLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pointLabel.anchor(top: view.topAnchor)
        
        profileImageView.anchor(top: pointLabel.bottomAnchor, left: view.leftAnchor, paddingLeft: 5, width: 25, height: 25)
        profileImageView.layer.cornerRadius = 25/2
        
        Namelabel.anchor(top: profileImageView.topAnchor, left: profileImageView.rightAnchor)
        
        bioLabel.anchor(top: Namelabel.bottomAnchor, left: profileImageView.rightAnchor)
    }
    
    func configureData()
    {
        let ref = Database.database().reference()
        let auth = FirebaseAuth.Auth.auth().currentUser!.uid
        ref.child("Users").child(auth).observe(.value) { (snapshot) in
            let postObjects = snapshot.value as? [String: AnyObject]
            
            let name = postObjects?["username"] as! String
            self.Namelabel.text = name
            
            if snapshot.hasChild("profileimage")
            {
                let image = postObjects?["profileimage"] as! String
                let url = URL(string: image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                    
                    if let error = error {
                        print("There was an error fetching the image from the url: \n", error)
                    }
                    
                    if let data = data, let profilePicture = UIImage(data: data) {
                        DispatchQueue.main.async() { [self] in
                            profileImageView.image = profilePicture // Set the profile picture
                        }
                    } else {
                        print("Something is wrong with the image data")
                    }
                    
                }).resume()
            }
            if snapshot.hasChild("Bio")
            {
                let bio = postObjects?["Bio"] as! String
                
                self.bioLabel.text = bio
            }
        }
        ref.child("Users").child(auth).child("points").observe(.value) { (snapshot) in
            if snapshot.exists()
            {
                let pointcount: Int = Int(snapshot.childrenCount)
                
                self.pointLabel.text = String(pointcount)
            }
        }
    }
    
    @objc private func SelectGallery()
    {
        let imagepicker = UIImagePickerController()
        imagepicker.delegate = self
        
        let actionSheet = UIAlertController(title: "Choose a picture", message: "", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: .default, handler: {(action:UIAlertAction)  in
            imagepicker.sourceType = .photoLibrary
            self.present(imagepicker, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @objc func SearchForUsers()
    {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Search", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "Search") as! Search
        self.navigationController?.pushViewController(newViewController, animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func UploadPic()
    {
        
        if VALIDATION == "yes"
        {
            guard let img = imageview.image else {
                return
            }
            Publish.isUserInteractionEnabled = false
            
            LoadingBar.startAnimating()
            LoadingBar.isHidden = false
            
            if let imgData = img.jpegData(compressionQuality: 0.2)
            {
                let imgUID = NSUUID().uuidString
                let metadata = StorageMetadata()
                metadata.contentType = "img/jpeg"
                
                let storageRef = Storage.storage().reference().child("posts/").child(imgUID)
                
                let _ = storageRef.putData(imgData, metadata: metadata){ (metadata, error) in
                    guard let _ = metadata else {
                        print("error occured: \(error.debugDescription)")
                        return
                    }
                    storageRef.downloadURL(completion: { (url, error) in
                        if let urlText = url?.absoluteString {
                            self.setupUserimg(img: urlText)
                        }
                        else {
                            
                        }
                    })
                    
                }
            }
        }else {
            self.showToast(message: "No Image Selected", font: .systemFont(ofSize: 12.0))
        }
    }
    
    func  setupUserimg(img: String)
    {        
        let date = Date() // current date
        let timestamp = date.toMilliseconds()
        
        let timestring = String(timestamp)
        
        textview.text = timestring
        
        guard let userid = FirebaseAuth.Auth.auth().currentUser?.uid else {
            
            return
        }
        
        let postid = Database.database().reference().childByAutoId()
        let userData = [
            "postid": postid,
            "timestring": timestring,
            "timestamp": timestamp,
            "postimage": img,
            "publisher": userid
        ] as [String : Any]
        let setLocation = FirebaseDatabase.Database.database().reference().child("Posts").child(timestring)
        
        setLocation.setValue(userData)
        
        let postData = [
            "postid": postid,
            "timestring": timestring,
            "timestamp": timestamp,
            "postimage": img,
            "publisher": userid,
            "postText": "has a new post!",
            "posttype": "Post"
        ] as [String : Any]
        let setPost = FirebaseDatabase.Database.database().reference().child("PostNotification").child(timestring)
        
        setPost.setValue(postData)
        
        
        let countRef = Database.database().reference().child("Users").child(userid).child("post").child(timestring)
        
        countRef.setValue(true)
        
        let notifData = [
            "description": "Has a new post!",
            "publisher": userid,
            "post": img,
            "timestamp": timestamp,
            "timestring": timestring
        ] as [String : Any]
        
        let notifLocation =
            Database.database().reference().child("PostNotifications").child(timestring)
        
        notifLocation.setValue(notifData)
        
        
        self.showToast(message: "Image Uploaded", font: .systemFont(ofSize: 12.0))
        
        
        //        LoadingBar.stopAnimating()
        //        LoadingBar.isHidden = true
        self.dismiss(animated: true, completion: nil)
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        
        imageview.image = image
        
        NoPicLabel.isHidden = true
        fillImage.isHidden = true
        
        picker.dismiss(animated: true, completion: nil)
        VALIDATION = "yes"
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
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

extension Date {
    
    func toMilliseconds() -> Int64 {
        Int64(self.timeIntervalSince1970 * 1000)
    }
    
    init(milliseconds:Int) {
        self = Date().advanced(by: TimeInterval(integerLiteral: Int64(milliseconds / 1000)))
    }
}

