//
//  BlockDimensions.swift
//  CodeCraft
//
//  Created by Dilanka Dharmasena on 12/4/18.
//  Copyright © 2018 dilankadharmasena. All rights reserved.
//

import UIKit

class BlockDimensions {
    
    let Standard_Single_Block_Width : CGFloat = 200.0
    let Standard_Multi_Block_Width : CGFloat = 80.0
    let Standard_Expandable_Width : CGFloat = 30.0
    
    let Standard_Block_Height : CGFloat = 40.0
    
    let Buffer : CGFloat = 3.0
    
    private func calculateBlockSize(dividers : Int?, operations: [UIView]?, operationBlock : Bool) -> CGSize {
        
        var height : CGFloat = 0.0
        var width : CGFloat = Standard_Multi_Block_Width
        
        if let numDivs = dividers {
            height = CGFloat(numDivs) * Standard_Block_Height
        } else {
            return CGSize(width: Standard_Single_Block_Width + Buffer, height: Standard_Block_Height + (Buffer * 2))
        }
        
        if let uOperations = operations {
            for operation in uOperations {
                height += operation.frame.size.height
                width = max(width, operation.frame.size.width + Standard_Expandable_Width)
            }
        }
        
        if(operationBlock) {
            return CGSize(width: width + Buffer, height: height + Buffer)
        } else {
            return CGSize(width: width + Buffer, height: height + (Buffer * 2))
        }
    }
    
    func whileBlock(compView : UIView, operations : [UIView]) -> CGSize {
        var newOps = operations
        newOps.append(compView)
        return calculateBlockSize(dividers: 2, operations: newOps, operationBlock : true)
    }
    
    func forBlock(iterView : UIView, operations : [UIView]) -> CGSize {
        var newOps = operations
        newOps.append(iterView)
        return calculateBlockSize(dividers: 2, operations: newOps, operationBlock : true)
    }
    
    func ifBlock(compView : UIView, operations : [UIView]) -> CGSize {
        var newOps = operations
        newOps.append(compView)
        return calculateBlockSize(dividers: 2, operations: newOps, operationBlock : true)
    }
    
    func submitBlock(inputView : UIView) -> CGSize {
        return calculateBlockSize(dividers: 1,  operations: [inputView], operationBlock : true)
    }
    
    func setBlock(varView : UIView, valView : UIView) -> CGSize {
        return calculateBlockSize(dividers: 2, operations: [varView, valView], operationBlock : true)
    }
    
    func compBlock(firstInputView : UIView, secondInputView : UIView) -> CGSize {
        return calculateBlockSize(dividers: 1, operations: [firstInputView, secondInputView], operationBlock : false)
    }
    
    func mathBlock(firstInputView : UIView, secondInputView : UIView) -> CGSize {
        return calculateBlockSize(dividers: 1, operations: [firstInputView, secondInputView], operationBlock : false)
    }
    
    func varBlock() -> CGSize {
        return calculateBlockSize(dividers: nil, operations: nil, operationBlock : false)
    }
    
    func numBlock() -> CGSize {
        return calculateBlockSize(dividers: nil, operations: nil, operationBlock : false)
    }
    
    func blankBlock() -> CGSize {
        return calculateBlockSize(dividers: nil, operations: nil, operationBlock : false)
    }
    
    func mainView(views: [UIView]) -> CGSize {
        
        var height : CGFloat = 0.0
        var width : CGFloat = 0.0
        
        for operation in views {
            height += operation.frame.size.height
            width = max(width, operation.frame.size.width)
        }
        
        return CGSize(width: width, height: height)
    }
    
}
