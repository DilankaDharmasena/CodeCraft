//
//  Block_1.swift
//  CodeCraft
//
//  Created by Dilanka Dharmasena on 12/24/18.
//  Copyright © 2018 dilankadharmasena. All rights reserved.
//

import UIKit

class Block_1: Block {
    
    @IBOutlet weak var operationLabel: UILabel!
    
    // Required overrides
    override var bottomBuffer: CGFloat { return -buffer }
    
    // Custom
    
    func setOperation(operation : String) {
        operationLabel.text = operation
    }
    
}
