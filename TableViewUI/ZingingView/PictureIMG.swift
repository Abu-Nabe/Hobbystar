//
//  PictureIMG.swift
//  Zinging
//
//  Created by Abu Nabe on 24/1/21.
//

import UIKit

class PictureIMG: UITableViewCell
{
    
    let PictureView: UIImageView = {
        let pic = UIImageView()
        pic.contentMode = .scaleAspectFill
        
        return pic
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(PictureView)
        
        PictureView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, height: height)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
