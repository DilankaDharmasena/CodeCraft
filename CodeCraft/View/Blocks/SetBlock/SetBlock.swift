//
//  SetBlock.swift
//  CodeCraft
//
//  Created by Dilanka Dharmasena on 11/29/18.
//  Copyright © 2018 dilankadharmasena. All rights reserved.
//

import UIKit

class SetBlock: UIView, Block {
    
    var delegate: BlockDelegate!
    
    var blockID: BlockID!

    @IBOutlet var contentView: UIView!
    
    @IBOutlet var viewCollection: Array<UIView>!
    
    @IBOutlet weak var varToSetView: UIView!
    @IBOutlet weak var varToSetViewWidth: NSLayoutConstraint!
    @IBOutlet weak var varToSetViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var valToSetView: UIView!
    @IBOutlet weak var valToSetViewWidth: NSLayoutConstraint!
    @IBOutlet weak var valToSetViewHeight: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("SetBlock", owner: self, options: nil)
        
        self.addSubview(contentView)
        
        let buffer = BlockDimensions().Buffer
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: self.topAnchor, constant: buffer).isActive = true
        contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
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
    
    func addVarToSet(varView : UIView) {
        
        varToSetView.addSubview(varView)
        varToSetViewHeight.constant = varView.frame.size.height
        varToSetViewWidth.constant = varView.frame.size.width
        
    }
    
    func addValToSet(valView : UIView) {
        
        valToSetView.addSubview(valView)
        valToSetViewHeight.constant = valView.frame.size.height
        valToSetViewWidth.constant = valView.frame.size.width
        
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
