//
//  Manage.swift
//  Zinging
//
//  Created by Abu Nabe on 25/1/21.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
class ManageUser: UIViewController
{
    
    let EmailLabel: UILabel =
        {
            let label = UILabel()
            label.text = "Email"
            label.backgroundColor = .green
            label.layer.cornerRadius = 16
            return label
        }()
    let PasswordLabel: UILabel =
        {
            let label = UILabel()
            label.text = "Password"
            label.backgroundColor = .green
            label.layer.cornerRadius = 16
            
            return label
        }()
    
    let UsernameLabel: UILabel =
    {
        let label = UILabel()
        label.text = "Username: "
        label.layer.cornerRadius = 16
            
        return label
    }()
    
    let Username: UILabel =
    {
        let label = UILabel()
        label.text = "Users Name"
            
        return label
    }()
    
    let NameLabel: UILabel =
    {
        let label = UILabel()
        label.text = "Name: "
        label.layer.cornerRadius = 16
            
        return label
    }()
    
    let Name: UILabel =
    {
        let label = UILabel()
        label.text = "First Name"
            
        return label
    }()
    
    let LastName: UILabel =
    {
        let label = UILabel()
        label.text = "Last Name"
            
        return label
    }()
    
    let DOBLabel: UILabel =
    {
        let label = UILabel()
        label.text = "DOB: "
        label.layer.cornerRadius = 16
            
        return label
    }()
    
    let Dob: UILabel =
    {
        let label = UILabel()
        label.text = "DOB"
            
        return label
    }()
    
