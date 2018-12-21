//
//  BlockCreateViewController.swift
//  CodeCraft
//
//  Created by Dilanka Dharmasena on 12/8/18.
//  Copyright © 2018 dilankadharmasena. All rights reserved.
//

import UIKit

protocol BlockCreatorDelegate {
    func doneCreating(id: BlockID, data: Code, action: EditAction)
}

class BlockCreateViewController: UIViewController, BlockEditorDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var delegate : BlockCreatorDelegate!
    var currID : BlockID!
    var numVars : Int = 0
    
    let validInputs = ValidInputs()

    @IBOutlet weak var picker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.dataSource = self
        picker.delegate = self
        
    }
    
    // Local
    
    func configure(currID lCurrID: BlockID, numVariables: Int, delegate lDelegate : BlockCreatorDelegate) {
        currID = lCurrID
        delegate = lDelegate
        numVars = numVariables
    }
    
    // Buttons
    
    @IBAction func cancelTapped(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func addTapped(_ sender: UIButton) {
        let index = picker.selectedRow(inComponent: 0)
        let input = validInputs.blocks(id: currID).0[index]
        
        switch input {
        case .compBlock, .mathBlock, .varBlock, .numBlock:
            
            let newID = currID.changeType(type: input)
            
            let viewController = storyboard?.instantiateViewController(withIdentifier: "blockEditScene") as! BlockEditViewController
            viewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            viewController.configure(id: newID, data: [], numVariables: numVars, delegate: self)
            present(viewController, animated: false, completion: nil)
            
            
        default:
            
            var internalLocation : Int = 0
            if(currID.internalType != .blankBlock) {
                internalLocation = currID.internalLocation + 1
            }
            
            let newID = BlockID(parentType: currID.parentType, parentLocation: currID.parentLocation, parentRelationship: currID.parentRelationship, internalType: input, internalLocation: internalLocation)
            
            dismiss(animated: false, completion: {self.delegate.doneCreating(id: newID, data: [], action: .create)})
        }
        
    }
    
    // EditorDelegate
    
    func doneEditing(id: BlockID, data: Code, action: EditAction) {
        if(action == .modify) {
            dismiss(animated: false, completion: {self.delegate.doneCreating(id: id, data: data, action: .create)})
        }
    }
    
    // Picker
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let vals = validInputs.blocks(id: currID)
        return vals.1.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = (view as? UILabel) ?? UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont(name: "Futura", size: 17)
        
        let vals = validInputs.blocks(id: currID)
        label.text = vals.1[row]
        
        return label
        
    }
    
}
