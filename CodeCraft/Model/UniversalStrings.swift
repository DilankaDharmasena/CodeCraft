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
    
    let quickTipsTitle : String = "Quick Tips"
    
    let quickTipsGame : String = "1. When you want to add a block underneath an original one, double tap the original block to select it. Double tap anywhere in the whitespace to clear your selection.\n2. Hold the exit button to transfer your code to the workshop.\n3. Hold the run button to walk through your code line by line."
    
    let quickTipsWorkshop : String = "1. Don't forget to set your inputs if you're using them.\n2. When you want to add a block underneath an original one, double tap the original block to select it. Double tap anywhere in the whitespace to clear your selection.\n3. Hold the exit button to transfer your code to any of the challenges.\n4. Hold the run button to walk through your code line by line."
    
}
