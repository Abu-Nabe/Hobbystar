//
//  UploadVid.swift
//  Zinging
//
//  Created by Abu Nabe on 22/1/21.
//

import UIKit
import AVKit
import AVFoundation
import MobileCoreServices
import FirebaseStorage
import FirebaseAuth
import FirebaseDatabase

class UploadVid: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    
    var VALIDATION = "no"
    var player = AVPlayer()
    
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
            Field.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
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
    
    private let VideoView: UIImageView = {
        let video = UIImageView()
        
        return video
    }()
    
    let fillImage: UIImageView = {
        var imageview = UIImageView()
        imageview.image = UIImage(systemName: "plus")
        imageview.tintColor = .gray
        return imageview
    }()
    
    let NoPicLabel: UILabel = {
        let text = UILabel()
        text.text = "Choose A Video"
        text.font = .systemFont(ofSize: 12.0)
        return text
    }()
    
    override func viewDidLoad() {
        view.addSubview(DescriptionField)
        view.addSubview(UploadButton)
        view.addSubview(VideoView)
        view.addSubview(fillImage)
        view.addSubview(NoPicLabel)
        
        view.addSubview(hobbyText)
        view.addSubview(pickerView)
        
                
        pickerView.isHidden = true

        
        VideoView.backgroundColor = .white
        DescriptionField.anchor(top: view.topAnchor, left: view.leftAnchor,right: view.rightAnchor, height: 50)
        
        
        UploadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        UploadButton.anchor(bottom: view.bottomAnchor, paddingBottom: 5, width: view.width/2-30, height: 50)
        
        UploadButton.addTarget(self, action: #selector(Upload), for: .touchUpInside)
        
        NoPicLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        NoPicLabel.anchor(top: fillImage.bottomAnchor)
        
        hobbyText.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        hobbyText.anchor(top: DescriptionField.bottomAnchor, width: view.width, height: 30)
        
        pickerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pickerView.anchor(top: hobbyText.bottomAnchor, width: view.width, height: 100)
        
        VideoView.anchor(top: pickerView.bottomAnchor, bottom: UploadButton.topAnchor, width: view.width)
        
        fillImage.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        fillImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        fillImage.anchor(width: 200, height: 200)
        
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
            let imagePickerController = UIImagePickerController()
            
            imagePickerController.allowsEditing = true
            imagePickerController.delegate = self
            imagePickerController.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
            
            present(imagePickerController, animated: true, completion: nil)
        }
        else {
            
            let progress = ProgressDialog(delegate: self)
            
            progress.Show(animate: true, mesaj: "")
            
            UploadButton.isUserInteractionEnabled = false
            
            let url: URL! = (player.currentItem?.asset as? AVURLAsset)?.url
            
            uploadTOFireBaseVideo(url: url)
            
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
            // we selected a video
            print("Here's the file URL: ", videoURL)
            let downloadURL = videoURL
            let videoURL = URL(string: downloadURL.absoluteString)
            self.player = AVPlayer(url: videoURL!)
            let playerLayer = AVPlayerLayer(player: self.player)
            
            playerLayer.frame = self.view.bounds
            self.view.layer.addSublayer(playerLayer)
            
            
            self.player.play()
            
            self.UploadButton.setTitle("Post", for: .normal)
            NoPicLabel.isHidden = true
            fillImage.isHidden = true
            self.VALIDATION = "yes"
            
        }else {
            let progress = ProgressDialog(delegate: self)
            self.showToast(message: "Failed to upload", font: .systemFont(ofSize: 10.0))
            progress.Close()
            print("Failed")
        }
        //Dismiss the controller after picking some media
        dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func uploadTOFireBaseVideo(url: URL) {
        
        let name = "\(Int(Date().timeIntervalSince1970)).mp4"
        let path = NSTemporaryDirectory() + name
        
        let dispatchgroup = DispatchGroup()
        
        dispatchgroup.enter()
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let outputurl = documentsURL.appendingPathComponent(name)
        var ur = outputurl
        self.convertVideo(toMPEG4FormatForVideo: url as URL, outputURL: outputurl) { (session) in
            
            ur = session.outputURL!
            dispatchgroup.leave()
            
        }
        dispatchgroup.wait()
        
        let data = NSData(contentsOf: ur as URL)
        
        do {
            
            try data?.write(to: URL(fileURLWithPath: path), options: .atomic)
            
        } catch {
            let progress = ProgressDialog(delegate: self)
            self.showToast(message: "Failed to upload", font: .systemFont(ofSize: 10.0))
            progress.Close()
            
            print(error)
        }
        
        let storageRef = Storage.storage().reference().child("videos").child(name)
        if let uploadData = data as Data? {
            storageRef.putData(uploadData, metadata: nil
                               , completion: { (metadata, error) in
                                if let error = error {
                                    let progress = ProgressDialog(delegate: self)
                                    self.showToast(message: "Failed to upload", font: .systemFont(ofSize: 10.0))
                                    progress.Close()
                                    print(error)
                                    
                                }else{
                                    storageRef.downloadURL(completion: { [self](url, error) in
                                        if error != nil {
                                            print(error!.localizedDescription)
                                            return
                                        }
                                        
                                        let date = Date() // current date
                                        let timestamp = date.toMilliseconds()
                                        
                                        let timestring = String(timestamp)
                                        
                                        self.textView.text = timestring
                                        
                                        
                                        var HobbyText = self.hobbyText.text
                                        
                                        if HobbyText == "Select Hobby"
                                        {
                                            HobbyText = "artist"
                                        }
                                        
                                        guard let userid = FirebaseAuth.Auth.auth().currentUser?.uid else {
                                            
                                            return
                                        }
                                        
                                        let ref = Database.database().reference().childByAutoId()
                                        
                                        let Changeurl = url?.absoluteString
                                        
                                        let userData = [
                                            "timestring": timestring,
                                            "timestamp": timestamp,
                                            "videoHobby": HobbyText!,
                                            "videoID": ref.key!,
                                            "videoName": self.DescriptionField.text!,
                                            "videoPublisher": userid,
                                            "videoUrl": Changeurl!,
                                        ] as [String : Any]
                                        
                                        let setLocation = FirebaseDatabase.Database.database().reference().child("Videos").child(timestring)
                                        
                                        setLocation.setValue(userData)
                                        
                                        
                                        let userData1 = [
                                            "description": self.DescriptionField.text!,
                                            "hobby": HobbyText!,
                                            "postimage": Changeurl!,
                                            "publisher": userid,
                                            "timestamp": timestamp,
                                            "timestring": timestring
                                        ] as [String : Any]
                                        let setLocation1 = FirebaseDatabase.Database.database().reference().child("ZingingPosts").child(timestring)
                                        
                                        setLocation1.setValue(userData1)
                                        
                                        let notifData = [
                                            "description": "Has a new post!",
                                            "publisher": userid,
                                            "post": Changeurl!,
                                            "timestamp": timestamp,
                                            "timestring": timestring,
                                            "posttype": "ZingingVideo"
                                        ] as [String : Any]
                                        
                                        let notifLocation =
                                            Database.database().reference().child("PostNotifications").child(timestring)
                                        
                                        notifLocation.setValue(notifData)
                                        
                                        
                                        let countRef = Database.database().reference().child("Users").child(userid).child("zingingvid").child(timestring)
                                        
                                        countRef.setValue(true)
                                        
                                        
                                        self.showToast(message: "Image Uploaded", font: .systemFont(ofSize: 12.0))
                        
                                        let progress = ProgressDialog(delegate: self)
                                        
                                        progress.Close()
                                        
                                        self.dismiss(animated: true, completion: nil)
                                        
                                    })
                                }
                               })
        }
    }
    
    func convertVideo(toMPEG4FormatForVideo inputURL: URL, outputURL: URL, handler: @escaping (AVAssetExportSession) -> Void) {
        try? FileManager.default.removeItem(at: outputURL as URL)
        let asset = AVURLAsset(url: inputURL as URL, options: nil)
        
        let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality)!
        exportSession.outputURL = outputURL
        exportSession.outputFileType = .mp4
        exportSession.exportAsynchronously(completionHandler: {
            handler(exportSession)
        })
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

extension UploadVid: UIPickerViewDelegate, UIPickerViewDataSource
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
