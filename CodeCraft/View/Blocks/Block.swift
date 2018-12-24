//
//  Block.swift
//  CodeCraft
//
//  Created by Dilanka Dharmasena on 12/8/18.
//  Copyright © 2018 dilankadharmasena. All rights reserved.
//

import UIKit

protocol BlockDelegate {
    
    func blockToBeEdited(id: BlockID, data: Code)
    
    func blockToBeSelected(id: BlockID)
    
}

class Block: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet var viewCollection: Array<UIView>!
    
    var delegate: BlockDelegate!
    var blockID: BlockID!
    
    var buffer: CGFloat { return BlockDimensions().Buffer }
    var bottomBuffer: CGFloat { fatalError() }
    var blockName: String { fatalError() }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed(blockName, owner: self, options: nil)
        
        self.addSubview(contentView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: self.topAnchor, constant: buffer).isActive = true
        contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: bottomBuffer).isActive = true
        contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: buffer).isActive = true
        contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        for view in viewCollection {
            let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
            doubleTap.numberOfTapsRequired = 2
            let singleTap = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap))
            singleTap.numberOfTapsRequired = 1
            singleTap.require(toFail: doubleTap)
            view.addGestureRecognizer(doubleTap)
            view.addGestureRecognizer(singleTap)
        }
        
    }
    
    func setID(id: BlockID) {
        blockID = id
    }
    
    func select() {
        for view in viewCollection {
            view.backgroundColor = UIColor(red: 0.2, green: 0.3, blue: 0.3, alpha: 1.0)
        }
    }
    
    @objc func handleSingleTap() {
        delegate.blockToBeEdited(id: blockID, data: [])
    }
    
    @objc func handleDoubleTap() {
        delegate.blockToBeSelected(id: blockID)
    }
    
}
