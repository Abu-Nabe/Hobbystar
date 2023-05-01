//
//  Story.swift
//  Zinging
//
//  Created by Abu Nabe on 14/2/21.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class Story: UIViewController
{
    
    var StoryID: String!
    
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
    
    let popupBox: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        
        self.definesPresentationContext = true
        
        setupViews()
        configureData()
        
        let profileTap = UITapGestureRecognizer(target: self, action: #selector(GoToProfile))
        profileTap.numberOfTapsRequired = 1
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(profileTap)
        
        
        let nameTap = UITapGestureRecognizer(target: self, action: #selector(GoToProfile))
        nameTap.numberOfTapsRequired = 1
        Namelabel.isUserInteractionEnabled = true
        Namelabel.addGestureRecognizer(nameTap)
        
    }
    
    func setupViews() {
        view.addSubview(popupBox)
        
        // autolayout constraint for popupBox
        popupBox.heightAnchor.constraint(equalToConstant: 200).isActive = true
        popupBox.widthAnchor.constraint(equalToConstant: 300).isActive = true
        popupBox.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        popupBox.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        
        
        popupBox.addSubview(profileImageView)
        popupBox.addSubview(Namelabel)
        popupBox.addSubview(pointLabel)
        popupBox.addSubview(bioLabel)
        
        pointLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pointLabel.anchor(top: popupBox.topAnchor)
        
        profileImageView.anchor(top: pointLabel.bottomAnchor, left: popupBox.leftAnchor, paddingLeft: 5, width: 25, height: 25)
        profileImageView.layer.cornerRadius = 25/2
        
        Namelabel.anchor(top: profileImageView.topAnchor, left: profileImageView.rightAnchor)
        
        bioLabel.anchor(top: Namelabel.bottomAnchor, left: profileImageView.rightAnchor)
        
        let Constraints = [bioLabel.heightAnchor.constraint(lessThanOrEqualToConstant: 250),  bioLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 250)]
        //
        NSLayoutConstraint.activate(Constraints)
        
        //        view.touchesBegan(sel, with: nil)
        
    }
    
    @objc func GoToProfile(sender: UITapGestureRecognizer)
    {
        let storyBoard: UIStoryboard = UIStoryboard(name: "AddProfile", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "AddProfile") as! AddProfile
        newViewController.Userid = StoryID
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func configureData()
    {
        let ref = Database.database().reference()
        ref.child("Users").child(StoryID).observe(.value) { (snapshot) in
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
        ref.child("Users").child(StoryID).child("points").observe(.value) { (snapshot) in
            if snapshot.exists()
            {
                let pointcount: Int = Int(snapshot.childrenCount)
                
                self.pointLabel.text = String(pointcount) + " Points"
            }
        }
    }
}
