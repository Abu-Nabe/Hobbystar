//
//  PictureOnClick.swift
//  Zinging
//
//  Created by Abu Nabe on 26/2/21.
//

import UIKit

class PictureOnClick: UIViewController
{
    var PictureString: String!
    
    var PictureView: UIImageView = {
        let profileimage = UIImageView()
        
        profileimage.contentMode = .scaleAspectFit
        profileimage.clipsToBounds = true
        
        return profileimage
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(PictureView)
        
        PictureView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        
        let url = URL(string: PictureString)
        
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in

            if let error = error {
                print("There was an error fetching the image from the url: \n", error)
            }

            if let data = data, let profilePicture = UIImage(data: data) {
                DispatchQueue.main.async() {
                    self.PictureView.image = profilePicture // Set the profile picture
                }
            } else {
                print("Something is wrong with the image data")
            }

        }).resume()
        
        let picTap = UITapGestureRecognizer(target: self, action: #selector(Dismiss))
        picTap.numberOfTapsRequired = 1
        PictureView.isUserInteractionEnabled = true
        PictureView.addGestureRecognizer(picTap)
    }
    @objc func Dismiss()
    {
        self.dismiss(animated: true, completion: nil)
    }
}
