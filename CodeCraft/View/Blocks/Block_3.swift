//
//  Block_3.swift
//  CodeCraft
//
//  Created by Dilanka Dharmasena on 12/24/18.
//  Copyright © 2018 dilankadharmasena. All rights reserved.
//

import UIKit

class Block_3: Block {
    
    @IBOutlet weak var checkView: UIView!
    @IBOutlet weak var checkViewHeight: NSLayoutConstraint!
    @IBOutlet weak var checkViewWidth: NSLayoutConstraint!
    
    @IBOutlet weak var operationsView: UIStackView!
    @IBOutlet weak var operationsViewHeight: NSLayoutConstraint!
    @IBOutlet weak var operationsViewWidth: NSLayoutConstraint!
    
    // Required overrides
    override var bottomBuffer: CGFloat { return 0 }
    
    // Custom
    
    func setCheck(newView : UIView) {
        
        checkView.addSubview(newView)
        checkViewHeight.constant = newView.frame.size.height
        checkViewWidth.constant = newView.frame.size.width
        
    }
    
    func setOperations(opViews : [UIView]) {
        
        var height : CGFloat = 0.0
        var width = opViews[0].frame.size.width
        
        for view in opViews {
            height += view.frame.size.height
            width = max(width, view.frame.size.width)
            operationsView.addArrangedSubview(view)
        }
        
        operationsViewHeight.constant = height
        operationsViewWidth.constant = width
        
    }
    
}
