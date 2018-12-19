//
//  Block.swift
//  CodeCraft
//
//  Created by Dilanka Dharmasena on 12/8/18.
//  Copyright © 2018 dilankadharmasena. All rights reserved.
//

import Foundation

protocol BlockDelegate {
    
    func blockToBeEdited(id: BlockID, data: Code)
    
    func blockToBeSelected(id: BlockID)
    
}

protocol Block {
    
    var delegate : BlockDelegate! { get set }
    
    var blockID : BlockID! { get set }
    
    func setID(id : BlockID)
    
    func handleSingleTap()
    
    func handleDoubleTap()
    
    func select()
    
}
