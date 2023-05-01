//
//  RegisterUsername.swift
//  Zinging
//
//  Created by Abu Nabe on 1/1/21.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class NamesRegister: UIViewController, UITextFieldDelegate  {
    
    private let imageview: UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(named: "logo")
        imageview.contentMode = UIView.ContentMode.scaleAspectFit
        
        return imageview
    }()
    
    private let username: UITextField = {
        let username = UITextField()
        username.placeholder = "Username"
        username.layer.borderWidth = 1
        username.layer.cornerRadius = 8;
        username.layer.borderColor = UIColor.black.cgColor
        
        return username
    }()
    
    private let username1: UITextView = {
        let username1 = UITextView()
        
        return username1
    }()
    
    private let Continue: UIButton = {
        let Continue = UIButton()
        Continue.backgroundColor = .systemGreen
        Continue.setTitleColor(.white, for: .normal)
        Continue.layer.cornerRadius = 24;
        Continue.setTitle("Continue", for: .normal)
        
        return Continue
    }()
    
    
    override func viewDidLoad() {
        
        view.addSubview(imageview)
        view.addSubview(username)
        view.addSubview(Continue)
        
        
        self.edgesForExtendedLayout = []
        
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
        
        Continue.addTarget(self, action: #selector(didtapbutton), for: .touchUpInside)
        username.addTarget(self, action: #selector(NamesRegister.textFieldDidChange(_:)), for: .editingChanged)
        
        username.delegate = self
                
    }
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        
        imageview.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageview.anchor(top: view.topAnchor, paddingTop: 50, width: 90, height: 90)
        
        username.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        username.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        username.anchor(width: view.width-60, height: 30)
       
        Continue.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        Continue.anchor(top: username.bottomAnchor, paddingTop: 30,width: 160, height: 52)
    }
    
    @objc func textFieldDidChange(_ username: UITextField) {
            if let text:String = username.text {
                DispatchQueue.main.async {
                    self.username.text = text.lowercased()
                }
            }
    }
    
    @objc private func didtapbutton()
    {
        guard let name = username.text, !name.isEmpty else {
            self.showToast(message: "Username is Empty", font: .systemFont(ofSize: 12.0))
            return
        }
    
        if(name.count > 18){
            self .showToast(message: "Username Too Long", font: .systemFont(ofSize: 12.0))
            
            return
        }
        
        let username1 = username.text
                    
        
//        createAccount()
        checkUserNameAlreadyExist(newUserName: username1!) { (isComplete) in
            if isComplete == true{
                self.configureAccount()
            }
        }
    }
    
    func configureAccount()
    {
        let ref = Database.database().reference()
        let auth = FirebaseAuth.Auth.auth().currentUser!.uid
        
        let username1 = username.text
        
        let values = ["username": username1]
        
        ref.child("Users").child(auth).updateChildValues(values as [AnyHashable : Any])
        
        ref.child("active_usernames").child(username1!).setValue(true)
        
        createAccount()
    }
    func createAccount()
    {
        self.showToast(message: "A link to verify your account has been sent to your email", font: .systemFont(ofSize: 8.0))
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "Login") as! Login
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    func checkUserNameAlreadyExist(newUserName: String, completion: @escaping(Bool) -> Void)
    {
        let ref = Database.database().reference()
        
        ref.child("active_usernames").child(newUserName).observe(.value) { (snapshot) in
            
            if snapshot.exists()
            {
                self.showToast(message: "Username already exists", font: .systemFont(ofSize: 10.0))
            }else {
                completion(true)
            }
        }
        
    }
    
    let allowedCharacters = CharacterSet(charactersIn:"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuwvxyz_.").inverted

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let components = string.components(separatedBy: allowedCharacters)
        let filtered = components.joined(separator: "")
        
        if string == filtered {
            
            return true

        } else {
            
            return false
        }
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





