//
//  PersonalLinks.swift
//  Zinging
//
//  Created by Abu Nabe on 26/1/21.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class PersonalLinks: UIViewController
{
    var Userid: String!
    
    private let LinkLabel: UITextField = {
        let EmailField = UITextField()
        EmailField.placeholder = "Social Media"
        EmailField.layer.borderWidth = 1
        EmailField.layer.cornerRadius = 8;
        EmailField.layer.borderColor = UIColor.black.cgColor
        return EmailField
    }()
    
    private let LinkLabel1: UITextField = {
        let PassworldField = UITextField()
        PassworldField.placeholder = "Business"
        PassworldField.layer.borderWidth = 1
        PassworldField.layer.cornerRadius = 8;
        PassworldField.layer.borderColor = UIColor.black.cgColor
        return PassworldField
    }()
    
    private let LinkLabel2: UITextField = {
        let PassworldField = UITextField()
        PassworldField.placeholder = "Other"
        PassworldField.layer.borderWidth = 1
        PassworldField.layer.cornerRadius = 8;
        PassworldField.layer.borderColor = UIColor.black.cgColor
        
        return PassworldField
    }()
    
    private let LinkLabel3: UITextField = {
        let PassworldField = UITextField()
        PassworldField.placeholder = "Other"
        PassworldField.layer.borderColor = UIColor.black.cgColor
        PassworldField.layer.borderWidth = 1
        PassworldField.layer.cornerRadius = 8;
        return PassworldField
    }()
    
    private let Button: UIButton = {
        let LoginButton = UIButton()
        LoginButton.backgroundColor = .systemGreen
        LoginButton.setTitleColor(.white, for: .normal)
        LoginButton.layer.cornerRadius = 16;
        LoginButton.setTitle("Done", for: .normal)
        
        
        return LoginButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(LinkLabel)
        view.addSubview(LinkLabel1)
        view.addSubview(LinkLabel2)
        view.addSubview(LinkLabel3)
        view.addSubview(Button)
        
        self.edgesForExtendedLayout = []
        
        LinkLabel2.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        LinkLabel2.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        LinkLabel2.anchor(width: view.width-100, height: 40)
        
        LinkLabel1.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        LinkLabel1.anchor(bottom: LinkLabel2.topAnchor, width: view.width-100, height: 40)
        
        LinkLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        LinkLabel.anchor(bottom: LinkLabel1.topAnchor, width: view.width-100, height: 40)
        
        LinkLabel3.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        LinkLabel3.anchor(top: LinkLabel2.bottomAnchor, width: view.width-100, height: 40)
        
        Button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        Button.anchor(top: LinkLabel3.bottomAnchor, paddingTop: 30, width: 100, height: 40)
        
        Button.addTarget(self, action: #selector(SaveLink), for: .touchUpInside)
        
        let ref = Database.database().reference()
        let Auth = FirebaseAuth.Auth.auth().currentUser?.uid
        
        ref.child("Links").child(Auth!).observe(.value) { (snapshot) in
            let data = snapshot.value as! [String: AnyObject]
            
            if snapshot.hasChild("link1")
            {
                let link1 = data["link1"] as! String
                self.LinkLabel.text = link1
            }
            if snapshot.hasChild("link2"){
                let link2 = data["link2"] as! String
                self.LinkLabel1.text = link2
            }
            if snapshot.hasChild("link3")
            {
                let link3 = data["link3"] as! String
                self.LinkLabel2.text = link3
            }
            if snapshot.hasChild("link4"){
                let link4 = data["link4"] as! String
                self.LinkLabel3.text = link4
            }
        }
    }
    
    @objc func SaveLink()
    {
        let link1 = LinkLabel.text
        let link2 = LinkLabel1.text
        let link3 = LinkLabel2.text
        let link4 = LinkLabel3.text
        
        let data = ["link1": link1, "link2": link2, "link3": link3, "link4": link4]
        
        let ref = Database.database().reference()
        let Auth = FirebaseAuth.Auth.auth().currentUser?.uid
        
        ref.child("Links").child(Auth!).setValue(data)
        
        self.showToast(message: "Successfully Updated", font: .systemFont(ofSize: 8))
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