    let popupBox: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    let clearimage: UIImageView = {
        var imageview = UIImageView()
        imageview.image = UIImage(systemName: "clear.fill")
        imageview.tintColor = .black
        return imageview
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = []
        
        self.definesPresentationContext = true
        
        setUpView()
                
        let Auth = FirebaseAuth.Auth.auth().currentUser?.uid
        
        let ref = Database.database().reference()
        
        ref.child("Users").child(Auth!).observe(.value) { (snapshot) in
            let details = snapshot.value as? [String: AnyObject]
            let username = details?["username"] as! String
            self.Username.text = username
            let firstname = details?["firstname"] as? String ?? ""
            self.Name.text = firstname
            let lastname = details?["lastname"] as? String ?? ""
            self.LastName.text = lastname
            let DOB = details?["DOB"] as? String ?? ""
            self.Dob.text = DOB
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(alertWithTF))
            tap.numberOfTapsRequired = 1
            EmailLabel.isUserInteractionEnabled = true
            EmailLabel.addGestureRecognizer(tap)
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(alertPassword))
            tap1.numberOfTapsRequired = 1
            PasswordLabel.isUserInteractionEnabled = true
            PasswordLabel.addGestureRecognizer(tap1)
        
    }
    
    func setUpView()
    {
        view.addSubview(popupBox)
        
        popupBox.heightAnchor.constraint(equalToConstant: 200).isActive = true
        popupBox.widthAnchor.constraint(equalToConstant: 300).isActive = true
        popupBox.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        popupBox.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        popupBox.addSubview(EmailLabel)
        popupBox.addSubview(PasswordLabel)
        popupBox.addSubview(UsernameLabel)
        popupBox.addSubview(Username)
        popupBox.addSubview(NameLabel)
        popupBox.addSubview(Name)
        popupBox.addSubview(LastName)
        popupBox.addSubview(Dob)
        popupBox.addSubview(DOBLabel)
        popupBox.addSubview(clearimage)
        
        popupBox.backgroundColor = .gray
        
        clearimage.anchor(right: popupBox.rightAnchor, paddingRight: 5)
        
        EmailLabel.centerXAnchor.constraint(equalTo: popupBox.centerXAnchor).isActive = true
        EmailLabel.anchor(top: popupBox.topAnchor)

        PasswordLabel.centerXAnchor.constraint(equalTo: popupBox.centerXAnchor).isActive = true
        PasswordLabel.anchor(top: EmailLabel.bottomAnchor)
        
        UsernameLabel.centerYAnchor.constraint(equalTo: popupBox.centerYAnchor).isActive = true
        UsernameLabel.anchor(paddingLeft: 5,width: 100, height: 32)
        
        Username.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        Username.anchor(left:UsernameLabel.rightAnchor,width: view.width, height: 32)
        NameLabel.anchor(top: UsernameLabel.bottomAnchor,paddingLeft: 5, width: 100, height: 32)
        Name.anchor(top: UsernameLabel.bottomAnchor, left: NameLabel.rightAnchor, paddingLeft: 5, height: 32)
        LastName.anchor(top: Username.bottomAnchor, left: Name.rightAnchor, height: 32)
        DOBLabel.anchor(top: NameLabel.bottomAnchor, paddingLeft: 5,width: 100, height: 32)
        Dob.anchor(top: NameLabel.bottomAnchor, left: DOBLabel.rightAnchor, height: 32)
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        clearimage.isUserInteractionEnabled = true
        clearimage.addGestureRecognizer(tap1)
    }
    
    @objc func dismissView()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func alertWithTF() {
        
        let Auth = FirebaseAuth.Auth.auth().currentUser
        //Step : 1
        let alert = UIAlertController(title: "Change Email", message: "Enter new email address", preferredStyle: UIAlertController.Style.alert )
        //Step : 2
        let save = UIAlertAction(title: "Confirm", style: .default) { (alertAction) in
            let textField = alert.textFields![0] as UITextField
            let textField2 = alert.textFields![1] as UITextField

            if textField2.text == "" {
                print(textField2.text!)
                print("TF 2 : \(textField2.text!)")
                self.showToast(message: "Email is empty", font: .systemFont(ofSize: 12))
                
            } else {
                Auth?.updateEmail(to: textField2.text!, completion: { (error) in
                    if error != nil {
                        self.showToast(message: "Email provided is invalid", font: .systemFont(ofSize: 12.0))
                        // An error happened
                    } else {
                        self.showToast(message: "Successfully Updated", font: .systemFont(ofSize: 12.0))
                        self.dismiss(animated: true, completion: nil)
                       // Email updated.
                    }
                })
            }
        }

        //Step : 3
        //For first TF
        alert.addTextField { (textField) in
            let email = Auth?.email

            textField.text = email
            textField.isEnabled = false
            textField.textColor = .red
        }
        //For second TF
        alert.addTextField { (textField) in
            textField.placeholder = "Enter your new email"
            textField.textColor = .blue
        }

        //Step : 4
        alert.addAction(save)
        //Cancel action
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (alertAction) in }
        alert.addAction(cancel)
        //OR single line action
        //alert.addAction(UIAlertAction(title: "Cancel", style: .default) { (alertAction) in })

        self.present(alert, animated:true, completion: nil)

    }
    
    @objc func alertPassword() {
        
        let Auth = FirebaseAuth.Auth.auth().currentUser
        //Step : 1
        let alert = UIAlertController(title: "Change Password", message: "Enter new password", preferredStyle: UIAlertController.Style.alert )
        //Step : 2
        let save = UIAlertAction(title: "Confirm", style: .default) { (alertAction) in
            let textField = alert.textFields![0] as UITextField
            let textField2 = alert.textFields![1] as UITextField

            if textField.text == textField2.text
            {
                Auth?.updatePassword(to: textField2.text!, completion: { (error) in
                    if error != nil{
                        self.showToast(message: "Check if password matches", font: .systemFont(ofSize: 8.0))
                    }else {
                        self.showToast(message: "Successfully Changed Password", font: .systemFont(ofSize: 8.0))
                    }
                })
            }else {
                self.showToast(message: "Password does not match", font: .systemFont(ofSize: 8.0))
            }
        }

        //Step : 3
        //For first TF
        alert.addTextField { (textField) in
//            let email = Auth?.email

            textField.placeholder = "New Password"
            textField.textColor = .black
        }
        //For second TF
        alert.addTextField { (textField) in
            textField.placeholder = "Confirm Password"
            textField.textColor = .black
        }

        //Step : 4
        alert.addAction(save)
        //Cancel action
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (alertAction) in }
        alert.addAction(cancel)
        //OR single line action
        //alert.addAction(UIAlertAction(title: "Cancel", style: .default) { (alertAction) in })

        self.present(alert, animated:true, completion: nil)

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
    
    
    override func viewDidDisappear(_ animated: Bool) {
        self.dismiss(animated: true, completion: nil)
    }
}
