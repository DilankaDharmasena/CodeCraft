//
//  TypingViewController.swift
//  CodeCraft
//
//  Created by Dilanka Dharmasena on 12/23/18.
//  Copyright © 2018 dilankadharmasena. All rights reserved.
//

import UIKit

class TypingViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    func setup() {
        textField.delegate = self
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        let viewTap = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        viewTap.numberOfTapsRequired = 1
        view.addGestureRecognizer(viewTap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    // Button Actions
    
    @IBAction func cancelTapped() {
        dismiss(animated: false, completion: nil)
    }
    
    @objc func viewTapped() {
        if(textField.isFirstResponder) {
            textField.resignFirstResponder()
        } else {
            cancelTapped()
        }
    }
    
    // Keyboard Stuff
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame: CGRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + keyboardFrame.height / 2)
        scrollView.setContentOffset(CGPoint(x: 0, y: keyboardFrame.height / 2), animated: true)
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Flip Screen
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        scrollView.contentSize = size
    }
    
}
