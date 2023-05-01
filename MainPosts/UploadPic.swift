//
//  UploadPic.swift
//  Zinging
//
//  Created by Abu Nabe on 22/1/21.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

class UploadPic: UIViewController,  UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    var VALIDATION = "no"
    
    let Hobbies = ["artist", "athlete", "blogger", "comedian", "cooking", "dance", "editor", "fitness", "gamer", "make up", "martial art", "memer", "model", "motivational", "photographer","poetry", "yoga","regular"]
    
    var pickerView = UIPickerView()
    
    var hobbyText: UITextView =
        {
            let text = UITextView()
            text.text = "Select Hobby"
            text.font = .boldSystemFont(ofSize: 16)
            text.textAlignment = .center
            return text
        }()
    
    let fillImage: UIImageView = {
        var imageview = UIImageView()
        imageview.image = UIImage(systemName: "plus")
        imageview.tintColor = .gray
        return imageview
    }()
    
    var textView = UITextView()
    
    let DescriptionField: UITextField =
        {
            let color = UIColor.systemGreen
            
            let Field = UITextField()
            Field.text = ""
            Field.sizeToFit()
            Field.font = .boldSystemFont(ofSize: 16)
            Field.layer.cornerRadius = 16
            Field.backgroundColor = .white
            Field.layer.borderWidth = 3
            Field.placeholder = "Share your experience!"
            Field.layer.borderColor = color.cgColor
           
            return Field
            
        }()
    
    private let UploadButton: UIButton = {
        let Button = UIButton()
        Button.backgroundColor = .systemGreen
        Button.setTitleColor(.white, for: .normal)
        Button.layer.cornerRadius = 16;
        Button.setTitle("Select", for: .normal)
        
        return Button
    }()
    
    private let PictureView: UIImageView = {
        let video = UIImageView()
        
        return video
    }()
    
    let NoPicLabel: UILabel = {
        let text = UILabel()
        text.text = "Choose A Picture"
        text.font = .systemFont(ofSize: 12.0)
        return text
    }()
    
    override func viewDidLoad() {
        view.addSubview(DescriptionField)
        view.addSubview(UploadButton)
        view.addSubview(PictureView)
        view.addSubview(NoPicLabel)
        view.addSubview(fillImage)
        
        view.addSubview(hobbyText)
        view.addSubview(pickerView)
        
        pickerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pickerView.anchor(top: hobbyText.bottomAnchor, width: view.width, height: 100)
                
        pickerView.isHidden = true

        NoPicLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        NoPicLabel.anchor(top: fillImage.bottomAnchor)
        
        fillImage.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        fillImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        fillImage.anchor(width: 200, height: 200)
                
        PictureView.backgroundColor = .white
        DescriptionField.anchor(top: view.topAnchor, left: view.leftAnchor,right: view.rightAnchor, height: 50)
        
        hobbyText.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        hobbyText.anchor(top: DescriptionField.bottomAnchor, width: view.width, height: 30)
        
        UploadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        UploadButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 5, width: view.width/2-30, height: 50)
        
        PictureView.anchor(top: pickerView.bottomAnchor, bottom: UploadButton.topAnchor, paddingBottom: 5, width: view.width)
        
        UploadButton.addTarget(self, action: #selector(Upload), for: .touchUpInside)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(SelectHobby))
        hobbyText.addGestureRecognizer(tap)
    }
    
    @objc func SelectHobby()
    {
        pickerView.isHidden = false
                
        pickerView.delegate = self as UIPickerViewDelegate
        pickerView.dataSource = self as UIPickerViewDataSource
    }
    @objc func Upload()
    {
        if VALIDATION == "no"
        {
            let imagepicker = UIImagePickerController()
            imagepicker.delegate = self
            
            
            self.present(imagepicker, animated: true, completion: nil)
        }else
        {
            guard let img = PictureView.image else {
                
                return
            }
            UploadButton.isUserInteractionEnabled = false
            
            let progress = ProgressDialog(delegate: self)
            
            progress.Show(animate: true, mesaj: "")
            
            if let imgData = img.jpegData(compressionQuality: 0.2)
            {
                let imgUID = NSUUID().uuidString
                let metadata = StorageMetadata()
                metadata.contentType = "img/jpeg"
                
                let storageRef = Storage.storage().reference().child("posts/").child(imgUID)
                
                let _ = storageRef.putData(imgData, metadata: metadata){ (metadata, error) in
                    guard let _ = metadata else {
                        print("error occured: \(error.debugDescription)")
                        
                        let progress = ProgressDialog(delegate: self)
                        
                        progress.Close()
                        return
                    }
                    storageRef.downloadURL(completion: { (url, error) in
                        if let urlText = url?.absoluteString {
                            self.setupUserimg(img: urlText)
                        }
                        else {
                            let progress = ProgressDialog(delegate: self)
                            self.showToast(message: "Failed to upload", font: .systemFont(ofSize: 10.0))
                            progress.Close()
                        }
                    })
                    
                }
            }
        }
    }
    
    func  setupUserimg(img: String)
    {
        let date = Date() // current date
        let timestamp = date.toMilliseconds()
    
        let timestring = String(timestamp)
        
        textView.text = timestring
        
        var HobbyText = hobbyText.text
        
        if HobbyText == "Select Hobby"
        {
            HobbyText = "artist"
        }
        guard let userid = FirebaseAuth.Auth.auth().currentUser?.uid else {
            
            return
        }
        
        let push = Database.database().reference().childByAutoId()
        
        let userData = [
            "description": DescriptionField.text!,
            "hobby": HobbyText!,
            "picid": push.key! as String,
            "picimage": img,
            "publisher": userid,
            "timestamp": timestamp,
            "timestring": timestring
        ] as [String : Any]
        let setLocation = FirebaseDatabase.Database.database().reference().child("Pics").child(timestring)
        
        setLocation.setValue(userData)
        
        let userData1 = [
            "description": DescriptionField.text!,
            "hobby": HobbyText!,
            "postimage": img,
            "publisher": userid,
            "timestamp": timestamp,
            "timestring": timestring
        ] as [String : Any]
        let setLocation1 = FirebaseDatabase.Database.database().reference().child("ZingingPosts").child(timestring)
        
        setLocation1.setValue(userData1)
        
        let countRef = Database.database().reference().child("Users").child(userid).child("zingingpost").child(timestring)
        
        countRef.setValue(true)
            
        
        self.showToast(message: "Image Uploaded", font: .systemFont(ofSize: 12.0))
        
        let notifData = [
            "description": "Has a new post!",
            "publisher": userid,
            "post": img,
            "timestamp": timestamp,
            "timestring": timestring,
            "posttype": "ZingingPost"
        ] as [String : Any]
        
        let notifLocation =
            Database.database().reference().child("PostNotifications").child(timestring)
        
        notifLocation.setValue(notifData)
        let progress = ProgressDialog(delegate: self)
        
        progress.Close()
        
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        
        PictureView.image = image
        
        picker.dismiss(animated: true, completion: nil)
        VALIDATION = "yes"
        UploadButton.setTitle("Post", for: .normal)
        NoPicLabel.isHidden = true
        fillImage.isHidden = true
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

extension UploadPic: UIPickerViewDelegate, UIPickerViewDataSource
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
    }
}
