//
//  UniversalStrings.swift
//  CodeCraft
//
//  Created by Dilanka Dharmasena on 12/18/18.
//  Copyright © 2018 dilankadharmasena. All rights reserved.
//

import Foundation

class UniversalStrings {
    
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
        .numBlock : "Number",
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
