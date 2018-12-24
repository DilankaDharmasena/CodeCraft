//
//  SetBlock.swift
//  CodeCraft
//
//  Created by Dilanka Dharmasena on 11/29/18.
//  Copyright © 2018 dilankadharmasena. All rights reserved.
//

import UIKit

class SetBlock: Block {
    
    @IBOutlet weak var varToSetView: UIView!
    @IBOutlet weak var varToSetViewWidth: NSLayoutConstraint!
    @IBOutlet weak var varToSetViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var valToSetView: UIView!
    @IBOutlet weak var valToSetViewWidth: NSLayoutConstraint!
    @IBOutlet weak var valToSetViewHeight: NSLayoutConstraint!
    
    // Required overrides
    override var bottomBuffer: CGFloat { return 0 }
    override var blockName: String { return "SetBlock" }
    
    // Custom functions
    
    func setVar(varView : UIView) {
        
        varToSetView.addSubview(varView)
        varToSetViewHeight.constant = varView.frame.size.height
        varToSetViewWidth.constant = varView.frame.size.width
        
    }
    
    func setVal(valView : UIView) {
        
        valToSetView.addSubview(valView)
        valToSetViewHeight.constant = valView.frame.size.height
        valToSetViewWidth.constant = valView.frame.size.width
        
    }

}
