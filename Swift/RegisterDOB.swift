//
//  RegisterNames.swift
//  Zinging
//
//  Created by Abu Nabe on 1/1/21.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase


class RegisterDOB: UIViewController  {
    
    private let imageview: UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(named: "logo")
        imageview.contentMode = UIView.ContentMode.scaleAspectFit
        
        return imageview
    }()
    
    private let datepicker: UIDatePicker = {
        let datepicker = UIDatePicker()
        datepicker.datePickerMode = .date
        
        return datepicker
    }()
    
    private let datetxt: UITextView = {
        let datetxt = UITextView()
        
        return datetxt
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
        view.addSubview(datepicker)
        view.addSubview(Continue)
        
        datepicker.addTarget(self, action: #selector(didtapbutton) , for: .valueChanged)
        Continue.addTarget(self, action: #selector(ContinueRegistering), for: .touchUpInside)
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
        
        datepicker.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        datepicker.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        datepicker.anchor(height: 30)
        
        Continue.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        Continue.anchor(top: datepicker.bottomAnchor, paddingTop: 30, width: 160, height: 52)
    }
    
    @objc private func didtapbutton()
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        datetxt.text = dateFormatter.string(from: datepicker.date)
        self.view.endEditing(true)

        guard let auth = FirebaseAuth.Auth.auth().currentUser?.uid else {
            
            return
            }
        let ref = FirebaseDatabase.Database.database().reference()
        let values = ["DOB": datetxt.text]
        ref.child("Users").child(auth).updateChildValues(values as [AnyHashable : Any])

    }
    
    @objc func ContinueRegistering()
    {
        let storyBoard: UIStoryboard = UIStoryboard(name: "RegisterUsername", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "RegisterUsername") as! NamesRegister
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
