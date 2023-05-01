//
//  HobbyPicker.swift
//  Zinging
//
//  Created by Abu Nabe on 24/2/21.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class HobbyPicker: UIViewController
{
    let Hobbies = ["artist", "athlete", "blogger", "comedian", "cooking", "dance", "editor", "fitness", "gamer", "make up", "martial art", "memer", "model", "motivational", "photographer","poetry", "yoga","regular"]
    
    var pickerView = UIPickerView()
    
    
    var hobbyText = UITextView()
    
    private let Button: UIButton = {
        let LoginButton = UIButton()
        LoginButton.backgroundColor = .systemGreen
        LoginButton.setTitleColor(.white, for: .normal)
        LoginButton.layer.cornerRadius = 24;
        LoginButton.setTitle("Done", for: .normal)
        
        return LoginButton
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(pickerView)
        view.addSubview(Button)
        
        self.navigationItem.hidesBackButton = true
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
        
        pickerView.delegate = self as UIPickerViewDelegate
        pickerView.dataSource = self as UIPickerViewDataSource
        pickerView.center = self.view.center
      
        Button.anchor(top: pickerView.bottomAnchor, paddingTop: 30, width: 200, height: 40)
        
        Button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        Button.addTarget(self, action: #selector(Confirm), for: .touchUpInside)
    }
    @objc func Confirm()
    {
        let text = hobbyText.text
        let ref = Database.database().reference()
        let Auth = FirebaseAuth.Auth.auth().currentUser!.uid
        
        if text == ""
        {
            ref.child("Users").child(Auth).child("hobbyname").setValue("artist")
            self.dismiss(animated: true, completion: nil)
        }else{
            
            ref.child("Users").child(Auth).child("hobbyname").setValue(text)
            
            change()
        }
    }
    func change()
    {
        self.dismiss(animated: true, completion: nil)
    }
}

extension HobbyPicker: UIPickerViewDelegate, UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return Hobbies.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Hobbies[row]
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard row < Hobbies.count else {
                return
            }

        let hobbySelected = Hobbies[row]
        
        hobbyText.text = hobbySelected
        
        print(hobbyText.text)
        
        PickHobby(String: hobbySelected)
    }

    func PickHobby(String: String)
    {
        
    }
}
