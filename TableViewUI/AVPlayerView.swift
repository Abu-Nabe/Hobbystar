//
//  AVPlayerPlaybackView.swift
//  MultipleVideoView
//
//  Created by Four on 25/06/19.
//  Copyright © 2019 Four. All rights reserved.
//
import AVKit
import UIKit

class AVPlayerView: UIView {
    
    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    
    /// Get player
    public var player: AVPlayer? {
        get {
           return (layer as! AVPlayerLayer).player
        }
    }

    func setPlayer(player: AVPlayer) {
        (layer as! AVPlayerLayer).player = player
    }

    func setVideoFillMode(fillMode: AVLayerVideoGravity) {
        let playerLayer = (layer as! AVPlayerLayer)
        playerLayer.videoGravity = fillMode
    }
}
