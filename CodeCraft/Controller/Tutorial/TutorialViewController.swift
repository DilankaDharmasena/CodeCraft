//
//  TutorialViewController.swift
//  CodeCraft
//
//  Created by Dilanka Dharmasena on 12/9/18.
//  Copyright © 2018 dilankadharmasena. All rights reserved.
//

import UIKit

class TutorialViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    let images : [String] = ["tutorial_1", "tutorial_2", "tutorial_3", "tutorial_4"]

    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self
        delegate = self
        
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        <#code#>
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        <#code#>
    }

}
