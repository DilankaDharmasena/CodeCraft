//
//  ForBlock.swift
//  CodeCraft
//
//  Created by Dilanka Dharmasena on 12/2/18.
//  Copyright © 2018 dilankadharmasena. All rights reserved.
//

import UIKit

class ForBlock: UIView, Block {
    
    var delegate: BlockDelegate!
    
    var blockID: BlockID!

    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var iterInputView: UIView!
    @IBOutlet weak var iterInputViewHeight: NSLayoutConstraint!
    @IBOutlet weak var iterInputViewWidth: NSLayoutConstraint!
    
    @IBOutlet weak var operationsView: UIStackView!
    @IBOutlet weak var operationsViewHeight: NSLayoutConstraint!
    @IBOutlet weak var operationsViewWidth: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("ForBlock", owner: self, options: nil)
        
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
    
    func addIter(newView : UIView) {
        
        iterInputView.addSubview(newView)
        iterInputViewHeight.constant = newView.frame.size.height
        iterInputViewWidth.constant = newView.frame.size.width
        
    }
    
    func addOperations(opViews : [UIView]) {
        
        var height : CGFloat = 0.0
        var width = opViews[0].frame.size.width
        
        for view in opViews {
            height += view.frame.size.height
            width = max(width, view.frame.size.width)
            operationsView.addArrangedSubview(view)
        }
        
        operationsViewHeight.constant = height
        operationsViewWidth.constant = width
        
    }
    
    func setID(id: BlockID) {
        blockID = id
    }
    
    @objc func handleSingleTap() {
        delegate.blockToBeEdited(id: blockID, data: [])
    }
    
    @objc func handleDoubleTap() {
        delegate.blockToBeSelected(id: blockID)
    }
    
}
