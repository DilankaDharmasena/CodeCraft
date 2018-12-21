//
//  BlankBlock.swift
//  CodeCraft
//
//  Created by Dilanka Dharmasena on 12/7/18.
//  Copyright © 2018 dilankadharmasena. All rights reserved.
//

import UIKit

class BlankBlock: UIView, Block {
    
    var delegate: BlockDelegate!
    
    var blockID: BlockID!

    @IBOutlet var contentView: UIView!
    
    @IBOutlet var viewCollection: Array<UIView>!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("BlankBlock", owner: self, options: nil)
        
        self.addSubview(contentView)
        
        let buffer = BlockDimensions().Buffer
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: self.topAnchor, constant: buffer).isActive = true
        contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -buffer).isActive = true
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
        
    }
    
    @objc func handleSingleTap() {
        delegate.blockToBeEdited(id: blockID, data: [])
    }
    
    @objc func handleDoubleTap() {
        delegate.blockToBeSelected(id: blockID)
    }
    
}
