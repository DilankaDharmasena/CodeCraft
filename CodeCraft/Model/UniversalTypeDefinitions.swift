//
//  UniversalTypeDefinitions.swift
//  CodeCraft
//
//  Created by Dilanka Dharmasena on 11/25/18.
//  Copyright © 2018 dilankadharmasena. All rights reserved.
//

import Foundation

struct Level {  // Used as buffer for level creation and modification
    let id: Int
    let status : Int
    let prompt : String
    let inputs : String
    let outputs : String
    let solution : Code
}

// Used in compiler and game UI

typealias Variables = [String : Int]

typealias Code = [Any]

enum ErrorCode {
    case noAnswer, yesAnswer, internalError, timeoutError, incorrectAnswer, missingBlocksError, outOfScopeError
}

typealias ParentLocation = [Int]?

enum ParentType {
    case whileBlock, forBlock, ifBlock, submitBlock, setBlock, compBlock, mathBlock, operationBlock
}

enum ParentRelationship {
    case firstInput, secondInput, operation
}

enum InternalType {
    case whileBlock, forBlock, ifBlock, submitBlock, setBlock, compBlock, mathBlock, blankBlock, numBlock, varBlock
}

struct BlockID : Equatable {
    
    static var start : BlockID {
        get {
            return BlockID(parentType: .operationBlock, parentLocation: [], parentRelationship: .operation, internalType: .blankBlock, internalLocation: 0)
        }
    }
    
    let parentType : ParentType
    let parentLocation : ParentLocation
    let parentRelationship : ParentRelationship
    let internalType : InternalType!
    let internalLocation : Int
    
    func changeType(type: InternalType?) -> BlockID {
        return BlockID(parentType: self.parentType, parentLocation: self.parentLocation, parentRelationship: self.parentRelationship, internalType: type, internalLocation: self.internalLocation)
    }
    
    static func ==(lhs: BlockID, rhs: BlockID) -> Bool {
        return lhs.parentType == rhs.parentType && lhs.parentLocation == rhs.parentLocation && lhs.parentRelationship == rhs.parentRelationship && lhs.internalType == rhs.internalType && lhs.internalLocation == rhs.internalLocation
    }
}

enum EditAction {
    case create, modify, delete
}

