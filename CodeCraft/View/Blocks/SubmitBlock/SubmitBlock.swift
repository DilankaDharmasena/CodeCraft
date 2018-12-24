//
//  SubmitBlock.swift
//  CodeCraft
//
//  Created by Dilanka Dharmasena on 11/29/18.
//  Copyright © 2018 dilankadharmasena. All rights reserved.
//

import UIKit

class SubmitBlock: Block {
    
    @IBOutlet weak var valToSetView: UIView!
    @IBOutlet weak var valToSetViewHeight: NSLayoutConstraint!
    @IBOutlet weak var valToSetViewWidth: NSLayoutConstraint!
    
    // Required overrides
    override var bottomBuffer: CGFloat { return 0 }
    override var blockName: String { return "SubmitBlock" }
    
    // Custom functions
    
    func setVal(valView : UIView) {
        
        valToSetView.addSubview(valView)
        valToSetViewHeight.constant = valView.frame.size.height
        valToSetViewWidth.constant = valView.frame.size.width
        
    }
    
}
