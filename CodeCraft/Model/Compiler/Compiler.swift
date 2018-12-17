//
//  Compiler.swift
//  CodeCraft
//
//  Created by Dilanka Dharmasena on 11/28/18.
//  Copyright © 2018 dilankadharmasena. All rights reserved.
//

import Foundation

class Compiler {
    
    func checkTimeout(startTime: TimeInterval) -> ErrorCode {
        let currTime = NSDate().timeIntervalSince1970
        
        if(startTime + 10 < currTime) {
            return 1
        }
        
        return 0
    }
    
    func fixScope(newVars: Variables, oldVars: Variables) -> Variables {
        
        var variableUpdate : Variables = [:]
        
        for key in oldVars.keys {
            variableUpdate[key] = newVars[key]
        }
        
        if(newVars["SUBMIT"] != nil) {
            variableUpdate["SUBMIT"] = newVars["SUBMIT"]
        }
        
        return variableUpdate
        
    }
    
    
    func runCode(variables : Variables, code : Code, startTime: TimeInterval) -> (Variables, ErrorCode) {
        
        if(checkTimeout(startTime: startTime) == 1) {
            return ([:], 1)
        }
        
        var variableUpdate = variables
        
        for line in code {
            
            let lineUnwrapped = line as! Code
            let operation = lineUnwrapped[0] as! String
            let inputs = lineUnwrapped[1] as! Code
            
            var result : (Variables, ErrorCode)
            
            switch operation{
            case "SET":
                result = evaluateSet(variables : variableUpdate, code : inputs, startTime: startTime)
            case "IF":
                result = evaluateIf(variables : variableUpdate, code : inputs, startTime: startTime)
            case "FOR":
                result = evaluateFor(variables : variableUpdate, code : inputs, startTime: startTime)
            case "WHILE":
                result = evaluateWhile(variables : variableUpdate, code : inputs, startTime: startTime)
            default:
                result = evaluateSubmit(variables : variableUpdate, code : inputs, startTime: startTime)
            }
            
            if(result.1 == 2) {
                return (result.0, 0)
            } else if (result.1 == 1) {
                return ([:], 1)
            }
            
            variableUpdate = result.0
        }
        
        return (variableUpdate, 0)
        
    }
    
    // SET{VAR, val_type, VAR or NUM or MATH, var exists}
    func evaluateSet(variables : Variables, code : Code, startTime: TimeInterval) ->  (Variables, ErrorCode) {
        
        if(checkTimeout(startTime: startTime) == 1) {
            return ([:], 1)
        }
        
        let var_exists : Bool = code[3] as! Bool
        
        if(!var_exists) {
            return ([:], 1)
        }
        
        let varToBeSet : String = code[0] as! String
        let valType : String = code[1] as! String
        
        var variablesUpdate = variables
        
        switch valType {
        case "VAR":
            let varToBeReceived : String = code[2] as! String
            
            if(variables[varToBeReceived] == nil) {
                return ([:], 1)
            }
            
            variablesUpdate[varToBeSet] = variables[varToBeReceived]
        case "NUM":
            let num : Int = code[2] as! Int
            variablesUpdate[varToBeSet] = num
        case "MATH":
            var res : (Int, ErrorCode)
            res = evaluateMath(variables : variables, code: code[2] as! Code, startTime: startTime)
            
            if (res.1 == 1) {
                return ([:], 1)
            }
            
            variablesUpdate[varToBeSet] = res.0
        default:
            return ([:], 1)
        }
        
        return (variablesUpdate, 0)
        
    }
    
