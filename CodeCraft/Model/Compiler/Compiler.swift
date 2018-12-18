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
            return .timeoutError
        }
        
        return .noAnswer
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
        
        if(checkTimeout(startTime: startTime) == .timeoutError) {
            return ([:], .timeoutError)
        }
        
        var variableUpdate = variables
        
        for line in code {
            
            let lineUnwrapped = line as! Code
            let operation = lineUnwrapped[0] as! String
            let inputs = lineUnwrapped[1] as! Code
            
            var res : (Variables, ErrorCode)
            
            switch operation{
            case "SET":
                res = evaluateSet(variables : variableUpdate, code : inputs, startTime: startTime)
            case "IF":
                res = evaluateIf(variables : variableUpdate, code : inputs, startTime: startTime)
            case "FOR":
                res = evaluateFor(variables : variableUpdate, code : inputs, startTime: startTime)
            case "WHILE":
                res = evaluateWhile(variables : variableUpdate, code : inputs, startTime: startTime)
            default:
                res = evaluateSubmit(variables : variableUpdate, code : inputs, startTime: startTime)
            }
            
            if(res.1 == .yesAnswer) {
                return (res.0, .yesAnswer)
            } else if (res.1 != .noAnswer) {
                return ([:], res.1)
            }
            
            variableUpdate = res.0
        }
        
        return (variableUpdate, .noAnswer)
        
    }
    
    // SET{VAR, val_type, VAR or NUM or MATH, var exists}
    func evaluateSet(variables : Variables, code : Code, startTime: TimeInterval) ->  (Variables, ErrorCode) {
        
        if(checkTimeout(startTime: startTime) == .timeoutError) {
            return ([:], .timeoutError)
        }
        
        let var_exists : Bool = code[3] as! Bool
        
        if(!var_exists) {
            return ([:], .missingBlocksError)
        }
        
        let varToBeSet : String = code[0] as! String
        let valType : String = code[1] as! String
        
        var variablesUpdate = variables
        
        switch valType {
        case "VAR":
            let varToBeReceived : String = code[2] as! String
            
            if(variables[varToBeReceived] == nil) {
                return ([:], .outOfScopeError)
            }
            
            variablesUpdate[varToBeSet] = variables[varToBeReceived]
        case "NUM":
            let num : Int = code[2] as! Int
            variablesUpdate[varToBeSet] = num
        case "MATH":
            var res : (Int, ErrorCode)
            res = evaluateMath(variables : variables, code: code[2] as! Code, startTime: startTime)
            
            if(res.1 == .yesAnswer) {
                return ([:], .internalError)
            } else if (res.1 != .noAnswer) {
                return ([:], res.1)
            }
            
            variablesUpdate[varToBeSet] = res.0
        default:
            return ([:], .missingBlocksError)
        }
        
        return (variablesUpdate, .noAnswer)
        
    }
    
    // MATH{mOP_ID, val_type, VAR or NUM or MATH, val_type, VAR or NUM or MATH}
    func evaluateMath(variables : Variables, code: Code, startTime: TimeInterval) -> (Int, ErrorCode) {
        
        if(checkTimeout(startTime: startTime) == .timeoutError) {
            return (0, .timeoutError)
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
                return (0, .outOfScopeError)
            }
            
            val1 = variables[varToBeReceived]!
        case "NUM":
            val1 = code[2] as! Int
        case "MATH":
            
            var res : (Int, ErrorCode)
            
            res = evaluateMath(variables: variables, code: code[2] as! Code, startTime: startTime)
            
            if(res.1 == .yesAnswer) {
                return (0, .internalError)
            } else if (res.1 != .noAnswer) {
                return (0, res.1)
            }
            
            val1 = res.0
        default:
            return (0, .missingBlocksError)
        }
        
        switch valType2 {
        case "VAR":
            let varToBeReceived : String = code[4] as! String
            
            if(variables[varToBeReceived] == nil) {
                return (0, .outOfScopeError)
            }
            
            val2 = variables[varToBeReceived]!
        case "NUM":
            val2 = code[4] as! Int
        case "MATH":
            var res : (Int, ErrorCode)
            res = evaluateMath(variables: variables, code: code[4] as! Code, startTime: startTime)
            
            if(res.1 == .yesAnswer) {
                return (0, .internalError)
            } else if (res.1 != .noAnswer) {
                return (0, res.1)
            }
            
            val2 = res.0
        default:
            return (0, .missingBlocksError)
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
                return (0, .internalError)
            }
            
            retVal = val1 / val2
        case "%":
            retVal = val1 % val2
        default:
            return (0, .internalError)
        }
        
        return (retVal, .noAnswer)
    }
    
    // COMP{cOP_ID, val_type, VAR or NUM or MATH, val_type, VAR or NUM or MATH}
    func evaluateComp(variables : Variables, code: Code, startTime: TimeInterval) -> (Bool, ErrorCode) {
        
        if(checkTimeout(startTime: startTime) == .timeoutError) {
            return (false, .timeoutError)
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
                return (false, .outOfScopeError)
            }
            val1 = variables[varToBeReceived]!
        case "NUM":
            val1 = code[2] as! Int
        case "MATH":
            var res : (Int, ErrorCode)
            res = evaluateMath(variables: variables, code: code[2] as! Code, startTime: startTime)
            if(res.1 == .yesAnswer) {
                return (false, .internalError)
            } else if (res.1 != .noAnswer) {
                return (false, res.1)
            }
            val1 = res.0
        default:
            return (false, .missingBlocksError)
        }
        
        switch valType2 {
        case "VAR":
            let varToBeReceived : String = code[4] as! String
            if(variables[varToBeReceived] == nil) {
                return (false, .outOfScopeError)
            }
            val2 = variables[varToBeReceived]!
        case "NUM":
            val2 = code[4] as! Int
        case "MATH":
            var res : (Int, ErrorCode)
            res = evaluateMath(variables: variables, code: code[4] as! Code, startTime: startTime)
            if(res.1 == .yesAnswer) {
                return (false, .internalError)
            } else if (res.1 != .noAnswer) {
                return (false, res.1)
            }
            val2 = res.0
        default:
            return (false, .missingBlocksError)
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
            return (false, .internalError)
        }
        
        return (retVal, .noAnswer)
    }
    
    // IF{COMP, [Operations], comp_exists}
    func evaluateIf(variables : Variables, code: Code, startTime: TimeInterval) -> (Variables, ErrorCode) {
        
        if(checkTimeout(startTime: startTime) == .timeoutError) {
            return ([:], .timeoutError)
        }
        
        let comp_exists : Bool = code[2] as! Bool
        
        if(!comp_exists) {
            return ([:], .missingBlocksError)
        }
        
        var cRes : (Bool, ErrorCode)
        
        cRes = evaluateComp(variables : variables, code: code[0] as! Code, startTime: startTime)
        
        if(cRes.1 == .yesAnswer) {
            return ([:], .internalError)
        } else if (cRes.1 != .noAnswer) {
            return ([:], cRes.1)
        }
        
        let boolean = cRes.0
        
        var variableUpdate = variables
        
        if(boolean) {
            var res : (Variables, ErrorCode)
            res = runCode(variables : variableUpdate, code : code[1] as! Code, startTime: startTime)
            if(res.1 == .yesAnswer) {
                return (res.0, .yesAnswer)
            } else if (res.1 != .noAnswer) {
                return ([:], res.1)
            }
            variableUpdate = res.0
        }
        
        variableUpdate = fixScope(newVars: variableUpdate, oldVars: variables)
        
        return (variableUpdate, .noAnswer)
    }
    
    // FOR{val_type, VAR or NUM or MATH, [Operations]}
    func evaluateFor(variables : Variables, code: Code, startTime: TimeInterval) -> (Variables, ErrorCode) {
        
        if(checkTimeout(startTime: startTime) == .timeoutError) {
            return ([:], .timeoutError)
        }
        
        let valType : String = code[0] as! String
        var val : Int = 0
        
        switch valType {
        case "VAR":
            let varToBeReceived : String = code[1] as! String
            if(variables[varToBeReceived] == nil) {
                return ([:], .outOfScopeError)
            }
            val = variables[varToBeReceived]!
        case "NUM":
            val = code[1] as! Int
        case "MATH":
            var res : (Int, ErrorCode)
            res = evaluateMath(variables: variables, code: code[1] as! Code, startTime: startTime)
            
            if(res.1 == .yesAnswer) {
                return ([:], .internalError)
            } else if (res.1 != .noAnswer) {
                return ([:], res.1)
            }
            
            val = res.0
        default:
            return ([:], .missingBlocksError)
        }
        
        var variableUpdate = variables
        
        if(val < 0) {
            return ([:], .internalError)
        }
        
        for _ in 0..<val {
            var res : (Variables, ErrorCode)
            res = runCode(variables : variableUpdate, code : code[2] as! Code, startTime: startTime)
            if(res.1 == .yesAnswer) {
                return (res.0, .yesAnswer)
            } else if (res.1 != .noAnswer) {
                return ([:], res.1)
            }
            variableUpdate = res.0
        }
        
        variableUpdate = fixScope(newVars: variableUpdate, oldVars: variables)
        
        return (variableUpdate, .noAnswer)
    }
    
    // WHILE{COMP, [Operations], comp_exists}
    func evaluateWhile(variables : Variables, code: Code, startTime: TimeInterval) -> (Variables, ErrorCode) {
        
        if(checkTimeout(startTime: startTime) == .timeoutError) {
            return ([:], .timeoutError)
        }
        
        let comp_exists : Bool = code[2] as! Bool
        
        if(!comp_exists) {
            return ([:], .missingBlocksError)
        }
        
        var variableUpdate = variables
        var track : Bool = true
        
        while(track) {
            var cRes : (Bool, ErrorCode)
            
            cRes = evaluateComp(variables : variableUpdate, code: code[0] as! Code, startTime: startTime)
            
            if(cRes.1 == .yesAnswer) {
                return ([:], .internalError)
            } else if (cRes.1 != .noAnswer) {
                return ([:], cRes.1)
            }
            
            let boolean = cRes.0
            
            if(boolean) {
                var res : (Variables, ErrorCode)
                res = runCode(variables : variableUpdate, code : code[1] as! Code, startTime: startTime)
                
                if(res.1 == .yesAnswer) {
                    return (res.0, .yesAnswer)
                } else if (res.1 != .noAnswer) {
                    return ([:], res.1)
                }
                
                variableUpdate = res.0
            } else {
                track = false
            }
        }
        
        variableUpdate = fixScope(newVars: variableUpdate, oldVars: variables)
        
        return (variableUpdate, .noAnswer)
    }
    
    // SUBMIT{val_type, VAR or NUM or MATH}
    func evaluateSubmit(variables : Variables, code: Code, startTime: TimeInterval) -> (Variables, ErrorCode) {
        
        if(checkTimeout(startTime: startTime) == .timeoutError) {
            return ([:], .timeoutError)
        }
        
        var variablesUpdate = variables
        
        if(variables["SUBMIT"] == nil){
            var codeCopy = code
            codeCopy.insert("SUBMIT", at: 0)
            codeCopy.append(true)
            
            var res : (Variables, ErrorCode)
            
            res = evaluateSet(variables : variables, code : codeCopy, startTime: startTime)
            
            if(res.1 == .yesAnswer) {
                return ([:], .internalError)
            } else if (res.1 != .noAnswer) {
                return ([:], res.1)
            }
            
            variablesUpdate = res.0
        }
        
        return (variablesUpdate, .yesAnswer)
    }
    
}
