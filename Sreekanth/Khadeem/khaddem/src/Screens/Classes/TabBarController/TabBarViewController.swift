//
//  TabBarViewController.swift
//  TraiApp
//
//  Created by Sreekanth G on 2/20/19.
//  Copyright © 2019 simplyfi.apps. All rights reserved.
//

import Foundation
import UIKit

class TabBarViewController: UITabBarController {

    var mobileNumber = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        UITabBar.appearance().tintColor = UIColor(red: 36.0/255.0, green: 95.0/255.0, blue: 113/255.0, alpha: 1.0)
    }
}
