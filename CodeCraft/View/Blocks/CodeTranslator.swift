//
//  CodeTranslator.swift
//  CodeCraft
//
//  Created by Dilanka Dharmasena on 11/28/18.
//  Copyright © 2018 dilankadharmasena. All rights reserved.
//

import UIKit

class CodeTranslator {
    
    let blockDimensions = BlockDimensions()
    
    let blockDelegate : BlockDelegate
    
    init(editor : BlockDelegate) {
        blockDelegate = editor
    }
    
    func translateToBlocks(type: String, inputs: Code, currID: BlockID, highlight: BlockID) -> UIView {
        switch type {
        case "WHILE":
            
            var view1 : UIView
            var views : [UIView]
            
            var parentLocation = [currID.internalLocation, 1]
            if var updatedLocation = currID.parentLocation {
                updatedLocation.append(contentsOf: [currID.internalLocation, 1])
                parentLocation = updatedLocation
            }
            let view1ID = BlockID(parentType: .whileBlock, parentLocation: parentLocation, parentRelationship: .firstInput, internalType: nil, internalLocation: -1)
            
            let comp_exists = inputs[2] as! Bool
            if(comp_exists) {
                view1 = translateToBlocks(type: "COMP", inputs: inputs[0] as! Code, currID: view1ID, highlight: highlight)
            } else {
                view1 = translateToBlocks(type: "BLANK", inputs: [] as Code, currID: view1ID, highlight: highlight)
            }
            
            if(currID.parentLocation == nil) {
                views = parseOperations(code: inputs[1] as! Code, location: [currID.internalLocation, 1, 1], highlight: highlight)
            } else {
                var updatedLocation = currID.parentLocation
                updatedLocation?.append(contentsOf: [currID.internalLocation, 1, 1])
                views = parseOperations(code: inputs[1] as! Code, location: updatedLocation, highlight: highlight)
            }
            
            let size = blockDimensions.whileBlock(compView: view1, operations: views)
            let frame = CGRect(origin: CGPoint.zero, size: size)
            let block = WhileBlock(frame: frame)
            block.setCheck(newView: view1)
            block.setOperations(opViews: views)
            block.setID(id: currID.changeType(type: .whileBlock))
            block.delegate = blockDelegate
            return block
            
        case "FOR":
            
            var view1 : UIView
            var views : [UIView]
            
            var parentLocation = [currID.internalLocation, 1]
            if var updatedLocation = currID.parentLocation {
                updatedLocation.append(contentsOf: [currID.internalLocation, 1])
                parentLocation = updatedLocation
            }
        
            let view1ID = BlockID(parentType: .forBlock, parentLocation: parentLocation, parentRelationship: .firstInput, internalType: nil, internalLocation: -1)
            
            let valType1 = inputs[0] as! String
            switch valType1 {
            case "MATH":
                view1 = translateToBlocks(type: valType1, inputs: inputs[1] as! Code, currID: view1ID, highlight: highlight)
            default:
                view1 = translateToBlocks(type: valType1, inputs: [inputs[1]], currID: view1ID, highlight: highlight)
            }
            
            if(currID.parentLocation == nil) {
                views = parseOperations(code: inputs[2] as! Code, location: [currID.internalLocation, 1, 2], highlight: highlight)
            } else {
                var updatedLocation = currID.parentLocation
                updatedLocation?.append(contentsOf: [currID.internalLocation, 1, 2])
                views = parseOperations(code: inputs[2] as! Code, location: updatedLocation, highlight: highlight)
            }
            
            let size = blockDimensions.forBlock(iterView: view1, operations: views)
            let frame = CGRect(origin: CGPoint.zero, size: size)
            let block = ForBlock(frame: frame)
            block.setCheck(newView: view1)
            block.setOperations(opViews: views)
            block.setID(id: currID.changeType(type: .forBlock))
            block.delegate = blockDelegate
            return block
            
        case "IF":
            
            var view1 : UIView
            var views : [UIView]
            
            var parentLocation = [currID.internalLocation, 1]
            if var updatedLocation = currID.parentLocation {
                updatedLocation.append(contentsOf: [currID.internalLocation, 1])
                parentLocation = updatedLocation
            }
            let view1ID = BlockID(parentType: .ifBlock, parentLocation: parentLocation, parentRelationship: .firstInput, internalType: nil, internalLocation: -1)
            
            let comp_exists = inputs[2] as! Bool
            if(comp_exists) {
                view1 = translateToBlocks(type: "COMP", inputs: inputs[0] as! Code, currID: view1ID, highlight: highlight)
            } else {
                view1 = translateToBlocks(type: "BLANK", inputs: [] as Code, currID: view1ID, highlight: highlight)
            }
            
            if(currID.parentLocation == nil) {
                views = parseOperations(code: inputs[1] as! Code, location: [currID.internalLocation, 1, 1], highlight: highlight)
            } else {
                var updatedLocation = currID.parentLocation
                updatedLocation?.append(contentsOf: [currID.internalLocation, 1, 1])
                views = parseOperations(code: inputs[1] as! Code, location: updatedLocation, highlight: highlight)
            }
            
            let size = blockDimensions.ifBlock(compView: view1, operations: views)
            let frame = CGRect(origin: CGPoint.zero, size: size)
            let block = IfBlock(frame: frame)
            block.setCheck(newView: view1)
            block.setOperations(opViews: views)
            block.setID(id: currID.changeType(type: .ifBlock))
            block.delegate = blockDelegate
            return block
            
            
        case "SUBMIT":
            
            var view1 : UIView
            
            var parentLocation = [currID.internalLocation, 1]
            if var updatedLocation = currID.parentLocation {
                updatedLocation.append(contentsOf: [currID.internalLocation, 1])
                parentLocation = updatedLocation
            }
            let view1ID = BlockID(parentType: .submitBlock, parentLocation: parentLocation, parentRelationship: .firstInput, internalType: nil, internalLocation: -1)
            
            let valType1 = inputs[0] as! String
            switch valType1 {
            case "MATH":
                view1 = translateToBlocks(type: valType1, inputs: inputs[1] as! Code, currID: view1ID, highlight: highlight)
            default:
                view1 = translateToBlocks(type: valType1, inputs: [inputs[1]], currID: view1ID, highlight: highlight)
            }
            
            let size = blockDimensions.submitBlock(inputView: view1)
            let frame = CGRect(origin: CGPoint.zero, size: size)
            let block = SubmitBlock(frame: frame)
            block.setVal(valView: view1)
            block.setID(id: currID.changeType(type: .submitBlock))
            block.delegate = blockDelegate
            return block
            
        case "SET":
            
            var view1 : UIView
            var view2 : UIView
            
            var parentLocation = [currID.internalLocation, 1]
            if var updatedLocation = currID.parentLocation {
                updatedLocation.append(contentsOf: [currID.internalLocation, 1])
                parentLocation = updatedLocation
            }
            let view1ID = BlockID(parentType: .setBlock, parentLocation: parentLocation, parentRelationship: .firstInput, internalType: nil, internalLocation: -1)
            
            let var_exists = inputs[3] as! Bool
            if(var_exists) {
                view1 = translateToBlocks(type: "VAR", inputs: [inputs[0]], currID: view1ID, highlight: highlight)
            } else {
                view1 = translateToBlocks(type: "BLANK", inputs: [] as Code, currID: view1ID, highlight: highlight)
            }
            
            let view2ID = BlockID(parentType: .setBlock, parentLocation: parentLocation, parentRelationship: .secondInput, internalType: nil, internalLocation: -1)
            
            let valType1 = inputs[1] as! String
            switch valType1 {
            case "MATH":
                view2 = translateToBlocks(type: valType1, inputs: inputs[2] as! Code, currID: view2ID, highlight: highlight)
            default:
                view2 = translateToBlocks(type: valType1, inputs: [inputs[2]], currID: view2ID, highlight: highlight)
            }
            
            let size = blockDimensions.setBlock(varView: view1, valView: view2)
            let frame = CGRect(origin: CGPoint.zero, size: size)
            let block = SetBlock(frame: frame)
            block.setVar(varView: view1)
            block.setVal(valView: view2)
            block.setID(id: currID.changeType(type: .setBlock))
            block.delegate = blockDelegate
            return block
            
        case "COMP":
            
            let opID = inputs[0] as! String
            let valType1 = inputs[1] as! String
            let valType2 = inputs[3] as! String
            
            var view1 : UIView
            var view2 : UIView
            
            var parentLocation = currID.parentLocation
            parentLocation?.append(0)
            
            let view1ID = BlockID(parentType: .compBlock, parentLocation: parentLocation, parentRelationship: .firstInput, internalType: nil, internalLocation: -1)
            
            switch valType1 {
            case "MATH":
                view1 = translateToBlocks(type: valType1, inputs: inputs[2] as! Code, currID: view1ID, highlight: highlight)
            default:
                view1 = translateToBlocks(type: valType1, inputs: [inputs[2]], currID: view1ID, highlight: highlight)
            }
            
            let view2ID = BlockID(parentType: .compBlock, parentLocation: parentLocation, parentRelationship: .secondInput, internalType: nil, internalLocation: -1)
            
            switch valType2 {
            case "MATH":
                view2 = translateToBlocks(type: valType2, inputs: inputs[4] as! Code, currID: view2ID, highlight: highlight)
            default:
                view2 = translateToBlocks(type: valType2, inputs: [inputs[4]], currID: view2ID, highlight: highlight)
            }
            
            let size = blockDimensions.compBlock(firstInputView: view1, secondInputView: view2)
            let frame = CGRect(origin: CGPoint.zero, size: size)
            let block = CompBlock(frame: frame)
            block.setOperation(operation: opID)
            block.setFirstInput(inputView: view1)
            block.setSecondInput(inputView: view2)
            block.setID(id: currID.changeType(type: .compBlock))
            block.delegate = blockDelegate
            return block
            
        case "MATH":
            
            let opID = inputs[0] as! String
            let valType1 = inputs[1] as! String
            let valType2 = inputs[3] as! String
            
            var view1 : UIView
            var view2 : UIView
            
            var parentLocation = currID.parentLocation
            switch currID.parentType {
            case .setBlock:
                parentLocation?.append(2)
            case .mathBlock, .compBlock:
                if(currID.parentRelationship == .firstInput) {
                    parentLocation?.append(2)
                } else {
                    parentLocation?.append(4)
                }
            case .forBlock, .submitBlock:
                parentLocation?.append(1)
            default:
                break
            }
            
            let view1ID = BlockID(parentType: .mathBlock, parentLocation: parentLocation, parentRelationship: .firstInput, internalType: nil, internalLocation: -1)
            
            switch valType1 {
            case "MATH":
                view1 = translateToBlocks(type: valType1, inputs: inputs[2] as! Code, currID: view1ID, highlight: highlight)
            default:
                view1 = translateToBlocks(type: valType1, inputs: [inputs[2]], currID: view1ID, highlight: highlight)
            }
            
            let view2ID = BlockID(parentType: .mathBlock, parentLocation: parentLocation, parentRelationship: .secondInput, internalType: nil, internalLocation: -1)
            
            switch valType2 {
            case "MATH":
                view2 = translateToBlocks(type: valType2, inputs: inputs[4] as! Code, currID: view2ID, highlight: highlight)
            default:
                view2 = translateToBlocks(type: valType2, inputs: [inputs[4]], currID: view2ID, highlight: highlight)
            }
            
            let size = blockDimensions.mathBlock(firstInputView: view1, secondInputView: view2)
            let frame = CGRect(origin: CGPoint.zero, size: size)
            let block = MathBlock(frame: frame)
            block.setOperation(operation: opID)
            block.setFirstInput(inputView: view1)
            block.setSecondInput(inputView: view2)
            block.setID(id: currID.changeType(type: .mathBlock))
            block.delegate = blockDelegate
            return block
            
            
        case "NUM":
            
            let num = inputs[0] as! Int
            let size = blockDimensions.numBlock()
            let frame = CGRect(origin: CGPoint.zero, size: size)
            let block = NumBlock(frame: frame)
            block.setOperation(operation: String(num))
            block.setID(id: currID.changeType(type: .numBlock))
            block.delegate = blockDelegate
            return block
            
        case "VAR":
            
            let varID = inputs[0] as! String
            let size = blockDimensions.varBlock()
            let frame = CGRect(origin: CGPoint.zero, size: size)
            let block = VarBlock(frame: frame)
            block.setOperation(operation: varID)
            block.setID(id: currID.changeType(type: .varBlock))
            block.delegate = blockDelegate
            return block
            
        default:
            
            let size = blockDimensions.blankBlock()
            let frame = CGRect(origin: CGPoint.zero, size: size)
            let block = BlankBlock(frame: frame)
            block.setID(id: currID.changeType(type: .blankBlock))
            block.delegate = blockDelegate
            return block
            
        }
    }
    
    
    func parseOperations(code: Code, location : ParentLocation, highlight: BlockID) -> [UIView] {
        
        var views : [UIView] = []
        
        if(code.isEmpty) {
            let currID = BlockID(parentType: .operationBlock, parentLocation: location, parentRelationship: .operation, internalType: nil, internalLocation: 0)
            views.append(translateToBlocks(type: "BLANK", inputs: [] as Code, currID: currID, highlight: highlight))
        } else {
        
            for (index, line) in code.enumerated() {
            
                let lineUnwrapped = line as! Code
                let operation = lineUnwrapped[0] as! String
                let inputs = lineUnwrapped[1] as! Code
                
                let currID = BlockID(parentType: .operationBlock, parentLocation: location, parentRelationship: .operation, internalType: nil, internalLocation: index)
                
                let newView = translateToBlocks(type: operation, inputs: inputs, currID: currID, highlight: highlight)
                
                if((currID == highlight.changeType(type: nil)) && (highlight.internalType != .blankBlock)) {
                    let newBlock = newView as! Block
                    newBlock.select()
                }
                
                views.append(newView)
            }
            
        }
        
        return views
        
    }
    
    func mainView(code : Code, highlight: BlockID) -> UIStackView {
        
        let views = parseOperations(code: code, location: [], highlight: highlight)
        let size = blockDimensions.mainView(views: views)
        let frame = CGRect(origin: CGPoint.zero, size: size)
        let stackView = UIStackView(frame: frame)
        stackView.axis = .vertical
        
        for view in views {
            stackView.addArrangedSubview(view)
        }
        
        return stackView
        
    }
    
}
