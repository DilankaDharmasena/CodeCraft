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
    
    let compiler = Compiler()
    
    func runTest(gameID : Int, code: Code) -> ErrorCode {
        
        // Wrapper for runCode
        func runTestSub(input : Int, code : Code) -> RunResult {
            var variables : Variables = ["INPUT" : input]
            
            var returnValue : (Variables, ErrorCode)
            
            returnValue = compiler.runCode(variables: variables, code: code, startTime: NSDate().timeIntervalSince1970)
            
            if(returnValue.1 != 0) {
                return RunResult(error: 1, result: 0)
            }
            
            variables = returnValue.0
            
            if(variables["SUBMIT"] == nil) {
                return RunResult(error: 1, result: 0)
            }
            
            let result = RunResult(error: 0, result: variables["SUBMIT"]!) // Add error checking
            
            return result
        }
        
        let level = LevelModelUtils.shared.level(id: gameID)[0]
        
        let levelInputs = level.formattedInputs
        let levelOutputs = level.formattedOutputs
        
        for (index, input) in levelInputs.enumerated() {
            let localResult : RunResult = runTestSub(input: input, code: code)
            if(localResult.error != 0) {
                return localResult.error
            }
            if(localResult.result != levelOutputs[index]) {
                return 1
            }
        }
        
        return 0
    }
    
}
