//
//  Premium.swift
//  Zinging
//
//  Created by Abu Nabe on 25/1/21.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class Premium: UIViewController
{
    
    let label: UILabel =
    {
        let label = UILabel()
        label.text = "Premium Account Setting"
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 24)
        return label
    }()
    
    let Privacylabel: UILabel =
    {
        let label = UILabel()
        label.text = "Account Privacy"
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    private let PublicButton: UIButton = {
        let LoginButton = UIButton()
        LoginButton.backgroundColor = .systemGray
        LoginButton.setTitleColor(.black, for: .normal)
        LoginButton.layer.cornerRadius = 16;
        LoginButton.setTitle("Public", for: .normal)
        
        return LoginButton
    }()
    
    private let PrivateButton: UIButton = {
        let LoginButton = UIButton()
        LoginButton.backgroundColor = .systemGreen
        LoginButton.setTitleColor(.black, for: .normal)
        LoginButton.layer.cornerRadius = 16;
        LoginButton.setTitle("Private", for: .normal)
        
        return LoginButton
    }()
        
    
    let Premiumlabel: UILabel =
    {
        let label = UILabel()
        label.text = "Premium Account"
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    let line: UIView =
    {
        let label = UIView()
        return label
    }()
    
    private let RegularButton: UIButton = {
        let LoginButton = UIButton()
        LoginButton.backgroundColor = .systemGray
        LoginButton.setTitleColor(.black, for: .normal)
        LoginButton.layer.cornerRadius = 16;
        LoginButton.setTitle("Regular", for: .normal)
        
        return LoginButton
    }()
    
    private let PremiumButton: UIButton = {
        let LoginButton = UIButton()
        LoginButton.backgroundColor = .systemGray
        LoginButton.setTitleColor(.black, for: .normal)
        LoginButton.layer.cornerRadius = 16;
        LoginButton.setTitle("Premium", for: .normal)
        
        return LoginButton
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(label)
        view.addSubview(Privacylabel)
        view.addSubview(Premiumlabel)
        view.addSubview(PremiumButton)
        view.addSubview(PrivateButton)
        view.addSubview(RegularButton)
        view.addSubview(PublicButton)
        view.addSubview(line)
        
    }
    
    override func viewDidLayoutSubviews() {
        
        self.edgesForExtendedLayout = []
        
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.anchor(top: view.topAnchor)
        
        Privacylabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        Privacylabel.anchor(top: label.bottomAnchor, paddingTop: 30)
        
        PublicButton.anchor(top: Privacylabel.bottomAnchor, right: Privacylabel.leftAnchor, paddingLeft: 15)
        
        PrivateButton.anchor(top: Privacylabel.bottomAnchor, left: Privacylabel.rightAnchor, paddingRight: 15)
        
        Premiumlabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        Premiumlabel.anchor(top: PrivateButton.bottomAnchor, paddingTop: 30)
        
        
        RegularButton.anchor(top: Premiumlabel.bottomAnchor, right: Premiumlabel.leftAnchor, paddingLeft: 15)
        
        PremiumButton.anchor(top: Premiumlabel.bottomAnchor, left: Premiumlabel.rightAnchor, paddingRight: 15)
        
        PublicButton.addTarget(self, action: #selector(Public), for: .touchUpInside)
        PrivateButton.addTarget(self, action: #selector(Private), for: .touchUpInside)
        RegularButton.addTarget(self, action: #selector(Regular), for: .touchUpInside)
        PremiumButton.addTarget(self, action: #selector(Premium), for: .touchUpInside)
        
        let ref = Database.database().reference()
        
        let Auth = FirebaseAuth.Auth.auth().currentUser?.uid
        
        ref.child("Users").child(Auth!).observe(.value) { (snapshot) in
            let data = snapshot.value as! [String: AnyObject]
            if snapshot.hasChild("privacy")
            {
                let privacy = data["privacy"] as! String
                if privacy == "public"
                {
                    self.PrivateButton.backgroundColor = .systemGreen
                    self.PublicButton.backgroundColor = .systemGray
                }else
                {
                    self.PrivateButton.backgroundColor = .systemGreen
                    self.PublicButton.backgroundColor = .systemGray
                }
            }
            
    
        }
    }
    
    @objc func Public()
    {
        let ref = Database.database().reference()
        
        let Auth = FirebaseAuth.Auth.auth().currentUser?.uid
        
        let text = "public"
        let Data = ["privacy": text]
        
        ref.child("Users").child(Auth!).setValue(Data)
        
        PrivateButton.backgroundColor = .systemGreen
        PublicButton.backgroundColor = .systemGray
        
    }
    @objc func Private()
    {
        let ref = Database.database().reference()
        
        let Auth = FirebaseAuth.Auth.auth().currentUser?.uid
        
        let text = "private"
        let Data = ["privacy": text]
        
        ref.child("Users").child(Auth!).setValue(Data)
        PrivateButton.backgroundColor = .systemGray
        PublicButton.backgroundColor = .systemGreen
        
    }
    @objc func Regular()
    {
//        let ref = Database.database().reference()
//        
//        let Auth = FirebaseAuth.Auth.auth().currentUser?.uid
//        
//        let text = "private"
//        let Data = ["privacy": text]
//        
//        ref.child("Users").child(Auth!).setValue(Data)
        self.showToast(message: "Coming Soon", font: .systemFont(ofSize: 12.0))
        
    }
    @objc func Premium()
    {
//        let ref = Database.database().reference()
//
//        let Auth = FirebaseAuth.Auth.auth().currentUser?.uid
//
//        let text = "private"
//        let Data = ["privacy": text]
//
//        ref.child("Users").child(Auth!).setValue(Data)
        
        self.showToast(message: "Coming Soon", font: .systemFont(ofSize: 12.0))
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
