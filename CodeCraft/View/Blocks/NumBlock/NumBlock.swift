//
//  NumBlock.swift
//  CodeCraft
//
//  Created by Dilanka Dharmasena on 11/29/18.
//  Copyright © 2018 dilankadharmasena. All rights reserved.
//

import UIKit

class NumBlock: UIView, Block {
    
    var delegate: BlockDelegate!
    
    var blockID: BlockID!
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var numLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("NumBlock", owner: self, options: nil)
        
        self.addSubview(contentView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        doubleTap.numberOfTapsRequired = 2
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap))
        singleTap.numberOfTapsRequired = 1
        singleTap.require(toFail: doubleTap)
        self.addGestureRecognizer(doubleTap)
        self.addGestureRecognizer(singleTap)
    }
    
    func setNum(number : Int) {
        numLabel.text = String(number)
    }
    
    func setID(id: BlockID) {
        blockID = id
    }
    
    @objc func handleSingleTap() {
        delegate.blockToBeEdited(id: blockID, data: [Int(numLabel.text!)!])
    }
    
    @objc func handleDoubleTap() {
        delegate.blockToBeSelected(id: blockID)
    }

}