    // MATH{mOP_ID, val_type, VAR or NUM or MATH, val_type, VAR or NUM or MATH}
    func evaluateMath(variables : Variables, code: Code, startTime: TimeInterval) -> (Int, ErrorCode) {
        
        if(checkTimeout(startTime: startTime) == 1) {
            return (0, 1)
        }
        
        let OpId = code[0] as! String
        let valType1 = code[1] as! String
        let valType2 = code[3] as! String
        
        var val1 : Int = 0
        var val2 : Int = 0
        
        var retVal : Int = 0
        
        switch valType1 {
        case "VAR":
            let varToBeReceived : String = code[2] as! String
            
            if(variables[varToBeReceived] == nil) {
                return (0,1)
            }
            
            val1 = variables[varToBeReceived]!
        case "NUM":
            val1 = code[2] as! Int
        case "MATH":
            
            var res : (Int, ErrorCode)
            
            res = evaluateMath(variables: variables, code: code[2] as! Code, startTime: startTime)
            
            if (res.1 == 1) {
                return (0, 1)
            }
            
            val1 = res.0
        default:
            return (0, 1)
        }
        
        switch valType2 {
        case "VAR":
            let varToBeReceived : String = code[4] as! String
            
            if(variables[varToBeReceived] == nil) {
                return (0,1)
            }
            
            val2 = variables[varToBeReceived]!
        case "NUM":
            val2 = code[4] as! Int
        case "MATH":
            var res : (Int, ErrorCode)
            res = evaluateMath(variables: variables, code: code[4] as! Code, startTime: startTime)
            
            if (res.1 == 1) {
                return (0, 1)
            }
            
            val2 = res.0
        default:
            return (0, 1)
        }
        
        switch OpId {
        case "+":
            retVal = val1 + val2
        case "-":
            retVal = val1 - val2
        case "*":
            retVal = val1 * val2
        case "/":
            
            if(val2 == 0) {
                return (0,1)
            }
            
            retVal = val1 / val2
        case "%":
            retVal = val1 % val2
        default:
            return (0, 1)
        }
        
        return (retVal, 0)
    }
    
    // COMP{cOP_ID, val_type, VAR or NUM or MATH, val_type, VAR or NUM or MATH}
    func evaluateComp(variables : Variables, code: Code, startTime: TimeInterval) -> (Bool, ErrorCode) {
        
        if(checkTimeout(startTime: startTime) == 1) {
            return (false, 1)
        }
        
        let OpId = code[0] as! String
        let valType1 = code[1] as! String
        let valType2 = code[3] as! String
        
        var val1 : Int = 0
        var val2 : Int = 0
        
        var retVal : Bool = false
        
        switch valType1 {
        case "VAR":
            let varToBeReceived : String = code[2] as! String
            if(variables[varToBeReceived] == nil) {
                return (false,1)
            }
            val1 = variables[varToBeReceived]!
        case "NUM":
            val1 = code[2] as! Int
        case "MATH":
            var res : (Int, ErrorCode)
            res = evaluateMath(variables: variables, code: code[2] as! Code, startTime: startTime)
            if (res.1 == 1) {
                return (false, 1)
            }
            val1 = res.0
        default:
            return (false, 1)
        }
        
        switch valType2 {
        case "VAR":
            let varToBeReceived : String = code[4] as! String
            if(variables[varToBeReceived] == nil) {
                return (false,1)
            }
            val2 = variables[varToBeReceived]!
        case "NUM":
            val2 = code[4] as! Int
        case "MATH":
            var res : (Int, ErrorCode)
            res = evaluateMath(variables: variables, code: code[4] as! Code, startTime: startTime)
            if (res.1 == 1) {
                return (false, 1)
            }
            val2 = res.0
        default:
            return (false, 1)
        }
        
        switch OpId {
        case "==":
            retVal = (val1 == val2)
        case "!=":
            retVal = (val1 != val2)
        case "<=":
            retVal = (val1 <= val2)
        case ">=":
            retVal = (val1 >= val2)
        case "<":
            retVal = (val1 < val2)
        case ">":
            retVal = (val1 > val2)
        default:
            return (false,1)
        }
        
        return (retVal, 0)
    }
    
