//
//  ValidInputs.swift
//  CodeCraft
//
//  Created by Dilanka Dharmasena on 12/8/18.
//  Copyright © 2018 dilankadharmasena. All rights reserved.
//

import Foundation

class ValidInputs {
    
    let comparisons : [String] = ["==", "!=", "<=", ">=", "<", ">"]
    let math : [String] = ["+", "-", "*", "/", "%"]
    let variables : [String] = ["A", "B", "C", "D", "E" , "F"]
    let num : Int = 2147483647
    
    let blockNames : [InternalType:String] = UniversalStrings().blockNames
    
    func blocks(id: BlockID) -> ([InternalType], [String]) {
        
        var retVal : ([InternalType], [String]) = ([],[])
        
        switch id.parentRelationship {
        case .operation:
            
            retVal.0 = [.whileBlock, .forBlock, .ifBlock, .setBlock, .submitBlock]
            retVal.1 = [blockNames[.whileBlock]!, blockNames[.forBlock]!, blockNames[.ifBlock]!, blockNames[.setBlock]!, blockNames[.submitBlock]!]
            
            
        case .firstInput:
            
            switch id.parentType {
            case .mathBlock, .compBlock, .forBlock, .submitBlock:
                retVal.0 = [.varBlock, .numBlock, .mathBlock]
                retVal.1 = [blockNames[.varBlock]!, blockNames[.numBlock]!, blockNames[.mathBlock]!]
            case .whileBlock, .ifBlock:
                retVal.0 = [.compBlock]
                retVal.1 = [blockNames[.compBlock]!]
            default:
                retVal.0 = [.varBlock]
                retVal.1 = [blockNames[.varBlock]!]
            }
            
            
        default:
            retVal.0 = [.varBlock, .numBlock, .mathBlock]
            retVal.1 = [blockNames[.varBlock]!, blockNames[.numBlock]!, blockNames[.mathBlock]!]
        }
        
        return retVal
    }
    
}
