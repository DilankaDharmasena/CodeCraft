//
//  CodeEditor.swift
//  CodeCraft
//
//  Created by Dilanka Dharmasena on 12/8/18.
//  Copyright © 2018 dilankadharmasena. All rights reserved.
//

import Foundation

class CodeEditor {
    
    func unwrap(code: Code, block: BlockID) -> (Code, [Int], [Code]) {
        
        var parent : Code = code
        var history : [Code] = []
        
        var location = block.parentLocation!
        let locationReversed : [Int] = location.reversed()
        
        while(!(location.isEmpty)) {
            history.append(parent)
            parent = parent[location[0]] as! Code
            location.removeFirst()
        }
        
        history = history.reversed()
        
        return (parent, locationReversed, history)
    }
    
    func wrap(parent a: Code, locationReversed b: [Int], history c: [Code]) -> Code {
        
        var parent = a
        var locationReversed = b
        var history = c
        
        while(!(locationReversed.isEmpty)) {
            let temp = parent
            parent = history[0]
            parent[locationReversed[0]] = temp
            history.removeFirst()
            locationReversed.removeFirst()
        }
        
        return parent
        
    }
    
    func varNumMathIndicies(block: BlockID) -> Int {
        
        switch block.parentType {
        case .mathBlock, .compBlock:
            if(block.parentRelationship == .firstInput) {
                return 2
            } else {
                return 4
            }
        case .submitBlock, .forBlock:
            return 1
        default:
            if(block.parentRelationship == .firstInput) {
                return 0
            } else {
                return 2
            }
        }
        
    }
    
    func editCode(code: Code, block: BlockID, data: Code, action: EditAction) -> Code {
        
        var newCode : Code
        
        switch action {
        case .modify:
            newCode = modifyCode(code: code, block: block, data: data)
        case .create:
            newCode = createCode(code: code, block: block, data: data)
        default:
            newCode = deleteCode(code: code, block: block)
            
        }
        
        return newCode
    }
    
    func modifyCode(code: Code, block: BlockID, data: Code) -> Code {
        
        var newCode : Code = []
        var unwrappedCode = unwrap(code: code, block: block)
        var parent = unwrappedCode.0
        
        
        switch block.internalType! {
        case .mathBlock:
            
            let index = varNumMathIndicies(block: block)
            var math : Code = parent[index] as! Code
            math[0] = data[0]
            parent[index] = math as Any
            
        case .varBlock:
            
            let index = varNumMathIndicies(block: block)
            parent[index] = data[0]
            
        case .numBlock:
            
            let index = varNumMathIndicies(block: block)
            parent[index] = data[0]
            
        case .compBlock:
            
            var comp : Code = parent[0] as! Code
            comp[0] = data[0]
            parent[0] = comp as Any
            
        default:
            break
        }
        
        
        unwrappedCode.0 = parent
        newCode = wrap(parent: unwrappedCode.0, locationReversed: unwrappedCode.1, history: unwrappedCode.2)
        return newCode
    }
    
    func createCode(code: Code, block: BlockID, data: Code) -> Code {
        
        var newCode : Code = []
        var unwrappedCode = unwrap(code: code, block: block)
        var parent = unwrappedCode.0
        
        
        switch block.internalType! {
        case .mathBlock:
            
            let index = varNumMathIndicies(block: block)
            parent[index - 1] = "MATH"
            let math : Code = [data[0], "BLANK", "", "BLANK", ""]
            parent[index] = math as Any
            
        case .varBlock:
            
            let index = varNumMathIndicies(block: block)
            parent[index] = data[0]
            
            if(index == 0) {
                parent[3] = true
            } else {
                parent[index - 1] = "VAR"
            }
            
        case .numBlock:
            
            let index = varNumMathIndicies(block: block)
            parent[index - 1] = "NUM"
            parent[index] = data[0]
            
        case .compBlock:
            
            let comp : Code = [data[0], "BLANK", "", "BLANK", ""]
            parent[0] = comp as Any
            parent[2] = true
            
        case .setBlock:
            
            let set : Code = ["SET", ["", "BLANK", "", false]]
            parent.insert(set as Any, at: block.internalLocation)
            
        case .ifBlock:
            
            let ifBlock : Code = ["IF", ["", [], false]]
            parent.insert(ifBlock as Any, at: block.internalLocation)
            
        case .forBlock:
            
            let forBlock : Code = ["FOR", ["BLANK", "", []]]
            parent.insert(forBlock as Any, at: block.internalLocation)
            
        case .whileBlock:
            
            let whileBlock : Code = ["WHILE", ["", [], false]]
            parent.insert(whileBlock as Any, at: block.internalLocation)
            
        case .submitBlock :
            
            let submitBlock : Code = ["SUBMIT", ["BLANK", ""]]
            parent.insert(submitBlock as Any, at: block.internalLocation)
            
        default:
            break
        }
        
        
        unwrappedCode.0 = parent
        newCode = wrap(parent: unwrappedCode.0, locationReversed: unwrappedCode.1, history: unwrappedCode.2)
        return newCode
        
    }
    
    func deleteCode(code: Code, block: BlockID) -> Code {
        
        var newCode : Code = []
        var unwrappedCode = unwrap(code: code, block: block)
        var parent = unwrappedCode.0
        
        
        switch block.internalType! {
        case .mathBlock, .numBlock:
            
            let index = varNumMathIndicies(block: block)
            parent[index] = ""
            parent[index - 1] = "BLANK"
            
        case .varBlock:
            
            let index = varNumMathIndicies(block: block)
            parent[index] = ""
            
            if(index == 0) {
                parent[3] = false
            } else {
                parent[index - 1] = "BLANK"
            }
            
            
        case .compBlock:
            
            parent[0] = ""
            parent[2] = false
            
        default:
            
            parent.remove(at: block.internalLocation)
            
        }
        
        
        unwrappedCode.0 = parent
        newCode = wrap(parent: unwrappedCode.0, locationReversed: unwrappedCode.1, history: unwrappedCode.2)
        return newCode
        
    }
    
}
