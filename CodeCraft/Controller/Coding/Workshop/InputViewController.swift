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

class InputViewController: UIViewController {
    
    @IBOutlet weak var inputTextField: UITextField!
    
    let universalStrings = UniversalStrings()
    
    var delegate : InputViewDelegate!
    var inputs : [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(!inputs.isEmpty) {
            var displayString = ""
            for input in inputs {
                displayString = displayString + String(input) + ","
            }
            displayString = String(displayString.dropLast())
            inputTextField.text = displayString
        }
        
    }
    
    func configure(inputs lInputs: [Int], delegate lDelegate: InputViewDelegate) {
        delegate = lDelegate
        inputs = lInputs
    }
    
    @IBAction func cancelTapped() {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func saveTapped() {
        
        var invalid = false
        var returnIntArray : [Int] = []
        
        var inputString = inputTextField.text!
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
            let alert = UIAlertController(title: universalStrings.invalidInputMessage, message: universalStrings.invalidInputInputsMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            alert.modalPresentationStyle = .overCurrentContext
            self.present(alert, animated: true, completion: nil)
        } else {
            dismiss(animated: false, completion: {self.delegate.inputsUpdated(newInputs: returnIntArray)})
        }
        
    }
    
}
