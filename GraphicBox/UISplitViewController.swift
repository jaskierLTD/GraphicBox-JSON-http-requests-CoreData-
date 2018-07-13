//
//  UISplitViewController.swift
//  GraphicBox
//
//  Created by Alessandro Marconi on 13/07/2018.
//  Copyright © 2018 Alessandro Marconi. All rights reserved.
//

import UIKit

extension UISplitViewController
{
    convenience init(masterViewController: UIViewController, detailViewController: UIViewController) {
        self.init()
        viewControllers = [masterViewController, detailViewController]
    }
    
    var masterViewController: UIViewController? {
        return viewControllers.first
    }
    
    var detailViewController: UIViewController? {
        guard viewControllers.count == 2 else { return nil }
        return viewControllers.last
    }
}
