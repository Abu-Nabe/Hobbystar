//
//  ViewController.swift
//  Zinging
//
//  Created by Abu Nabe on 30/12/20.
//

import UIKit
import FirebaseAuth

class Login: UIViewController
{
    
    private let imageview: UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(named: "logo")
        imageview.contentMode = UIView.ContentMode.scaleAspectFit
        
        return imageview
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Log in"
        label.font = .systemFont(ofSize: 24, weight : .semibold)
        
        
        return label
    }()
    
    private let EmailField: UITextField = {
        let EmailField = UITextField()
        EmailField.placeholder = "Email Address"
        EmailField.layer.borderWidth = 1
        EmailField.returnKeyType = .next
        EmailField.layer.cornerRadius = 8;
        EmailField.layer.borderColor = UIColor.black.cgColor
        
        var imageView = UIImageView();
        var image = UIImage(systemName: "envelope.fill");
        imageView.image = image;
        imageView.tintColor = .black
        EmailField.leftView = imageView
        EmailField.leftViewMode = .always
        
        return EmailField
    }()
    
    private let PasswordField: UITextField = {
        let PassworldField = UITextField()
        PassworldField.placeholder = "Password"
        PassworldField.layer.borderWidth = 1
        PassworldField.isSecureTextEntry = true
        PassworldField.returnKeyType = .continue
        PassworldField.layer.cornerRadius = 8;
        PassworldField.layer.borderColor = UIColor.black.cgColor
        
        var imageView = UIImageView();
        var image = UIImage(systemName: "lock.fill");
        imageView.image = image;
        imageView.tintColor = .black
        PassworldField.leftView = imageView
        PassworldField.leftViewMode = .always
        
        return PassworldField
    }()
    
    private let LoginButton: UIButton = {
        let LoginButton = UIButton()
        LoginButton.backgroundColor = .systemGreen
        LoginButton.setTitleColor(.white, for: .normal)
        LoginButton.layer.cornerRadius = 16;
        LoginButton.setTitle("Login", for: .normal)
        
        return LoginButton
    }()
    
    private let Register: UILabel = {
        let Register = UILabel()
        Register.textColor = .systemGreen
        Register.text = "Register"
        Register.textAlignment = .center
        Register.font = .systemFont(ofSize: 12.0)
        return Register
    }()
    
    private let ForgotPassword: UILabel = {
        let ForgotPassword = UILabel()
        ForgotPassword.textColor = .black
        ForgotPassword.text = "Forgot Password?"
        ForgotPassword.textAlignment = .center
        ForgotPassword.font = .systemFont(ofSize: 10.0)
        return ForgotPassword
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(label)
        view.addSubview(EmailField)
        view.addSubview(PasswordField)
        view.addSubview(LoginButton)
        view.addSubview(Register)
        view.addSubview(ForgotPassword)
        view.addSubview(imageview)
        
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
        
        EmailField.delegate = self
        PasswordField.delegate = self
        
        // Do any additional setup after loading the view.
        LoginButton.addTarget(self, action: #selector(didtapbutton), for: .touchUpInside)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(registerview))
        tap.numberOfTapsRequired = 1
        Register.isUserInteractionEnabled = true
        Register.addGestureRecognizer(tap)
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(forgotpasswordview))
        tap1.numberOfTapsRequired = 1
        ForgotPassword.isUserInteractionEnabled = true
        ForgotPassword.addGestureRecognizer(tap1)
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        
        imageview.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageview.anchor(top: view.topAnchor, paddingTop: 100, width: 90, height: 90)
        
        imageview.frame = CGRect(x:120,
                                 y:100,
                                 width: view.width-240,
                                 height: 90)
        
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.anchor(top: imageview.bottomAnchor, paddingTop: 5)
        
        EmailField.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        EmailField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        EmailField.anchor(width: view.width-60, height: 30)
    
        PasswordField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        PasswordField.anchor(top: EmailField.bottomAnchor, paddingTop: 5, width: view.width-60, height: 30)
        
        LoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        LoginButton.anchor(top: PasswordField.bottomAnchor, paddingTop: 10,width: view.width-180, height: 35)
        
        Register.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        Register.anchor(top: LoginButton.bottomAnchor, paddingTop: 10)

        ForgotPassword.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        ForgotPassword.anchor(top: Register.bottomAnchor, paddingTop: 5)
    }
    
    @objc private func registerview()
    {
        let storyBoard: UIStoryboard = UIStoryboard(name: "RegisterEmail", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "RegisterEmail") as! RegisterEmail
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    @objc private func forgotpasswordview()
    {
        let storyboard = UIStoryboard(name: "ForgotPassword", bundle: nil)
        let secondViewController = storyboard.instantiateViewController(withIdentifier: "ForgotPassword") as! ForgotPassword
        secondViewController.modalPresentationStyle = .formSheet
        self.present(secondViewController, animated:true, completion:nil)
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
        
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: { [weak self] result, error in
            
            guard let strongSelf = self else {
                
                return
            }
            
            guard error == nil else {
                strongSelf.showCreateAccount()
                return
            }
            strongSelf.movetoMainpage()
        })
    }
    
    func showCreateAccount(){
        self.showToast(message: "Wrong Information", font: .systemFont(ofSize: 12.0))
    }
    
    func movetoMainpage()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let secondViewController = storyboard.instantiateViewController(withIdentifier: "Main") as! UITabBarController
        self.navigationController?.pushViewController(secondViewController, animated: true)
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
extension UITextView {
    
    func centerVertically() {
        let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let size = sizeThatFits(fittingSize)
        let topOffset = (bounds.size.height - size.height * zoomScale) / 2
        let positiveTopOffset = max(1, topOffset)
        contentOffset.y = -positiveTopOffset
    }
}

extension Login: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField == EmailField)
        {
            PasswordField.becomeFirstResponder()
        }else if(textField == PasswordField)
        {
            
        }
        return true
    }
}

