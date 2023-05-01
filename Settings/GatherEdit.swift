//
//  Gather Edit.swift
//  Zinging
//
//  Created by Abu Nabe on 25/1/21.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class GatherEdit: UIViewController
{
    private let imageview: UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(named: "logo")
        imageview.contentMode = UIView.ContentMode.scaleAspectFit
        
        return imageview
    }()

    
    private let GatherField: UITextField = {
        let EmailField = UITextField()
        EmailField.placeholder = "Gather"
        EmailField.layer.borderWidth = 1
        EmailField.returnKeyType = .next
        EmailField.layer.cornerRadius = 8;
        EmailField.layer.borderColor = UIColor.black.cgColor
        
        return EmailField
    }()
    
    private let GathererField: UITextField = {
        let PassworldField = UITextField()
        PassworldField.placeholder = "Gatherer"
        PassworldField.layer.borderWidth = 1
        PassworldField.isSecureTextEntry = true
        PassworldField.returnKeyType = .continue
        PassworldField.layer.cornerRadius = 8;
        PassworldField.layer.borderColor = UIColor.black.cgColor
        
        return PassworldField
    }()
    
    private let ContinueButton: UIButton = {
        let LoginButton = UIButton()
        LoginButton.backgroundColor = .systemGreen
        LoginButton.setTitleColor(.white, for: .normal)
        LoginButton.layer.cornerRadius = 24;
        LoginButton.setTitle("Confirm", for: .normal)
        
        return LoginButton
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(GatherField)
        view.addSubview(imageview)
        view.addSubview(GathererField)
        view.addSubview(ContinueButton)
                
        imageview.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageview.anchor(top: view.topAnchor,paddingTop: 50, width: 75, height: 75)
        
        GatherField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        GatherField.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        GatherField.anchor(width: view.width/2, height: 40)
        
        GathererField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        GathererField.anchor(top: GatherField.bottomAnchor, paddingTop: 10, width: view.width/2, height: 40)
        
        
        ContinueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        ContinueButton.anchor(top: GathererField.bottomAnchor, paddingTop: 40, width: 150, height: 60)
        
        ContinueButton.addTarget(self, action: #selector(Confirm), for: .touchUpInside)
        
        let ref = Database.database().reference()
        
        let Auth = FirebaseAuth.Auth.auth().currentUser?.uid
        ref.child("Users").child(Auth!).observe(.value) { (snapshot) in
            let user = snapshot.value as! [String: AnyObject]
            
            if snapshot.hasChild("gathername")
            {
                let name = user["gathername"] as! String
                self.GatherField.placeholder = name
            }
            if snapshot.hasChild("gatherername")
            {
                let name = user["gatherername"] as! String
                self.GathererField.placeholder = name
            }
        }
    }
    @objc func Confirm()
    {
        let gathername = GatherField.text
        
        let gatherername = GathererField.text
        
        let ref = Database.database().reference()
        let Auth = FirebaseAuth.Auth.auth().currentUser?.uid
        
        let userData = ["gathername": gathername, "gatherername": gatherername]
        
        ref.child("Users").child(Auth!).setValue(userData)
    }
}
