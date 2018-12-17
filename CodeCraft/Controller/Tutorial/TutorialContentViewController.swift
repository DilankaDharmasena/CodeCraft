//
//  TutorialContentViewController.swift
//  CodeCraft
//
//  Created by Dilanka Dharmasena on 12/9/18.
//  Copyright © 2018 dilankadharmasena. All rights reserved.
//

import UIKit

protocol tutorialContentDelegate {
    func endTutorial()
}

class TutorialContentViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var startButton: UIButton!
    
    var tutorialPage : Int! = nil
    var imageName : String! = nil
    var final : Bool! = nil
    var delegate : tutorialContentDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let image = UIImage(named: imageName)
        imageView.image = image
        
        if(!final) {
            startButton.isHidden = true
        }
        
    }
    
    func configure(imageName image: String, index: Int, isFinal: Bool, delegate lDelegate: tutorialContentDelegate) {
        imageName = image
        tutorialPage = index
        final = isFinal
        delegate = lDelegate
    }
    
    @IBAction func startButtonTap() {
        delegate.endTutorial()
    }
    
}
