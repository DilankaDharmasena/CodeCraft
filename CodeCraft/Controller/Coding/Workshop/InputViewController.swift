//
//  InputViewController.swift
//  CodeCraft
//
//  Created by Dilanka Dharmasena on 12/20/18.
//  Copyright © 2018 dilankadharmasena. All rights reserved.
//

import UIKit

protocol InputViewDelegate {
    func inputsUpdated(newInputs: [Int])
}

class InputViewController: TypingViewController {
    
    let universalStrings = UniversalStrings()
    
    var delegate : InputViewDelegate!
    var inputs : [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
        if(!inputs.isEmpty) {
            var displayString = ""
            for input in inputs {
                displayString = displayString + String(input) + ","
            }
            displayString = String(displayString.dropLast())
            textField.text = displayString
        }
        
    }
    
    func configure(inputs lInputs: [Int], delegate lDelegate: InputViewDelegate) {
        delegate = lDelegate
        inputs = lInputs
    }
    
    //
    // cancelTapped defined in TypingViewController
    //
    
    @IBAction func saveTapped() {
        
        var invalid = false
        var returnIntArray : [Int] = []
        
        var inputString = textField.text!
        inputString = inputString.replacingOccurrences(of: " ", with: "")
        
        if(!inputString.isEmpty) {
            let inputStringArray = inputString.components(separatedBy: ",")
            for input in inputStringArray {
                let convertedInput = Int(input)
                if let num = convertedInput {
                    returnIntArray.append(num)
                } else {
                    invalid = true
                    break
                }
            }
        }
        
        if(invalid) {
            launchAlertDialog(title: universalStrings.invalidInputMessage, message: universalStrings.invalidInputInputsMessage)
        } else {
            dismiss(animated: false, completion: {self.delegate.inputsUpdated(newInputs: returnIntArray)})
        }
        
    }
    
}
