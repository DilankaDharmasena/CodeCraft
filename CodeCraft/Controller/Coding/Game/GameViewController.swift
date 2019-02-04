//
//  GameViewController.swift
//  CodeCraft
//
//  Created by Dilanka Dharmasena on 11/23/18.
//  Copyright © 2018 dilankadharmasena. All rights reserved.
//

import UIKit

protocol GameViewDelegate {
    func reloadScreen()
    func transferToWorkshop(code: Code, input: [Int])
}

class GameViewController: CodingViewController {
    
    @IBOutlet weak var levelLabel: UILabel!
    
    var gameID : Int = 0
    var gamePrompt : String = ""
    var gameStatus : Int = 0
    var sampleInput : [Int] = []
    var sampleOutput : Int = 0
    
    var delegate : GameViewDelegate!
    
    let levelModelUtils = LevelModelUtils()
    
    var taskController : TaskViewController!
    
    override func viewWillAppear(_ animated: Bool) {
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .spellOut
        
        levelLabel.text = numberFormatter.string(from: NSNumber(value: gameID))
        
        taskController = storyboard?.instantiateViewController(withIdentifier: "taskScene") as? TaskViewController
        taskController.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        taskController.configure(taskDescription: gamePrompt, input: sampleInput, output: sampleOutput)
        
        /*
        if(gameStatus == 0) {
            taskButtonTap()
        }
         */
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let currentTime = NSDate().timeIntervalSince1970
        
        let lastTime : TimeInterval? = UserDefaults.standard.object(forKey: "reminderOpenedGame") as? TimeInterval
        
        if let lastTimeUnwrapped = lastTime {
            if(lastTimeUnwrapped + 600.0 < currentTime) {
                launchAlertDialog(title: universalStrings.quickTipsTitle, message: universalStrings.quickTipsGame)
            }
        } else {
            launchAlertDialog(title: universalStrings.quickTipsTitle, message: universalStrings.quickTipsGame)
        }
        
        UserDefaults.standard.set(currentTime, forKey: "reminderOpenedGame")
    }
    
    func configure(gameID id : Int, code: Code, delegate lDelegate: GameViewDelegate) {
        gameID = id
        delegate = lDelegate
        
        let level : LevelMO = levelModelUtils.level(id: gameID)
        gamePrompt = level.prompt!
        gameStatus = Int(level.status)
        sampleInput = level.formattedInputs[0]
        sampleOutput = level.formattedOutputs[0]
        numVars = sampleInput.count
        
        let starterCode : Code = code.isEmpty ? level.solution as! Code : code
        
        codeModel = CodeModel(code: starterCode, block: BlockID.start)
        
        levelModelUtils.startedLevel(id: gameID)
        
    }
    
    // Overridden from superclass
    
    override func handleLongRunPress() {
        
        let viewController = storyboard?.instantiateViewController(withIdentifier: "Walkthrough_Scene") as! WalkthroughViewController
        viewController.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        viewController.configure(code: codeModel.currentCode, inputs: sampleInput)
        present(viewController, animated: false, completion: nil)
        
    }
    
    override func handleLongExitPress() {
        dismiss(animated: false, completion: {
            self.delegate.reloadScreen()
            self.delegate.transferToWorkshop(code: self.codeModel.currentCode, input: self.sampleInput)
        })
    }
    
    override func exitButtonTap(_ sender: UIButton) {
        dismiss(animated: false, completion: {self.delegate.reloadScreen()})
    }
    
    override func taskButtonTap() {
        present(taskController, animated: true, completion: nil)
    }
    
    override func runSubmitButtonTap(_ sender: UIButton) {
        
        levelModelUtils.updatedSolution(id: gameID, solution: codeModel.currentCode)
        
        let res = tester.runTest(gameID: gameID, code: codeModel.currentCode)
        
        if(res == .yesAnswer) {
            levelModelUtils.finishedLevel(id: gameID)
            launchAlertDialog(title: universalStrings.yesMessage[0], message: universalStrings.yesMessage[1])
        } else {
            launchAlertDialog(title: universalStrings.noMessage, message: universalStrings.errorMessages[res]!)
        }
        
    }

}
