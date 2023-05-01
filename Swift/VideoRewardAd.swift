//
//  VideoRewardAd.swift
//  Zinging
//
//  Created by Abu Nabe on 28/2/21.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import GoogleMobileAds

class VideoRewardAd: UIViewController, GADRewardBasedVideoAdDelegate
{
    
    var ref = Database.database().reference()
    var UserId = FirebaseAuth.Auth.auth().currentUser!.uid
    
    let Title: UILabel = {
        let text = UILabel()
        text.text = "Zings"
        text.font = .boldSystemFont(ofSize: 16)
        return text
    }()
    
    let NumberZing: UILabel = {
        let text = UILabel()
        text.text = "0"
        text.textColor = .black
        text.font = .boldSystemFont(ofSize: 12)
        return text
    }()
    
    let ExtraText: UILabel = {
        let text = UILabel()
        text.text = "Zings will be used for future purposes"
        text.textColor = .gray
        text.font = .italicSystemFont(ofSize: 10)
        return text
    }()
    
    
    private let Button: UIButton = {
        let Button = UIButton()
        Button.backgroundColor = .systemGreen
        Button.setTitleColor(.white, for: .normal)
        Button.setTitle("EARN ZINGS BY WATCHING AD VIDEO", for: .normal)
        
        return Button
    }()
    
    let ExtraText1: UILabel = {
        let text = UILabel()
        text.text = "if ad is ready to play, it will say ready to play"
        text.textColor = .gray
        text.font = .italicSystemFont(ofSize: 10)
        return text
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(Title)
        view.addSubview(NumberZing)
        view.addSubview(ExtraText)
        view.addSubview(ExtraText1)
        view.addSubview(Button)
        
        // need loading bar
        
        self.navigationItem.hidesBackButton = false
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = false
        
        Title.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        Title.anchor(top: view.topAnchor, paddingTop: 50)
        
        NumberZing.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        NumberZing.anchor(top: Title.bottomAnchor)
        
        ExtraText.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        ExtraText.anchor(top: ExtraText.bottomAnchor)
        
        Button.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        Button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        Button.addTarget(self, action: #selector(RewardAdCheck), for: .touchUpInside)
        
        ExtraText1.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        ExtraText1.anchor(top: Button.bottomAnchor)
        GADRewardBasedVideoAd.sharedInstance().load(GADRequest(), withAdUnitID: "ca-app-pub-3940256099942544/1712485313")
        
        GADRewardBasedVideoAd.sharedInstance().delegate = self
        
        ref.child("Users").child(UserId).child("zings").observe(.value) { (snapshot) in
            for key in snapshot.children.allObjects as![FirebaseDatabase.DataSnapshot] {
            
                let zings = key.key
                // get children count for keys
            }
        }
    }
    
    @objc func RewardAdCheck()
    {
        if GADRewardBasedVideoAd.sharedInstance().isReady == true {
            Button.setTitle("Ad is ready", for: .normal)
            GADRewardBasedVideoAd.sharedInstance().present(fromRootViewController: self)
        }
    }
    func rewardBasedVideoAdDidClose(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
                
        GADRewardBasedVideoAd.sharedInstance().load(GADRequest(), withAdUnitID: "ca-app-pub-3940256099942544/1712485313")
        Button.setTitle("EARN ZINGS BY WATCHING AD VIDEO", for: .normal)
    }
    
    
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd, didRewardUserWith reward: GADAdReward) {
        
        let pushString = ref.childByAutoId()
        
        let push = pushString as! String
        ref.child("Users").child(UserId).child("zings").child(push).setValue(1)
        ref.child("Users").child(UserId).child("zings").child(push).setValue(1)
        ref.child("Users").child(UserId).child("zings").child(push).setValue(1)
        ref.child("Users").child(UserId).child("zings").child(push).setValue(1)
        ref.child("Users").child(UserId).child("zings").child(push).setValue(1)
    }
}
