//
//  PlayerView.swift
//  Zinging
//
//  Created by Abu Nabe on 7/1/21.
//

import UIKit
import AVKit
import AVFoundation

class PlayerView: UIView{
    
    override static var layerClass: AnyClass{
        
        return AVPlayerLayer.self;
        
    }
    var playerLayer: AVPlayerLayer
    {
        return layer as! AVPlayerLayer;
    }
    var player: AVPlayer?{
        get{
            return playerLayer.player;
        }
        set {
            playerLayer.player = newValue;
        }
    }
}
