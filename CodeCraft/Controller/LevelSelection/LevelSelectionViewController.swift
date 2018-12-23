//
//  LevelSelectionViewController.swift
//  CodeCraft
//
//  Created by Dilanka Dharmasena on 11/22/18.
//  Copyright © 2018 dilankadharmasena. All rights reserved.
//

import UIKit

class LevelSelectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, GameViewDelegate, WorkshopDelegate {
    
    @IBOutlet weak var levelSelectionCollectionView: UICollectionView!
    @IBOutlet weak var workshopButton: UIImageView!
    
    let levelModelUtils = LevelModelUtils()
    
    let reuseIdentifier = "Level_Bubble"
    
    var transferTracker : Code?
    
    // Lifecycle
    
    required init?(coder aDecoder: NSCoder) {
        
        LevelLoader().updateLevels()
        //LevelLoader().resetLevels()
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        levelSelectionCollectionView.dataSource = self
        levelSelectionCollectionView.delegate = self
        
        let tapWorkshop = UITapGestureRecognizer(target: self, action: #selector(handleWorkshopTap))
        tapWorkshop.numberOfTapsRequired = 1
        workshopButton.addGestureRecognizer(tapWorkshop)
        
    }
    
    // Misc
    
    func transferMode(code: Code) {
        transferTracker = code
        
        // UI Changes
        workshopButton.isHighlighted = true
    }
    
    func normalMode(gameID : Int? = nil) {
        let localTransfer = transferTracker!
        transferTracker = nil
        
        if let id = gameID {
            openLevel(gameID: id, code: localTransfer)
        }
        
        // UI Changes
        workshopButton.isHighlighted = false
        
    }
    
    @objc func handleWorkshopTap() {
        if(transferTracker == nil) {
            openWorkshop()
        } else {
            normalMode()
        }
    }
    
    // Launchers
    
    func openWorkshop(inputs: [Int] = [], code : Code = []) {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "Workshop_Scene") as! WorkshopViewController
        viewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        viewController.configure(inputs: inputs, code: code, delegate: self)
        present(viewController, animated: false, completion: nil)
    }
    
    func openLevel(gameID: Int, code: Code = []) {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "Game_Scene") as! GameViewController
        viewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        viewController.configure(gameID: gameID, code: code, delegate: self)
        present(viewController, animated: false, completion: nil)
    }
    
    // Collection View
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1 // Permanent
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let levels = levelModelUtils.allLevels()
        return levels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let level = levelModelUtils.level(id: indexPath.row + 1)
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! LevelBubbleCollectionViewCell
        cell.configure(levelNumber: Int(level.id), levelStatus: Int(level.status))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! LevelBubbleCollectionViewCell
        
        if(transferTracker == nil) {
            openLevel(gameID: cell.levelID)
        } else {
            normalMode(gameID: cell.levelID)
        }
    }
    
    // Game View Delegate
    
    func reloadScreen() {
        levelSelectionCollectionView.reloadData()
    }
    
    func transferToWorkshop(code: Code, input: [Int]) {
        openWorkshop(inputs: input, code: code)
    }
    
    // Workshop Delegate
    
    func transferToLevel(code: Code) {
        transferMode(code: code)
    }
    
    // Status Bar
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
}
