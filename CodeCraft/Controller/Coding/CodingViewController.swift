//
//  CodingViewController.swift
//  CodeCraft
//
//  Created by Dilanka Dharmasena on 12/20/18.
//  Copyright © 2018 dilankadharmasena. All rights reserved.
//

import UIKit

class CodingViewController : UIViewController, BlockDelegate, BlockEditorDelegate, BlockCreatorDelegate {
    
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var runSubmitButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    let tester = Test()
    let universalStrings = UniversalStrings()
    
    var codeModel : CodeModel!
    var codeTranslator : CodeTranslator!
    var codeEditor : CodeEditor = CodeEditor()
    
    var numVars : Int = 0
    
    // Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        codeTranslator = CodeTranslator(editor: self)
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        doubleTap.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTap)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        leftButton.addGestureRecognizer(longPress)
        
        let longRunPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongRunPress))
        runSubmitButton.addGestureRecognizer(longRunPress)
        
        reloadView()
        
    }
    
    // Actions
    
    @IBAction func exitButtonTap(_ sender: UIButton) {
        fatalError()
    }
    
    @IBAction func taskButtonTap() {
        fatalError()
    }
    
    @IBAction func runSubmitButtonTap(_ sender: UIButton) {
        fatalError()
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
        launchCreate(id: codeModel.currentBlock)
    }
    
    // Gesture Targets
    
    @objc func handleDoubleTap() {
        blockToBeSelected(id: BlockID.start)
    }
    
    @objc func handleLongPress() {
        codeModel.clear()
        reloadView()
    }
    
    @objc func handleLongRunPress() {
        fatalError()
    }
    
    // Helpers
    
    func launchAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        alert.modalPresentationStyle = .overCurrentContext
        self.present(alert, animated: true, completion: nil)
    }
    
    func launchCreate(id: BlockID) {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "blockCreateScene") as! BlockCreateViewController
        viewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        viewController.configure(currID: id, numVariables: numVars, delegate: self)
        present(viewController, animated: false, completion: nil)
    }
    
    func launchEdit(id: BlockID, data: Code) {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "blockEditScene") as! BlockEditViewController
        viewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        viewController.configure(id: id, data: data, numVariables: numVars, delegate: self)
        present(viewController, animated: false, completion: nil)
    }
    
    func reloadView() {
        
        let newView = codeTranslator.mainView(code: codeModel.currentCode, highlight: codeModel.currentBlock)
        
        for sub in scrollView.subviews{
            sub.removeFromSuperview()
        }
        
        scrollView.contentSize = newView.frame.size
        scrollView.addSubview(newView)
        
    }
    
    // Block Delegate
    
    func blockToBeEdited(id: BlockID, data: Code) {
        if(id.internalType == .blankBlock) {
            launchCreate(id: id)
        } else {
            launchEdit(id: id, data: data)
        }
    }
    
    func blockToBeSelected(id: BlockID) {
        if(id.parentType == .operationBlock) {
            codeModel.currentBlock = id
            reloadView()
        }
    }
    
    // Edit Block Delegate
    
    func doneEditing(id: BlockID, data: Code, action: EditAction) {
        let newCode = codeEditor.editCode(code: codeModel.currentCode, block: id, data: data, action: action)
        codeModel.currentCode = newCode
        if(action == .delete) {
            codeModel.currentBlock = BlockID.start
        }
        reloadView()
    }
    
    // Create Block Delegate
    
    func doneCreating(id: BlockID, data: Code, action: EditAction) {
        let newCode = codeEditor.editCode(code: codeModel.currentCode, block: id, data: data, action: action)
        codeModel.currentCode = newCode
        if(id.parentType == .operationBlock) {
            codeModel.currentBlock = id
        }
        reloadView()
    }
    
    // Status bar customization
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
}