    // IF{COMP, [Operations], comp_exists}
    func evaluateIf(variables : Variables, code: Code, startTime: TimeInterval) -> (Variables, ErrorCode) {
        
        if(checkTimeout(startTime: startTime) == 1) {
            return ([:], 1)
        }
        
        let comp_exists : Bool = code[2] as! Bool
        
        if(!comp_exists) {
            return ([:], 1)
        }
        
        var cRes : (Bool, ErrorCode)
        
        cRes = evaluateComp(variables : variables, code: code[0] as! Code, startTime: startTime)
        if (cRes.1 == 1) {
            return ([:], 1)
        }
        
        let boolean = cRes.0
        
        var variableUpdate = variables
        
        if(boolean) {
            var res : (Variables, ErrorCode)
            res = runCode(variables : variableUpdate, code : code[1] as! Code, startTime: startTime)
            if (res.1 == 1) {
                return ([:], 1)
            }
            variableUpdate = res.0
        }
        
        variableUpdate = fixScope(newVars: variableUpdate, oldVars: variables)
        
        return (variableUpdate, 0)
    }
    
    // FOR{val_type, VAR or NUM or MATH, [Operations]}
    func evaluateFor(variables : Variables, code: Code, startTime: TimeInterval) -> (Variables, ErrorCode) {
        
        if(checkTimeout(startTime: startTime) == 1) {
            return ([:], 1)
        }
        
        let valType : String = code[0] as! String
        var val : Int = 0
        
        switch valType {
        case "VAR":
            let varToBeReceived : String = code[1] as! String
            if(variables[varToBeReceived] == nil) {
                return ([:],1)
            }
            val = variables[varToBeReceived]!
        case "NUM":
            val = code[1] as! Int
        case "MATH":
            var res : (Int, ErrorCode)
            res = evaluateMath(variables: variables, code: code[1] as! Code, startTime: startTime)
            if (res.1 == 1) {
                return ([:], 1)
            }
            val = res.0
        default:
            return ([:],1)
        }
        
        var variableUpdate = variables
        
        if(val < 0) {
            return ([:], 1)
        }
        
        for _ in 0..<val {
            var res : (Variables, ErrorCode)
            res = runCode(variables : variableUpdate, code : code[2] as! Code, startTime: startTime)
            if (res.1 == 1) {
                return ([:], 1)
            }
            variableUpdate = res.0
        }
        
        variableUpdate = fixScope(newVars: variableUpdate, oldVars: variables)
        
        return (variableUpdate, 0)
    }
    
    // WHILE{COMP, [Operations], comp_exists}
    func evaluateWhile(variables : Variables, code: Code, startTime: TimeInterval) -> (Variables, ErrorCode) {
        
        if(checkTimeout(startTime: startTime) == 1) {
            return ([:], 1)
        }
        
        let comp_exists : Bool = code[2] as! Bool
        
        if(!comp_exists) {
            return ([:], 1)
        }
        
        var variableUpdate = variables
        var track : Bool = true
        
        while(track) {
            var cRes : (Bool, ErrorCode)
            
            cRes = evaluateComp(variables : variableUpdate, code: code[0] as! Code, startTime: startTime)
            if (cRes.1 == 1) {
                return ([:], 1)
            }
            
            let boolean = cRes.0
            
            if(boolean) {
                var res : (Variables, ErrorCode)
                res = runCode(variables : variableUpdate, code : code[1] as! Code, startTime: startTime)
                if (res.1 == 1) {
                    return ([:], 1)
                }
                variableUpdate = res.0
            } else {
                track = false
            }
        }
        
        variableUpdate = fixScope(newVars: variableUpdate, oldVars: variables)
        
        return (variableUpdate, 0)
    }
    
    // SUBMIT{val_type, VAR or NUM or MATH}
    func evaluateSubmit(variables : Variables, code: Code, startTime: TimeInterval) -> (Variables, ErrorCode) {
        
        if(checkTimeout(startTime: startTime) == 1) {
            return ([:], 1)
        }
        
        var variablesUpdate = variables
        
        if(variables["SUBMIT"] == nil){
            var codeCopy = code
            codeCopy.insert("SUBMIT", at: 0)
            codeCopy.append(true)
            
            var res : (Variables, ErrorCode)
            
            res = evaluateSet(variables : variables, code : codeCopy, startTime: startTime)
            
            if (res.1 == 1) {
                return ([:], 1)
            }
            
            variablesUpdate = res.0
        }
        
        return (variablesUpdate, 2)
    }
    
}
