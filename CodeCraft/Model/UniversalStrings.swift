//
//  UniversalStrings.swift
//  CodeCraft
//
//  Created by Dilanka Dharmasena on 12/18/18.
//  Copyright © 2018 dilankadharmasena. All rights reserved.
//

import Foundation

class UniversalStrings {
    
    let compLabel : String = "Comparison"
    let mathLabel : String = "Operation"
    let varLabel : String = "Variable"
    let numLabel : String = "Integer"
    
    let yesMessage : [String] = ["You Got It!", "Try another one"]
    let noMessage : String = "So Close"
    
    let invalidInputMessage : String = "Invalid Input"
    let invalidInputNumberMessage : String = "Enter a valid integer"
    let invalidInputInputsMessage : String = "Enter valid integers separated by commas"
    
    let defaultErrorMessage : String = "Something Went Wrong"
    
    let successfulRunMessage : String = "Success!"
    let outputMessageFormat : String = "Your code and inputs resulted in an output of: %d"
    
    let reminderTitle : String = "Reminder"
    
    let remindInputsMessage : String = "Don't forget to set your inputs if you're using them"
    
    let blockNames : [InternalType:String] =
    [
        .whileBlock : "While Loop",
        .forBlock : "For Loop",
        .ifBlock : "If Statement",
        .submitBlock : "Submit Answer",
        .setBlock : "Set Variable",
        .compBlock : "Comparison",
        .mathBlock : "Math Operation",
        .blankBlock : "Empty",
        .numBlock : "Integer",
        .varBlock : "Variable"
    ]
    
    let errorMessages : [ErrorCode:String] =
    [
        .noAnswer : "No answer was submitted",
        .yesAnswer : "An answer was submitted",
        .internalError : "An internal error occurred",
        .timeoutError : "The code took too long to run",
        .incorrectAnswer : "The submitted answer was incorrect",
        .missingBlocksError : "At least one required block is missing",
        .outOfScopeError : "There was an attempt to access an out of scope variable"
    ]
    
}
