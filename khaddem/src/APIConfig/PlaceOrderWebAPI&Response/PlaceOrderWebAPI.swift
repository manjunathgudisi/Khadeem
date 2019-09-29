//
//  OTPforRedeemWebAPI.swift
//  LoyaltyApp
//
//  Created by Sreekanth Gudisi on 15/06/18.
//  Copyright © 2018 SimplyFI. All rights reserved.
//

import Foundation

class PlaceOrderWebAPI {

    private static var placeOrderWebAPI : PlaceOrderWebAPI? = nil
    static let getOrderMethodName = "/placeOrder"
    
    static func instance() -> PlaceOrderWebAPI {
        if (placeOrderWebAPI == nil) {
            placeOrderWebAPI = PlaceOrderWebAPI()
        }
        return placeOrderWebAPI!
    }
    
    public func placeOrderServiceDetails(_ inputPayload : [String:Any], completionHandler: @escaping(PlaceOrderResponse?) -> Void) -> URLSessionDataTask {
        
        let urlBuilder = APIInterface.baseURL + PlaceOrderWebAPI.getOrderMethodName
        print(urlBuilder)
        var request = URLRequest(url: URL(string: urlBuilder)!)
        request.httpBody = APIInterface.instance().convertToJson(data: inputPayload)
        request.httpMethod = "POST"
        
        return APIInterface.instance().executeAuthenticatedWithTokenRequest(request: request, completionHandler: { (data, response, error) in
            if let data = data {
                do {
                    let jsonDecoder = JSONDecoder()
                    let response = try jsonDecoder.decode(PlaceOrderResponse.self, from: data)
                    completionHandler(response)
                }
                catch let error as NSError {
                    APIInterface.instance().showError(error: error)
                    completionHandler(nil)
                }

            }
        })
    }
}
