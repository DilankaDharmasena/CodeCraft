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
    
    private func calculateBlockSize(dividers : Int?, operations: [UIView]?) -> CGSize {
        
        var height : CGFloat = 0.0
        var width : CGFloat = Standard_Multi_Block_Width
        
        if let numDivs = dividers {
            height = CGFloat(numDivs) * Standard_Block_Height
        } else {
            return CGSize(width: Standard_Single_Block_Width, height: Standard_Block_Height)
        }
        
        if let uOperations = operations {
            for operation in uOperations {
                height += operation.frame.size.height
                width = max(width, operation.frame.size.width + Standard_Expandable_Width)
            }
        }
        
        return CGSize(width: width, height: height)
    }
    
    func whileBlock(compView : UIView, operations : [UIView]) -> CGSize {
        var newOps = operations
        newOps.append(compView)
        return calculateBlockSize(dividers: 2, operations: newOps)
    }
    
    func forBlock(iterView : UIView, operations : [UIView]) -> CGSize {
        var newOps = operations
        newOps.append(iterView)
        return calculateBlockSize(dividers: 2, operations: newOps)
    }
    
    func ifBlock(compView : UIView, operations : [UIView]) -> CGSize {
        var newOps = operations
        newOps.append(compView)
        return calculateBlockSize(dividers: 2, operations: newOps)
    }
    
    func submitBlock(inputView : UIView) -> CGSize {
        return calculateBlockSize(dividers: 1,  operations: [inputView])
    }
    
    func setBlock(varView : UIView, valView : UIView) -> CGSize {
        return calculateBlockSize(dividers: 2, operations: [varView, valView])
    }
    
    func compBlock(firstInputView : UIView, secondInputView : UIView) -> CGSize {
        return calculateBlockSize(dividers: 1, operations: [firstInputView, secondInputView])
    }
    
    func mathBlock(firstInputView : UIView, secondInputView : UIView) -> CGSize {
        return calculateBlockSize(dividers: 1, operations: [firstInputView, secondInputView])
    }
    
    func varBlock() -> CGSize {
        return calculateBlockSize(dividers: nil, operations: nil)
    }
    
    func numBlock() -> CGSize {
        return calculateBlockSize(dividers: nil, operations: nil)
    }
    
    func blankBlock() -> CGSize {
        return calculateBlockSize(dividers: nil, operations: nil)
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
