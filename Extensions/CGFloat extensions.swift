//
//  CGFloat extensions.swift
//  Zinging
//
//  Created by Abu Nabe on 3/1/21.
//

import UIKit

extension UIView
{
    public var width: CGFloat
    {
        return frame.size.width
    }
    public var height: CGFloat
    {
        return frame.size.height
    }
    public var top: CGFloat
    {
        return frame.origin.y
    }
    public var bottom: CGFloat
    {
        return frame.origin.y + frame.size.height
    }
    public var left: CGFloat
    {
        return frame.origin.x
    }
    public var right: CGFloat
    {
        return frame.origin.x + frame.size.width
    }
}

extension UIView{
    func anchor(top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, paddingTop: CGFloat? = 0, paddingLeft: CGFloat? = 0, paddingBottom: CGFloat? = 0, paddingRight: CGFloat? = 0, width: CGFloat? = nil, height: CGFloat? = nil){
        
        //constraints won't work if you don't call
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop!).isActive = true
        }
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft!).isActive = true
        }
        if let bottom = bottom {
            if let paddingBottom = paddingBottom{
                bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
            }
        }
        if let right = right {
            if let paddingRight = paddingRight{
                rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
            }
        }
        if let width = width{
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if let height = height{
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        
    }
}

