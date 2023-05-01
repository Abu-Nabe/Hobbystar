//
//  StoryCell.swift
//  Zinging
//
//  Created by Abu Nabe on 20/1/21.
//

import UIKit

class StoryCell: UICollectionViewCell
{
    static let identifier = "CellID"
    let profileImageView: UIImageView = {
        let profileimage = UIImageView()
        
        profileimage.contentMode = .scaleAspectFill
        profileimage.clipsToBounds = true
        profileimage.layer.borderWidth = 3
        profileimage.layer.borderColor = UIColor.black.cgColor
        profileimage.image = UIImage(systemName: "person.fill")?.withRenderingMode(.alwaysOriginal)
        return profileimage
    }()
    
    let NameLabel: UILabel = {
        let Label = UILabel()
        Label.textAlignment = .center
        Label.text = "Username"
        Label.textColor = .black
        Label.font = .boldSystemFont(ofSize: 12)
        return Label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(profileImageView)
        contentView.addSubview(NameLabel)
        
        profileImageView.layer.cornerRadius = 40/2

        NameLabel.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor).isActive = true
        NameLabel.anchor(top: profileImageView.bottomAnchor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        profileImageView.frame = CGRect(x: 5, y: 0, width: 40, height: 40)
    }

}
