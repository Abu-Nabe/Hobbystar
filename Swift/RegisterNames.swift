//
//  RegisterNames.swift
//  Zinging
//
//  Created by Abu Nabe on 1/1/21.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase


class RegisterNames: UIViewController  {
    
    private let imageview: UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(named: "logo")
        imageview.contentMode = UIView.ContentMode.scaleAspectFit
        
        return imageview
    }()
    
    private let firstname: UITextField = {
        let firstname = UITextField()
        firstname.placeholder = "First Name"
        firstname.layer.borderWidth = 1
        firstname.layer.cornerRadius = 8;
        firstname.layer.borderColor = UIColor.black.cgColor
        
        return firstname
    }()
    
    private let firstname1: UITextView = {
        let firstname1 = UITextView()
        
        return firstname1
    }()
    
    private let lastname: UITextField = {
        let lastname = UITextField()
        lastname.placeholder = "Last Name"
        lastname.layer.borderWidth = 1
        lastname.layer.cornerRadius = 8;
        lastname.layer.borderColor = UIColor.black.cgColor
        
        return lastname
    }()
    
    private let lastname1: UITextView = {
        let lastname1 = UITextView()
        
        return lastname1
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
        view.addSubview(firstname)
        view.addSubview(lastname)
        view.addSubview(Continue)
        
        Continue.addTarget(self, action: #selector(didtapbutton), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        
        self.edgesForExtendedLayout = []
        
        
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
        
        imageview.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageview.anchor(top: view.topAnchor, paddingTop: 50, width: 90, height: 90)
        
        firstname.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        firstname.anchor(bottom: lastname.topAnchor, paddingBottom: 10, width: view.width-60, height: 30)
        
        lastname.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        lastname.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        lastname.anchor(width: view.width-60, height: 30)
        
        Continue.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        Continue.anchor(top: lastname.bottomAnchor, paddingTop: 30,width: view.width-160, height: 52)
    }
    
    @objc private func didtapbutton()
    {
        guard let name = firstname.text, !name.isEmpty else {
            self.showToast(message: "FirstName is Empty", font: .systemFont(ofSize: 12.0))
            return
        }
        
        guard let surname = lastname.text, !surname.isEmpty else {
            self.showToast(message: "LastName is Empty", font: .systemFont(ofSize: 12.0))
            return
        }
        guard let auth = FirebaseAuth.Auth.auth().currentUser?.uid else {
            
            return
            }
        
    
        
        let firstname1 = firstname.text
        let lastname1 = lastname.text
    
        let userData = ["firstname": firstname1, "lastname": lastname1]
            
         let ref = FirebaseDatabase.Database.database().reference()
        ref.child("Users").child(auth).setValue(userData) { (error, databaseRef) in
            if error != nil {
        
            } else {
                self.ContinueRegistering()
            }
        }

    }
    
    func ContinueRegistering()
    {
        let storyBoard: UIStoryboard = UIStoryboard(name: "RegisterDOB", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "RegisterDOB") as! RegisterDOB
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
