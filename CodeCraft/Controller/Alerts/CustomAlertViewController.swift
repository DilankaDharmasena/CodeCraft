//
//  CustomAlertViewController.swift
//  CodeCraft
//
//  Created by Dilanka Dharmasena on 12/22/18.
//  Copyright © 2018 dilankadharmasena. All rights reserved.
//

import UIKit

class CustomAlertViewController: UIViewController {
    
    @IBOutlet weak var alertTitle: UILabel!
    @IBOutlet weak var alertTextView: UITextView!
    
    var alertTitleString: String = ""
    var alertMessageString : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        alertTitle.text = alertTitleString
        alertTextView.text = alertMessageString
        
        let viewTap = UITapGestureRecognizer(target: self, action: #selector(okTap))
        viewTap.numberOfTapsRequired = 1
        view.addGestureRecognizer(viewTap)
        
    }
    
    func configure(title: String, message: String = "") {
        alertTitleString = title
        alertMessageString = message
    }

    @IBAction func okTap() {
        dismiss(animated: false, completion: nil)
    }
    
}
