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
    
    let levelModelUtils = LevelModelUtils.shared
    
    let reuseIdentifier = "Level_Bubble"
    
    required init?(coder aDecoder: NSCoder) {
        
        let levelLoader = LevelLoader() // Should be put in separate place
        levelLoader.updateLevels()      // that checks if recently updated
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        levelSelectionCollectionView.dataSource = self
        levelSelectionCollectionView.delegate = self
        
    }
    
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
    
    func reloadScreen() {
        levelSelectionCollectionView.reloadData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}
