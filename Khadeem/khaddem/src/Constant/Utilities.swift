//
//  Register.swift
//  STF
//
//  Created by Sreekanth Gudisi on 24/01/18.
//  Copyright © 2018 Sreekanth Gudisi. All rights reserved.
//

import Foundation
import CoreData

class Utilities {
    
    // Variables
    var isPopUpViewButtonSelected = false
    var isSelectedDoneButton = false
    
    private static var utilities : Utilities? = nil
    
    class func instance() -> Utilities {
        if (utilities == nil) {
            utilities = Utilities()
        }
        return utilities!
    }
}
