//
//  LevelSelectionViewController.swift
//  CodeCraft
//
//  Created by Dilanka Dharmasena on 11/22/18.
//  Copyright © 2018 dilankadharmasena. All rights reserved.
//

import UIKit

class LevelSelectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, GameViewDelegate {
    
    
    @IBOutlet weak var levelSelectionCollectionView: UICollectionView!
    
    @IBOutlet weak var workshopButton: UIImageView!
    
    let levelModelUtils = LevelModelUtils()
    
    let reuseIdentifier = "Level_Bubble"
    
    required init?(coder aDecoder: NSCoder) {
        
        LevelLoader().updateLevels() // Should be put in separate place that checks if recently updated
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        levelSelectionCollectionView.dataSource = self
        levelSelectionCollectionView.delegate = self
        
        let tapWorkshop = UITapGestureRecognizer(target: self, action: #selector(openWorkshop))
        tapWorkshop.numberOfTapsRequired = 1
        workshopButton.addGestureRecognizer(tapWorkshop)
        
    }
    
    // Misc
    
    @objc func openWorkshop() {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "Workshop_Scene") as! WorkshopViewController
        viewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        viewController.configure(inputs: [], code: [])
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
        
        let level = levelModelUtils.level(id: indexPath.row + 1)[0]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! LevelBubbleCollectionViewCell
        cell.configure(levelNumber: Int(level.id), levelStatus: Int(level.status))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! LevelBubbleCollectionViewCell
        
        let viewController = storyboard?.instantiateViewController(withIdentifier: "Game_Scene") as! GameViewController
        viewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        viewController.configure(gameID: cell.levelID, delegate: self)
        present(viewController, animated: false, completion: nil)
        
    }
    
    // Game Delegate
    
    func reloadScreen() {
        levelSelectionCollectionView.reloadData()
    }
    
    // Status Bar
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}
