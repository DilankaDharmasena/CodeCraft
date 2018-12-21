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
}

class GameViewController: CodingViewController {
    
    var gameID : Int = 0
    var gamePrompt : String = ""
    var delegate : GameViewDelegate!
    
    let levelModelUtils = LevelModelUtils()
    
    override func viewDidAppear(_ animated: Bool) {
        taskButtonTap()
    }
    
    func configure(gameID id : Int, delegate lDelegate: GameViewDelegate) {
        gameID = id
        delegate = lDelegate
        
        let level : LevelMO = levelModelUtils.level(id: gameID)[0]
        gamePrompt = level.prompt!
        numVars = level.formattedInputs[0].count
        
        codeModel = CodeModel(code: [], block: BlockID.start) // Load saved answer
        
        levelModelUtils.startedLevel(id: gameID)
        
    }
    
    // Overridden from superclass
    
    override func exitButtonTap(_ sender: UIButton) {
        dismiss(animated: false, completion: {self.delegate.reloadScreen()})
    }
    
    override func taskButtonTap() {
        let taskController = storyboard?.instantiateViewController(withIdentifier: "taskScene") as! TaskViewController
        taskController.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        taskController.configure(taskDescription: gamePrompt)
        present(taskController, animated: true, completion: nil)
    }
    
    override func runSubmitButtonTap(_ sender: UIButton) {
        
        let res = tester.runTest(gameID: gameID, code: codeModel.currentCode)
        
        if(res == .yesAnswer) {
            levelModelUtils.finishedLevel(id: gameID)
            launchAlert(title: universalStrings.yesMessage[0], message: universalStrings.yesMessage[1])
        } else {
            launchAlert(title: universalStrings.noMessage, message: universalStrings.errorMessages[res]!)
        }
        
    }

}
