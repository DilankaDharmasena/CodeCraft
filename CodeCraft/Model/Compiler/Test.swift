//
//  Test.swift
//  CodeCraft
//
//  Created by Dilanka Dharmasena on 11/28/18.
//  Copyright © 2018 dilankadharmasena. All rights reserved.
//

import Foundation

struct RunResult {
    let error : ErrorCode
    let result : Int
}

class Test {
    
    private func createInitialVariables(input: [Int]) -> Variables {
        
        var returnVars : Variables = [:]
        
        for (index, val) in input.enumerated() {
            let inputName = String(format: "INPUT_%d", index + 1)
            returnVars[inputName] = val
        }
        
        return returnVars
        
    }
    
    // Wrapper for runCode
    func runSim(input : [Int], code : Code) -> RunResult {
        
        var variables = createInitialVariables(input: input)
        
        var returnValue : (Variables, ErrorCode)
        
        returnValue = Compiler().runCode(variables: variables, code: code, startTime: NSDate().timeIntervalSince1970)
        
        if(returnValue.1 != .yesAnswer) {
            return RunResult(error: returnValue.1, result: 0)
        }
        
        variables = returnValue.0
        
        if(variables["SUBMIT"] == nil) {
            return RunResult(error: .internalError, result: 0)
        }
        
        let result = RunResult(error: .yesAnswer, result: variables["SUBMIT"]!)
        
        return result
    }
    
    func runTest(gameID : Int, code: Code) -> ErrorCode {
        
        let level = LevelModelUtils().level(id: gameID)
        let levelInputs = level.formattedInputs
        let levelOutputs = level.formattedOutputs
        
        for (index, input) in levelInputs.enumerated() {
            
            let localResult = runSim(input: input, code: code)
            
            if(localResult.error != .yesAnswer) {
                return localResult.error
            }
            
            if(localResult.result != levelOutputs[index]) {
                return .incorrectAnswer
            }
            
        }
        
        return .yesAnswer
    }
    
}
