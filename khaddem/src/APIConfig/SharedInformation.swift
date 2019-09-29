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
    
    var registerResponse :RegisterResponse? = nil
    var loginResponse :LoginResponse? = nil
    
    var getOrderResponse : GetOrderResponse? = nil
    var getOrderArray : [GetOrders]? = nil
    
    var placeOrderResponse : PlaceOrderResponse? = nil
    
    var getIOTDataResponse : GetIOTDataResponse? = nil
    var getIotdataArray : [Iotdata]? = nil
    
    var setIOTDataResponse : SetIOTDataResponse? = nil
    
    var getMilestoneResponse : GetMilestoneResponse? = nil
    var getMilestoneArray: [GetMilestone]? = nil
    
    var setMilestoneResponse : SetMilestoneResponse? = nil
    
    var setFarmerResponse : GetFarmerResponse? = nil
    var getFarmerArray : GetFarmer? = nil

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
