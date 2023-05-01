//
//  Suggestions.swift
//  Zinging
//
//  Created by Abu Nabe on 25/1/21.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class Suggestions: UIViewController
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
        label.text = "Any Suggestions you would want to make for the app?"
        label.font = .systemFont(ofSize: 14, weight : .semibold)
    
        
        return label
    }()
    
    private let SuggestionField: UITextField = {
        let EmailField = UITextField()
        EmailField.placeholder = "Recommend here"
        EmailField.layer.borderWidth = 1
        EmailField.layer.cornerRadius = 8;
        EmailField.font = .systemFont(ofSize: 12)
        EmailField.layer.borderColor = UIColor.black.cgColor
        
        return EmailField
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
        
        view.addSubview(SuggestionField)
        view.addSubview(label)
        view.addSubview(imageview)
        view.addSubview(Button)
        
        self.edgesForExtendedLayout = []
        imageview.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageview.anchor(top: view.topAnchor,paddingTop: 30, width: 75, height: 75)
        
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        label.anchor(paddingLeft: 0)
        
        SuggestionField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        SuggestionField.anchor(top: label.bottomAnchor, width: view.width/2+50, height: 40)
        
        Button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        Button.anchor(top: SuggestionField.bottomAnchor, paddingTop: 20, width: 100, height: 40)
        
        Button.addTarget(self, action: #selector(SaveSuggestion), for: .touchUpInside)
    }
    
    @objc func SaveSuggestion()
    {
        let text = SuggestionField.text
        
        if text == ""
        {
            self.showToast(message: "Nothing was written", font: .systemFont(ofSize: 8))
        }else {
            let data = ["recommend", text]
            
            let ref = Database.database().reference()
            let Auth = FirebaseAuth.Auth.auth().currentUser?.uid
            
            ref.child("Suggestions").child(Auth!).setValue(data)
            
            self.showToast(message: "Thanks for recommending!", font: .systemFont(ofSize: 8))
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
