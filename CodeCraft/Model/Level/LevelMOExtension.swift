//
//  LevelMOExtension.swift
//  CodeCraft
//
//  Created by Dilanka Dharmasena on 11/25/18.
//  Copyright © 2018 dilankadharmasena. All rights reserved.
//

import Foundation
import CoreData

extension LevelMO {
    
    var formattedOutputs : [Int] {
        get {
            let formattedOutputs = self.outputs!.components(separatedBy: " : ")
            return formattedOutputs.map({ Int($0)! })
        }
    }
    
    var formattedInputs : [[Int]] {
        get {
            
            var returnVals : [[Int]] = []
            
            let inputLayers = self.inputs!.components(separatedBy: " : ")
            
            for layer in inputLayers {
                let formattedInputs = layer.components(separatedBy: ",")
                returnVals.append(formattedInputs.map({ Int($0)! }))
            }
            
            return returnVals
        }
    }
    
}
