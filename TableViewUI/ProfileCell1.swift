//
//  StoryCell.swift
//  Zinging
//
//  Created by Abu Nabe on 20/1/21.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class ProfileCell1: UICollectionViewCell
    {
        static let identifier = "CellID"
        static let identifier1 = "CellID1"
    
        
        let PictureView: UIImageView = {
            let pic = UIImageView()
            pic.contentMode = .scaleToFill
            
            return pic
        }()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            addSubview(PictureView)
            
            
            
            PictureView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
            
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }    
}

