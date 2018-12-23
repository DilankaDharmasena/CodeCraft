//
//  WorkshopViewController.swift
//  CodeCraft
//
//  Created by Dilanka Dharmasena on 12/20/18.
//  Copyright © 2018 dilankadharmasena. All rights reserved.
//

import UIKit

protocol WorkshopDelegate {
    func transferToLevel(code: Code)
}

class WorkshopViewController: CodingViewController, InputViewDelegate {
    
    var inputs : [Int] = []
    var delegate : WorkshopDelegate!
    
    override func viewDidAppear(_ animated: Bool) {
        launchAlertDialog(title: universalStrings.reminderTitle, message: universalStrings.remindInputsMessage)
    }
    
    func configure(inputs lInputs : [Int], code: Code, delegate lDelegate: WorkshopDelegate) {
        delegate = lDelegate
        
        inputs = lInputs
        numVars = inputs.count
        
        codeModel = CodeModel(code: code, block: BlockID.start)
    }
    
    // Overridden from superclass
    
    override func handleLongRunPress() {
        dismiss(animated: false, completion: {
            self.delegate.transferToLevel(code: self.codeModel.currentCode)
        })
    }
    
    override func exitButtonTap(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }
    
    override func taskButtonTap() {
        let inputsController = storyboard?.instantiateViewController(withIdentifier: "addInputsScene") as! InputViewController
        inputsController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        inputsController.configure(inputs: inputs, delegate: self)
        present(inputsController, animated: false, completion: nil)
    }
    
    override func runSubmitButtonTap(_ sender: UIButton) {
        
        let res = tester.runSim(input: inputs, code: codeModel.currentCode)
        
        if(res.error == .yesAnswer) {
            launchAlertDialog(title: universalStrings.successfulRunMessage, message: String(format: universalStrings.outputMessageFormat, res.result))
        } else {
            launchAlertDialog(title: universalStrings.defaultErrorMessage, message: universalStrings.errorMessages[res.error]!)
        }
        
    }
    
    // Input View Delegate
    
    func inputsUpdated(newInputs: [Int]) {
        inputs = newInputs
        numVars = inputs.count
    }
    
}
