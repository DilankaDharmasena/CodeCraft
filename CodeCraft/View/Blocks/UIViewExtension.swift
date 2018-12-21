//
//  UIViewExtension.swift
//  CodeCraft
//
//  Created by Dilanka Dharmasena on 12/20/18.
//  Copyright © 2018 dilankadharmasena. All rights reserved.
//

import UIKit

extension UIView {
    
    @IBInspectable var CornerRadius : CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    // min x min y
    @IBInspectable var TopLeftRound : Bool {
        get {
            return layer.maskedCorners.contains(.layerMinXMinYCorner)
        }
        set {
            if(newValue) {
                layer.maskedCorners.insert(.layerMinXMinYCorner)
            } else {
                layer.maskedCorners.remove(.layerMinXMinYCorner)
            }
        }
    }
    
    // max x min y
    @IBInspectable var TopRightRound : Bool {
        get {
            return layer.maskedCorners.contains(.layerMaxXMinYCorner)
        }
        set {
            if(newValue) {
                layer.maskedCorners.insert(.layerMaxXMinYCorner)
            } else {
                layer.maskedCorners.remove(.layerMaxXMinYCorner)
            }
        }
    }
    
    // min x max y
    @IBInspectable var BottomLeftRound : Bool {
        get {
            return layer.maskedCorners.contains(.layerMinXMaxYCorner)
        }
        set {
            if(newValue) {
                layer.maskedCorners.insert(.layerMinXMaxYCorner)
            } else {
                layer.maskedCorners.remove(.layerMinXMaxYCorner)
            }
        }
    }
    
    // max x max y
    @IBInspectable var BottomRightRound : Bool {
        get {
            return layer.maskedCorners.contains(.layerMaxXMaxYCorner)
        }
        set {
            if(newValue) {
                layer.maskedCorners.insert(.layerMaxXMaxYCorner)
            } else {
                layer.maskedCorners.remove(.layerMaxXMaxYCorner)
            }
        }
    }
    
}
