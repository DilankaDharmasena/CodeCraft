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

class GameViewController: UIViewController, CodeEditorDelegate, BlockEditorDelegate, BlockCreatorDelegate {
    
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var runSubmitButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var gameID : Int = 0
    var gamePrompt : String!
    var delegate : GameViewDelegate!
    var codeModel : CodeModel!
    var codeEditor : CodeEditor!
    var codeTranslator : CodeTranslator!
    
    let levelModelUtils = LevelModelUtils.shared
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let level : LevelMO = levelModelUtils.level(id: gameID)[0]
        gamePrompt = level.prompt
        
        levelModelUtils.startedLevel(id: gameID)
        
        codeModel = CodeModel(code: [], block: BlockID.start) // Load saved answer
        codeEditor = CodeEditor(delegate: self)
        codeTranslator = CodeTranslator(editor: codeEditor)
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        doubleTap.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTap)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        leftButton.addGestureRecognizer(longPress)
        
        reloadView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        taskButtonTap()
    }
    
    func configure(gameID id : Int, delegate lDelegate: GameViewDelegate) {
        gameID = id
        delegate = lDelegate
    }
    
    @IBAction func exitButtonTap(_ sender: UIButton) {
        dismiss(animated: false, completion: {self.delegate.reloadScreen()})
    }
    
    @IBAction func taskButtonTap() {
        let taskController = storyboard?.instantiateViewController(withIdentifier: "taskScene") as! TaskViewController
        taskController.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        taskController.configure(taskDescription: gamePrompt)
        present(taskController, animated: true, completion: nil)
    }
    
    @IBAction func runSubmitButtonTap(_ sender: UIButton) {
        
        let tester = Test()
        let res = tester.runTest(gameID: gameID, code: codeModel.currentCode)
        
        if(res == .yesAnswer) {
            
            levelModelUtils.finishedLevel(id: gameID)
            
            let alert = UIAlertController(title: "You Got It!", message: "Try another one", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            alert.modalPresentationStyle = .overCurrentContext
            self.present(alert, animated: true, completion: nil)
        } else {
            
            let message = UniversalStrings().errorMessages[res]
            
            let alert = UIAlertController(title: "So Close", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            alert.modalPresentationStyle = .overCurrentContext
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func leftArrowButtonTap(_ sender: UIButton) {
        codeModel.undo()
        reloadView()
    }
    
    @IBAction func rightArrowButtonTap(_ sender: UIButton) {
        codeModel.redo()
        reloadView()
    }
    
    @IBAction func addButtonTap(_ sender: UIButton) {
        
        let currID = codeModel.currentBlock
        
        let viewController = storyboard?.instantiateViewController(withIdentifier: "blockCreateScene") as! BlockCreateViewController
        viewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        viewController.configure(currID: currID, delegate: self)
        present(viewController, animated: false, completion: nil)
    }
    
    @objc func handleDoubleTap() {
        codeModel.currentBlock = BlockID.start
        reloadView()
    }
    
    @objc func handleLongPress() {
        codeModel.clear()
        reloadView()
    }
    
    func reloadView() {
        
        for sub in scrollView.subviews{
            sub.removeFromSuperview()
        }
        
        let newView = codeTranslator.mainView(code: codeModel.currentCode, highlight: codeModel.currentBlock)
        
        scrollView.contentSize = newView.frame.size
        scrollView.addSubview(newView)
        
    }
    
    func startEditing(id: BlockID, data: Code) {
        if(id.internalType == .blankBlock) {
            let viewController = storyboard?.instantiateViewController(withIdentifier: "blockCreateScene") as! BlockCreateViewController
            viewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            viewController.configure(currID: id, delegate: self)
            present(viewController, animated: false, completion: nil)
        } else {
            let viewController = storyboard?.instantiateViewController(withIdentifier: "blockEditScene") as! BlockEditViewController
            viewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            viewController.configure(id: id, data: data, delegate: self)
            present(viewController, animated: false, completion: nil)
        }
    }
    
    func setSelectedBlock(id: BlockID) {
        codeModel.currentBlock = id
        reloadView()
    }
    
    func doneEditing(id: BlockID, data: Code, action: EditAction) {
        let newCode = codeEditor.editCode(code: codeModel.currentCode, block: id, data: data, action: action)
        codeModel.currentCode = newCode
        if(action == .delete) {
            codeModel.currentBlock = BlockID.start
        }
        reloadView()
    }
    
    func doneCreating(id: BlockID, data: Code, action: EditAction) {
        let newCode = codeEditor.editCode(code: codeModel.currentCode, block: id, data: data, action: action)
        codeModel.currentCode = newCode
        if(id.parentType == .operationBlock) {
            codeModel.currentBlock = id
        }
        reloadView()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

}
