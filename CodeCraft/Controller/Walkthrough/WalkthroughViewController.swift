//
//  WalkthroughViewController.swift
//  CodeCraft
//
//  Created by Dilanka Dharmasena on 12/24/18.
//  Copyright © 2018 dilankadharmasena. All rights reserved.
//

import UIKit

extension DispatchQueue {
    
    static func backgroundTest(controller: WalkthroughViewController, inputs: [Int], code: Code) {
        DispatchQueue.global(qos: .background).async {
            
            let res = Test().runSim(input: inputs, code: code, delegate: controller)
            
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                
                if(res.error == .yesAnswer) {
                    controller.launchAlertDialog(title: UniversalStrings().successfulRunMessage, message: String(format: UniversalStrings().outputMessageFormat, res.result))
                } else {
                    controller.launchAlertDialog(title: UniversalStrings().defaultErrorMessage, message: UniversalStrings().errorMessages[res.error]!)
                }
                
                controller.runFinished = true
                
            })
        }
    }
    
}

protocol WalkthroughDelegate {
    func stepThroughCode()
}

class WalkthroughViewController: UIViewController, CompilerDelegate {
    
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var addButton: UIButton!
    
    var codeTranslator : CodeTranslator!
    
    var code : Code!
    var inputs : [Int]!
    
    var runHistory : [(Variables, BlockID)] = [([:], BlockID.start)]
    var historyIndex : Int = 0
    
    var runFinished : Bool = false
    var runStarted : Bool = false
    
    var timer : Timer?
    
    var delegate : WalkthroughDelegate!
    
    // Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        codeTranslator = CodeTranslator()
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        leftButton.addGestureRecognizer(longPress)
        
        addButton.setImage(UIImage(named: "pauseButton.png"), for: .selected)
        
        reloadView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.backgroundTest(controller: self, inputs: inputs, code: code)
    }
    
    // Setup
    
    func configure(code lCode: Code, inputs lInputs: [Int]) {
        code = lCode
        inputs = lInputs
    }
    
    // Actions
    
    @IBAction func exitButtonTap(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func leftArrowButtonTap(_ sender: UIButton) {
        if(!runStarted) {
            return
        }
        
        stopTimer()
        
        if(historyIndex > 0) {
            historyIndex -= 1
            reloadView()
        }
    }
    
    @IBAction func rightArrowButtonTap(_ sender: UIButton) {
        
        if(!runStarted) {
            return
        }
        
        stopTimer()
        
        if(historyIndex < (runHistory.count - 1)) {
            historyIndex += 1
            reloadView()
        } else if(!runFinished) {
            delegate.stepThroughCode()
        }
    }
    
    @IBAction func addButtonTap(_ sender: UIButton) {
        
        if(!runStarted) {
            return
        }
        
        if(timer == nil) {
            
            if(runFinished && (historyIndex >= runHistory.count - 1)) {
                historyIndex = 0
            }
            
            timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { _ in
                if(self.runFinished && (self.historyIndex >= self.runHistory.count - 1)) {
                    self.stopTimer()
                } else {
                    if(self.historyIndex < (self.runHistory.count - 1)) {
                        self.historyIndex += 1
                        self.reloadView()
                    } else if(!self.runFinished) {
                        self.delegate.stepThroughCode()
                    }
                    
                    self.addButton.isSelected = true
                    
                }
            })
        } else {
            stopTimer()
        }
        
    }
    
    // Gesture Targets
    
    @objc func handleLongPress() {
        
        if(!runStarted) {
            return
        }
        
        stopTimer()
        
        historyIndex = 0
        reloadView()
    }
    
    // Helpers
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        addButton.isSelected = false
    }
    
    func formatVariables(variables: Variables) -> String {
        var returnString : String = ""
        
        if(variables.isEmpty) {
            returnString = "No variables in scope\n"
        }
        
        for (name, val) in variables {
            let localString = String(format: "%@ : %d\n", name, val)
            returnString += localString
        }
        
        return returnString
    }
    
    func reloadView() {
        
        var newView : UIStackView
        
        if(runStarted) {
            textView.text = formatVariables(variables: runHistory[historyIndex].0)
            newView = codeTranslator.mainView(code: code, highlight: runHistory[historyIndex].1)
        } else {
            newView = codeTranslator.mainView(code: code, highlight: BlockID.start)
        }
        
        for sub in scrollView.subviews {
            sub.removeFromSuperview()
        }
        
        let contentSize = CGSize(width: newView.frame.size.width, height: newView.frame.size.height + BlockDimensions().Buffer)
        
        scrollView.contentSize = contentSize
        scrollView.addSubview(newView)
        
    }
    
    // Compiler Delegate
    
    func stepThroughCode(variables: Variables, blockID: BlockID, num: Int, bool: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
            
            if(self.runStarted) {
                self.runHistory.append((variables, blockID))
                self.historyIndex += 1
            } else {
                self.runHistory = [(variables, blockID)]
                self.runStarted = true
            }
            
            self.reloadView()
        })
    }
    
    // Status bar customization
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

}
