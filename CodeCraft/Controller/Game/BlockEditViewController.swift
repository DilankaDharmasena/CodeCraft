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
    var data : Code!
    
    var delegate : BlockEditorDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.dataSource = self
        picker.delegate = self
        
        switch blockID.internalType! {
        case .whileBlock, .forBlock, .ifBlock, .submitBlock, .setBlock:
            saveButton.isHidden = true
            editLabel.isHidden = true
            picker.isHidden = true
            textField.isHidden = true
            viewHeight.constant = 100.0
            
        case .compBlock:
            textField.isHidden = true
            editLabel.text = "Comparison"
        case .mathBlock:
            textField.isHidden = true
            editLabel.text = "Operation"
        case .varBlock:
            textField.isHidden = true
            editLabel.text = "Variable"
        case .numBlock:
            picker.isHidden = true
            editLabel.text = "Integer"
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
                let index = ValidInputs().comparisons.index(of: comp)
                picker.selectRow(index!, inComponent: 0, animated: false)
            case .mathBlock:
                let math = data[0] as! String
                let index = ValidInputs().math.index(of: math)
                picker.selectRow(index!, inComponent: 0, animated: false)
            case .varBlock:
                let variable = data[0] as! String
                let index = ValidInputs().variables.index(of: variable)
                picker.selectRow(index!, inComponent: 0, animated: false)
            case .numBlock:
                let num = data[0] as! Int
                textField.text = String(num)
            default:
                // not possible
                break
            }
        }
    }
    
    func configure(id : BlockID, data lData: Code, delegate lDelegate : BlockEditorDelegate) {
        
        blockID = id
        delegate = lDelegate
        data = lData
        
    }

    @IBAction func cancelTapped(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func saveTapped(_ sender: UIButton) {
        
        switch blockID.internalType! {
        case .compBlock:
            let index = picker.selectedRow(inComponent: 0)
            let input = ValidInputs().comparisons[index]
            dismiss(animated: false, completion: {self.delegate.doneEditing(id: self.blockID, data: [input] as Code, action: .modify)})
        case .mathBlock:
            let index = picker.selectedRow(inComponent: 0)
            let input = ValidInputs().math[index]
            dismiss(animated: false, completion: {self.delegate.doneEditing(id: self.blockID, data: [input] as Code, action: .modify)})
        case .varBlock:
            let index = picker.selectedRow(inComponent: 0)
            let input = ValidInputs().variables[index]
            dismiss(animated: false, completion: {self.delegate.doneEditing(id: self.blockID, data: [input] as Code, action: .modify)})
        case .numBlock:
            var invalid = true
            
            let input = textField.text!
            let convertedInput = Int(input)
            if let num = convertedInput {
                if(abs(num) <= ValidInputs().num) {
                    invalid = false
                    dismiss(animated: false, completion: {self.delegate.doneEditing(id: self.blockID, data: [num] as Code, action: .modify)})
                }
            }
            
            if(invalid) {
                let alert = UIAlertController(title: "Invalid Input", message: "Enter a valid number", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                alert.modalPresentationStyle = .overCurrentContext
                self.present(alert, animated: true, completion: nil)
            }
            
        default:
            // not possible
            break
        }
        
    }
    
    @IBAction func deleteTapped(_ sender: UIButton) {
        dismiss(animated: false, completion: {self.delegate.doneEditing(id: self.blockID, data: self.data, action: .delete)})
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch blockID.internalType! {
        case .compBlock:
            return ValidInputs().comparisons.count
        case .mathBlock:
            return ValidInputs().math.count
        case .varBlock:
            return ValidInputs().variables.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = (view as? UILabel) ?? UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont(name: "Futura", size: 17)
        
        switch blockID.internalType! {
        case .compBlock:
            label.text = ValidInputs().comparisons[row]
        case .mathBlock:
            label.text = ValidInputs().math[row]
        case .varBlock:
            label.text = ValidInputs().variables[row]
        default:
            label.text = ""
        }
        
        return label
        
    }
    
    
}
