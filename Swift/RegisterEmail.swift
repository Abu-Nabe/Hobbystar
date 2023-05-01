//
//  RegisterEmail.swift
//  Zinging
//
//  Created by Abu Nabe on 1/1/21.
//

import UIKit
import FirebaseAuth


class RegisterEmail: UIViewController  {
    
    private let imageview: UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(named: "logo")
        imageview.contentMode = UIView.ContentMode.scaleAspectFit
        
        return imageview
    }()
    
    private let EmailField: UITextField = {
        let EmailField = UITextField()
        EmailField.placeholder = "Email Address"
        EmailField.layer.borderWidth = 1
        EmailField.layer.cornerRadius = 8;
        EmailField.layer.borderColor = UIColor.black.cgColor
        
        return EmailField
    }()
    
    private let PasswordField: UITextField = {
        let PassworldField = UITextField()
        PassworldField.placeholder = "Password"
        PassworldField.layer.borderWidth = 1
        PassworldField.isSecureTextEntry = true
        PassworldField.layer.cornerRadius = 8;
        PassworldField.layer.borderColor = UIColor.black.cgColor
        
        return PassworldField
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
        view.addSubview(EmailField)
        view.addSubview(PasswordField)
        view.addSubview(Continue)
        
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
        
        Continue.addTarget(self, action: #selector(didtapbutton), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        
        
        
        imageview.frame = CGRect(x:120,
                             y:100,
                             width: view.frame.size.width-240,
                             height: 90)
        EmailField.frame = CGRect(x:30,
                                  y:view.height/2-30,
                                  width: view.frame.size.width-60,
                                  height: 30)
        PasswordField.frame = CGRect(x:30,
                                     y:EmailField.frame.origin.y+EmailField.frame.size.height+10,
                                     width: view.frame.size.width-60,
                                     height: 30)
        Continue.frame = CGRect(x:80,
                                   y:PasswordField.frame.origin.y+PasswordField.frame.size.height+30,
                                   width: view.frame.size.width-160,
                                   height: 52)
    }
    
    @objc private func didtapbutton()
    {
        guard let email = EmailField.text, !email.isEmpty else {
            self.showToast(message: "Email is Empty", font: .systemFont(ofSize: 12.0))
            return
        }
        
            guard let password = PasswordField.text, !password.isEmpty else {
                self.showToast(message: "Password is Empty", font: .systemFont(ofSize: 12.0))
            return
        }
        
        if(password.count < 8)
        {
            self.showToast(message: "Password too short", font: .systemFont(ofSize: 12.0))
            
            return
        }
        
        if(password.count > 36)
        {
            self.showToast(message: "Password too long", font: .systemFont(ofSize: 12.0))
            
            return
        }
        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: { [weak self] result, error in
            
            guard let strongSelf = self else {
            
                return
            }
            
            guard error == nil else {
                self?.showToast(message: "Email Invalid/Taken", font: .systemFont(ofSize: 12.0))
            return
            }
            
            guard let user = Auth.auth().currentUser else
            {
                self?.showToast(message: "An Error has Occured", font: .systemFont(ofSize: 12.0))
                return
            }
            
            strongSelf.ContinueRegistering()
            
            user.sendEmailVerification { error in
                guard error != nil else {
                    print("Email Verification has been sent")

                    return
                }
            }
            print("You have signed in")
    
        })
    }
    
    func ContinueRegistering()
    {
        let storyBoard: UIStoryboard = UIStoryboard(name: "RegisterNames", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "RegisterNames") as! RegisterNames
        self.navigationController?.pushViewController(newViewController, animated: true)
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
