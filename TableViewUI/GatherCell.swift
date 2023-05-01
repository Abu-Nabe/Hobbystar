//
//  ChatCell.swift
//  Zinging
//
//  Created by Abu Nabe on 20/1/21.
//

import UIKit

class GatherCell: UITableViewCell
{
   
    let Namelabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Username"
        label.font = .boldSystemFont(ofSize: 15)
    
        
        return label
    }()
    
    let bubbleView: UIView = {
            let view = UIView()
        view.backgroundColor = .green
            view.translatesAutoresizingMaskIntoConstraints = false
            view.layer.cornerRadius = 16
            view.layer.masksToBounds = true
            return view
        }()
    
    let textView: UITextView = {
            let tv = UITextView()
            tv.text = ""
            tv.font = UIFont.systemFont(ofSize: 16)
            tv.translatesAutoresizingMaskIntoConstraints = false
            tv.backgroundColor = UIColor.clear
            tv.textColor = .white
            tv.isEditable = false
            return tv
        }()
    
    
      var bubbleWidthAnchor: NSLayoutConstraint?
      var bubbleHeightAnchor: NSLayoutConstraint?
      var bubbleViewRightAnchor: NSLayoutConstraint?
      var bubbleViewLeftAnchor: NSLayoutConstraint?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(Namelabel)
        addSubview(bubbleView)
        addSubview(textView)
    
        //constraints for message bubbles
        
        Namelabel.anchor(left: leftAnchor, bottom: bubbleView.topAnchor, paddingLeft: 8)

        bubbleViewRightAnchor = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
        bubbleViewRightAnchor?.isActive = true
        
        bubbleViewLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8)
        bubbleViewLeftAnchor?.isActive = false
        
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor, constant: 2).isActive = true
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleWidthAnchor?.isActive = true

        bubbleHeightAnchor = bubbleView.heightAnchor.constraint(equalToConstant: 200)
        bubbleHeightAnchor?.isActive = true
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -15).isActive = true
        
        textView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 11).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor, constant: 7).isActive = true
        textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
