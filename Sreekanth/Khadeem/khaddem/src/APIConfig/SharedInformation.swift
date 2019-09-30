//
//  SharedInformation.swift
//  DieselApp
//
//  Created by Gudisi, Manjunath on 06/06/18.
//  Copyright © 2018 Narayan. All rights reserved.
//

import Foundation

class SharedInformation {
    
    private static var sharedInformation : SharedInformation? = nil

    var loginResponse :LoginResponse? = nil
    var getGroupAllResponse : GetGroupAllResponse? = nil

    static func instance() -> SharedInformation {
        if (sharedInformation == nil) {
            sharedInformation = SharedInformation()
        }
        return sharedInformation!
    }
    
    private init() {
        // Fetch logged in keys
    }
}
