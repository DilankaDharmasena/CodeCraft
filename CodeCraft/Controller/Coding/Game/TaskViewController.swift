//
//  TaskViewController.swift
//  CodeCraft
//
//  Created by Dilanka Dharmasena on 12/9/18.
//  Copyright © 2018 dilankadharmasena. All rights reserved.
//

import UIKit

class TaskViewController: UIViewController {
    
    var gamePrompt : String = ""
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        textView.text = gamePrompt
    }
    
    func configure(taskDescription: String) {
        gamePrompt = taskDescription
    }

    @IBAction func continueButtonTap(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
