//
//  EditProfile.swift
//  Zinging
//
//  Created by Abu Nabe on 31/1/21.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class EditProfile: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    var profileupdate = "no"
    
    let profileImageView: UIImageView = {
        let profileimage = UIImageView()
        
        profileimage.contentMode = .scaleAspectFill
        profileimage.clipsToBounds = true
        profileimage.layer.borderWidth = 3
        profileimage.image = UIImage.init(systemName: "person.fill")
        profileimage.layer.borderColor = UIColor.red.cgColor
        return profileimage
    }()
    
    private let TextField: UITextField = {
        let TextField = UITextField()
        TextField.placeholder = "Bio"
        TextField.layer.cornerRadius = 16;
        TextField.layer.borderColor = UIColor.black.cgColor
        TextField.backgroundColor = .green
        TextField.textColor = .black
        
        return TextField
    }()
    
    private let Button: UIButton = {
        let LoginButton = UIButton()
        LoginButton.backgroundColor = .systemGreen
        LoginButton.setTitleColor(.white, for: .normal)
        LoginButton.layer.cornerRadius = 8;
        LoginButton.setTitle("Done", for: .normal)
        
        return LoginButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(profileImageView)
        view.addSubview(TextField)
        view.addSubview(Button)
        
        self.navigationItem.hidesBackButton = false
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = false
        
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.anchor(top: view.topAnchor,paddingTop: 15, width: 100, height: 100)
        profileImageView.layer.cornerRadius = 100/2
        
        TextField.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        TextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        TextField.anchor(width: view.width-50, height: 40)
        
        Button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        Button.anchor(top: TextField.bottomAnchor, paddingTop: 40, width: view.width/2-50)
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ChangeProfile))
            tap.numberOfTapsRequired = 1
            profileImageView.isUserInteractionEnabled = true
            profileImageView.addGestureRecognizer(tap)
        
        Button.addTarget(self, action: #selector(Finish), for: .touchUpInside)
        
        let ref = Database.database().reference()
        let Auth = FirebaseAuth.Auth.auth().currentUser!.uid
        
        ref.child("Users").child(Auth).observe(.value) { (snapshot) in
            let obj = snapshot.value as? [String: AnyObject]
            if snapshot.exists()
            {
                if snapshot.hasChild("Bio")
                {
                    let bio = obj?["Bio"] as! String
                    self.TextField.text = bio
                }
                if snapshot.hasChild("profileimage")
                {
                    
                    let image = obj?["profileimage"]
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
    
    @objc func Finish()
    {
        if profileupdate == "yes"
        {
            guard let img = profileImageView.image else {
                return
            }
            
            if let imgData = img.jpegData(compressionQuality: 0.2)
            {
                
                guard let auth = FirebaseAuth.Auth.auth().currentUser?.uid else {
                    
                    return
                    }
                let ref = FirebaseDatabase.Database.database().reference()
                
                let values = ["Bio": TextField.text]
                ref.child("Users").child(auth).updateChildValues(values as [AnyHashable : Any])
                
                let imgUID = NSUUID().uuidString
                let metadata = StorageMetadata()
                metadata.contentType = "img/jpeg"
                
                let storageRef = Storage.storage().reference().child("profileimage/").child(imgUID)
                
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
            guard let auth = FirebaseAuth.Auth.auth().currentUser?.uid else {
                
                return
                }
            let ref = FirebaseDatabase.Database.database().reference()
            
            let values = ["Bio": TextField.text]
            ref.child("Users").child(auth).updateChildValues(values as [AnyHashable : Any])
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func ChangeProfile()
    {
        let imagepicker = UIImagePickerController()
        imagepicker.delegate = self
        
        
        self.present(imagepicker, animated: true, completion: nil)
    }
    
    func setupUserimg(img: String)
    {
        
        guard let userid = FirebaseAuth.Auth.auth().currentUser?.uid else {
            
            return
        }
        
        let push = Database.database().reference().childByAutoId()
        
        let userData = [
            "profileimage": img,
        ] as [String : Any]
        let setLocation = FirebaseDatabase.Database.database().reference().child("Users").child("profileimage").child(userid)
        
        setLocation.setValue(userData)
        
        let values = ["profileimage": img]
        setLocation.child("Users").child(userid).updateChildValues(values as [AnyHashable : Any])
        
        
        //        LoadingBar.stopAnimating()
        //        LoadingBar.isHidden = true
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        
        profileImageView.image = image
        
        picker.dismiss(animated: true, completion: nil)
        profileupdate = "yes"
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

}
