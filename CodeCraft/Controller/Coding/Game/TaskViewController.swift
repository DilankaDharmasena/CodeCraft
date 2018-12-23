//
//  TaskViewController.swift
//  CodeCraft
//
//  Created by Dilanka Dharmasena on 12/9/18.
//  Copyright © 2018 dilankadharmasena. All rights reserved.
//

import UIKit

class TaskViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var exampleTaskButton: UIButton!
    
    var gamePrompt : String = ""
    var gameExample : String = ""
    
    var exampleStatus = true
    
    let buttonLabel_1 : String = "Example"
    let buttonLabel_2 : String = "Show Task"
    
    override func viewDidLoad() {
        textView.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        textView.text = gamePrompt
    }
    
    func configure(taskDescription: String, input: [Int], output: Int) {
        gamePrompt = taskDescription
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .spellOut
        
        var inputString : String = ""
        var outputString : String = ""
        
        for (index, val) in input.enumerated() {
            let indexFormatted : NSNumber = NSNumber(value: index + 1)
            let local = String(format: "Input %@: %d\n", numberFormatter.string(from: indexFormatted)!, val)
            inputString += local
        }
        
        outputString += String(format: "\nAnswer: %d", output)
        
        gameExample = inputString + outputString
        
    }
    
    func flipCard() {
        
        exampleStatus = !exampleStatus
        
        if(exampleStatus) {
            exampleTaskButton.setTitle(buttonLabel_1, for: .normal)
            textView.text = gamePrompt
        } else {
            exampleTaskButton.setTitle(buttonLabel_2, for: .normal)
            textView.text = gameExample
        }
        
        UIView.transition(with: textView, duration: 0.3, options: .transitionFlipFromLeft, animations: nil, completion: nil)
        
    }

    @IBAction func continueButtonTap(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func exampleTaskButtonTap() {
        flipCard()
    }
    
}
