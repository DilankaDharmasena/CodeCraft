//
//  CodeModel.swift
//  CodeCraft
//
//  Created by Dilanka Dharmasena on 12/8/18.
//  Copyright © 2018 dilankadharmasena. All rights reserved.
//

import Foundation

class CodeModel {
    
    var currentCode : Code {
        get {
            return codeHistory[codeIndex].0
        }
        set(newCode) {
            var newHistory : [(Code, BlockID)] = Array(codeHistory.prefix(through: codeIndex))
            newHistory.append((newCode, currentBlock))
            codeHistory = newHistory
            codeIndex += 1
        }
    }
    
    var currentBlock : BlockID {
        get {
            return codeHistory[codeIndex].1
        }
        set(newBlock) {
            codeHistory[codeIndex].1 = newBlock
        }
        
    }
    
    
    var codeHistory : [(Code, BlockID)] = [([], BlockID.start)]
    var codeIndex = 0
    
    init(code : Code, block: BlockID) {
        if(!code.isEmpty) {
            let initial = (code, block)
            codeHistory.append(initial)
            codeIndex += 1
        }
    }
    
    func undo() {
        if(codeIndex > 0) {
            codeIndex -= 1
        }
    }
    
    func redo() {
        if(codeIndex < (codeHistory.count - 1)) {
            codeIndex += 1
        }
    }
    
    func clear() {
        codeHistory = [codeHistory[0]]
        codeIndex = 0
    }
    
}
