//
//  RegisterUsername.swift
//  Zinging
//
//  Created by Abu Nabe on 1/1/21.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase


class ForgotPassword: UIViewController  {
    
    private let imageview: UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(named: "logo")
        imageview.contentMode = UIView.ContentMode.scaleAspectFit
        
        return imageview
    }()
    
    private let explanation: UITextView = {
        let explanation = UITextView()
        explanation.text = "Write the email address to your account and an link will be sent for you to reset your password."
        explanation.textColor = UIColor.black
        explanation.textAlignment = .center
        
        return explanation
    }()
    
    private let username: UITextField = {
        let username = UITextField()
        username.placeholder = "Email Address"
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
        Continue.setTitle("Send Link", for: .normal)
        
        return Continue
    }()
    
    
    override func viewDidLoad() {
        
        view.addSubview(imageview)
        view.addSubview(username)
        view.addSubview(Continue)
        view.addSubview(explanation)
        Continue.addTarget(self, action: #selector(didtapbutton), for: .touchUpInside)
        
    }
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        
        imageview.frame = CGRect(x:120,
                             y:100,
                             width: view.frame.size.width-240,
                             height: 90)
        
        explanation.frame = CGRect(x:60,
                             y:imageview.frame.origin.y+imageview.frame.size.height+10,
                             width: view.frame.size.width-120,
                             height: 90)
        username.frame = CGRect(x:30,
                                  y:explanation.frame.origin.y+explanation.frame.size.height+10,
                                  width: view.frame.size.width-60,
                                  height: 30)
        Continue.frame = CGRect(x:80,
                                   y:username.frame.origin.y+username.frame.size.height+30,
                                   width: view.frame.size.width-160,
                                   height: 52)
    }
    
    @objc private func didtapbutton()
    {
        guard let email = username.text, !email.isEmpty else {
            self.showToast(message: "Enter Email Address", font: .systemFont(ofSize: 12.0))
            return
        }
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            DispatchQueue.main.async {
                   //Use "if let" to access the error, if it is non-nil
                   if let error = error {
                       let resetFailedAlert = UIAlertController(title: "Reset Failed", message: error.localizedDescription, preferredStyle: .alert)
                       resetFailedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                       self.present(resetFailedAlert, animated: true, completion: nil)
                   } else {
                    self.showToast(message: "Link to reset password has been sent", font: .systemFont(ofSize: 12.0))
                   }
               }
            
            self.createAccount()
        }
        
    }
    
    func createAccount()
    {
        self.dismiss(animated: true, completion: nil)
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
