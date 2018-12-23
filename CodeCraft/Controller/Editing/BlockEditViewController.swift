//
//  BlockEditViewController.swift
//  CodeCraft
//
//  Created by Dilanka Dharmasena on 12/8/18.
//  Copyright © 2018 dilankadharmasena. All rights reserved.
//

import UIKit

protocol BlockEditorDelegate {
    func doneEditing(id: BlockID, data: Code, action: EditAction)
}

class BlockEditViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var editLabel: UILabel!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    
    var blockID : BlockID!
    var data : Code = []
    var numVars : Int = 0
    
    var delegate : BlockEditorDelegate!
    
    let validInputs = ValidInputs()
    let universalStrings = UniversalStrings()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.dataSource = self
        picker.delegate = self
        
        switch blockID.internalType! {
        case .whileBlock, .forBlock, .ifBlock, .submitBlock, .setBlock:
            editLabel.isHidden = true
            picker.isHidden = true
            textField.isHidden = true
            viewHeight.constant = 100.0
            
        case .compBlock:
            textField.isHidden = true
            editLabel.text = universalStrings.compLabel
        case .mathBlock:
            textField.isHidden = true
            editLabel.text = universalStrings.mathLabel
        case .varBlock:
            textField.isHidden = true
            editLabel.text = universalStrings.varLabel
        case .numBlock:
            picker.isHidden = true
            editLabel.text = universalStrings.numLabel
            viewHeight.constant = 200.0
        default:
            // not possible
            break
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(!data.isEmpty) {
            switch blockID.internalType! {
            case .compBlock:
                let comp = data[0] as! String
                let index = validInputs.comparisons.index(of: comp)
                picker.selectRow(index!, inComponent: 0, animated: false)
            case .mathBlock:
                let math = data[0] as! String
                let index = validInputs.math.index(of: math)
                picker.selectRow(index!, inComponent: 0, animated: false)
            case .varBlock:
                let variable = data[0] as! String
                var index : Int
                if(variable.count == 1) {
                    index = validInputs.variables.index(of: variable)! + numVars
                } else {
                    let inputIndex : Int = Int(variable.components(separatedBy: "_")[1])!
                    if(inputIndex > numVars) {
                        index = 0
                    } else {
                        index = inputIndex - 1
                    }
                }
                picker.selectRow(index, inComponent: 0, animated: false)
            case .numBlock:
                let num = data[0] as! Int
                textField.text = String(num)
            default:
                // not possible
                break
            }
        } else {
            switch blockID.internalType! {
            case .compBlock, .mathBlock:
                let index = picker.numberOfRows(inComponent: 0) / 2
                picker.selectRow(index, inComponent: 0, animated: false)
            case .varBlock:
                picker.selectRow(numVars, inComponent: 0, animated: false)
            default:
                break
            }
        }
    }
    
    func configure(id : BlockID, data lData: Code, numVariables: Int, delegate lDelegate : BlockEditorDelegate) {
        
        blockID = id
        delegate = lDelegate
        data = lData
        numVars = numVariables
        
    }

    @IBAction func cancelTapped(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func saveTapped(_ sender: UIButton) {
        
        switch blockID.internalType! {
        case .compBlock:
            let index = picker.selectedRow(inComponent: 0)
            let input = validInputs.comparisons[index]
            dismiss(animated: false, completion: {self.delegate.doneEditing(id: self.blockID, data: [input] as Code, action: .modify)})
        case .mathBlock:
            let index = picker.selectedRow(inComponent: 0)
            let input = validInputs.math[index]
            dismiss(animated: false, completion: {self.delegate.doneEditing(id: self.blockID, data: [input] as Code, action: .modify)})
        case .varBlock:
            let index = picker.selectedRow(inComponent: 0)
            var input : String
            if(index < numVars) {
                input = String(format: "INPUT_%d", index + 1)
            } else {
                input = validInputs.variables[index - numVars]
            }
            dismiss(animated: false, completion: {self.delegate.doneEditing(id: self.blockID, data: [input] as Code, action: .modify)})
        case .numBlock:
            var invalid = true
            
            let input = textField.text!
            let convertedInput = Int(input)
            if let num = convertedInput {
                if(abs(num) <= validInputs.num) {
                    invalid = false
                    dismiss(animated: false, completion: {self.delegate.doneEditing(id: self.blockID, data: [num] as Code, action: .modify)})
                }
            }
            
            if(invalid) {
                launchAlertDialog(title: universalStrings.invalidInputMessage, message: universalStrings.invalidInputNumberMessage)
            }
            
        default:
            dismiss(animated: false, completion: nil)
        }
        
    }
    
    @IBAction func deleteTapped(_ sender: UIButton) {
        dismiss(animated: false, completion: {self.delegate.doneEditing(id: self.blockID, data: self.data, action: .delete)})
    }
    
    // Picker
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch blockID.internalType! {
        case .compBlock:
            return validInputs.comparisons.count
        case .mathBlock:
            return validInputs.math.count
        case .varBlock:
            return validInputs.variables.count + numVars
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = (view as? UILabel) ?? UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont(name: "Futura", size: 16)
        
        switch blockID.internalType! {
        case .compBlock:
            label.text = validInputs.comparisons[row]
        case .mathBlock:
            label.text = validInputs.math[row]
        case .varBlock:
            if(row < numVars) {
                label.text = String(format: "INPUT_%d", row + 1)
            } else {
                label.text = validInputs.variables[row - numVars]
            }
        default:
            label.text = ""
        }
        
        return label
        
    }
    
    
}
