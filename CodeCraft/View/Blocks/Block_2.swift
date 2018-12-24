//
//  Block_2.swift
//  CodeCraft
//
//  Created by Dilanka Dharmasena on 12/24/18.
//  Copyright © 2018 dilankadharmasena. All rights reserved.
//

import UIKit

class Block_2: Block {
    
    @IBOutlet weak var operationLabel: UILabel!
    
    @IBOutlet weak var firstInputView: UIView!
    @IBOutlet weak var firstInputViewHeight: NSLayoutConstraint!
    @IBOutlet weak var firstInputViewWidth: NSLayoutConstraint!
    
    @IBOutlet weak var secondInputView: UIView!
    @IBOutlet weak var secondInputViewHeight: NSLayoutConstraint!
    @IBOutlet weak var secondInputViewWidth: NSLayoutConstraint!
    
    // Required overrides
    override var bottomBuffer: CGFloat { return -buffer }
    
    // Custom functions
    
    func setFirstInput(inputView : UIView) {
        
        firstInputView.addSubview(inputView)
        firstInputViewHeight.constant = inputView.frame.size.height
        firstInputViewWidth.constant = inputView.frame.size.width
        
    }
    
    func setSecondInput(inputView : UIView) {
        
        secondInputView.addSubview(inputView)
        secondInputViewHeight.constant = inputView.frame.size.height
        secondInputViewWidth.constant = inputView.frame.size.width
        
    }
    
    func setOperation(operation : String) {
        operationLabel.text = operation
    }
    
}
