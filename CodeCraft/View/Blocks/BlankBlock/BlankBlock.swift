//
//  BlankBlock.swift
//  CodeCraft
//
//  Created by Dilanka Dharmasena on 12/7/18.
//  Copyright © 2018 dilankadharmasena. All rights reserved.
//

import UIKit

class BlankBlock: Block {
    
    // Required overrides
    override var bottomBuffer: CGFloat { return -buffer }
    override var blockName: String { return "BlankBlock" }
    
}
