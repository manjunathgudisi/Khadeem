//
//  CoreDataManager.swift
//  SyndicatedLoans
//
//  Created by Gudisi, Manjunath on 26/03/18.
//  Copyright © 2018 SimplyFI. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager: NSObject {
    
    static var coreDataManager : CoreDataManager? = nil
    
    var initialCheckBool : Bool = false
    var vendorNameString = String()
    
    class func instance() -> CoreDataManager {
        if (coreDataManager == nil) {
            coreDataManager = CoreDataManager()
        }
        return coreDataManager!
    }
}
