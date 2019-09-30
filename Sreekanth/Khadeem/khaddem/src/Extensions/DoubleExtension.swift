//
//  DoubleExtension.swift
//  LoyaltyApp
//
//  Created by Sreekanth G on 1/29/19.
//  Copyright © 2019 SimplyFI. All rights reserved.
//

import Foundation

extension Double {
    var cleanCharetersAfterDot: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}

extension Float{
    var cleanValue: String{
        //return String(format: 1 == floor(self) ? "%.0f" : "%.2f", self)
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(format: "%.2f", self)//
    }
}
