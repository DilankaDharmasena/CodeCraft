//
//  UIViewControllerExtension.swift
//  CodeCraft
//
//  Created by Dilanka Dharmasena on 12/22/18.
//  Copyright © 2018 dilankadharmasena. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func launchAlertDialog(title: String, message: String = "") {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "CustomAlert_Scene") as! CustomAlertViewController
        viewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        viewController.configure(title: title, message: message)
        present(viewController, animated: false, completion: nil)
    }
    
}
