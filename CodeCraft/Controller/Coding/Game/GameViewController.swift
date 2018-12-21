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
    }
    
    // Overriden from superclass
    
    override func setup() {
        let level : LevelMO = levelModelUtils.level(id: gameID)[0]
        gamePrompt = level.prompt!
        numVars = level.formattedInputs[0].count
        
        codeModel = CodeModel(code: [], block: BlockID.start) // Load saved answer
        
        levelModelUtils.startedLevel(id: gameID)
    }
    
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
        
        let tester = Test()
        let universalStrings = UniversalStrings()
        
        let res = tester.runTest(gameID: gameID, code: codeModel.currentCode)
        
        if(res == .yesAnswer) {
            
            levelModelUtils.finishedLevel(id: gameID)
            
            let alert = UIAlertController(title: universalStrings.yesMessage, message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            alert.modalPresentationStyle = .overCurrentContext
            self.present(alert, animated: true, completion: nil)
            
        } else {
            
            let alert = UIAlertController(title: universalStrings.noMessage, message: universalStrings.errorMessages[res], preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            alert.modalPresentationStyle = .overCurrentContext
            self.present(alert, animated: true, completion: nil)
        }
        
    }

}
