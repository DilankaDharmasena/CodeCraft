//
//  LevelBubbleCollectionViewCell.swift
//  CodeCraft
//
//  Created by Dilanka Dharmasena on 11/20/18.
//  Copyright © 2018 dilankadharmasena. All rights reserved.
//

import UIKit

class LevelBubbleCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var levelIndicator: UIImageView!
    @IBOutlet weak var levelLabel: UILabel!
    
    var levelID : Int = 0
    
    func configure(levelNumber: Int, levelStatus: Int) {
        
        var bubbleImageName = String()
        
        switch levelStatus {
        case 1:
            bubbleImageName = "level_start"
        case 2:
            bubbleImageName = "level_done"
        default:
            bubbleImageName = "level_new"
        }
        
        let bubbleImage = UIImage(named: bubbleImageName)
        levelIndicator.image = bubbleImage
        
        levelLabel.text = String(levelNumber)
        
        levelID = levelNumber
    }
    
}
