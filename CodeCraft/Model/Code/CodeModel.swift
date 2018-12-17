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
            return codeHistory[codeIndex]
        }
        set(newCode) {
            var newHistory : [Code] = Array(codeHistory.prefix(through: codeIndex))
            newHistory.append(newCode)
            codeHistory = newHistory
            codeIndex += 1
        }
    }
    
    var codeHistory : [Code] = [[]]
    var codeIndex = 0
    var currBlock : BlockID?
    
    init(code : Code) {
        if(!code.isEmpty) {
            codeHistory.append(code)
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
        codeHistory = [[]]
        codeIndex = 0
    }
    
}
