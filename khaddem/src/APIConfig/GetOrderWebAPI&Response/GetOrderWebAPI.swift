//
//  OTPforRedeemWebAPI.swift
//  LoyaltyApp
//
//  Created by Sreekanth Gudisi on 15/06/18.
//  Copyright © 2018 SimplyFI. All rights reserved.
//

import Foundation

class GetOrderWebAPI {

    private static var getOrderWebAPI : GetOrderWebAPI? = nil
    static let getOrderMethodName = "/getOrders"
    
    static func instance() -> GetOrderWebAPI {
        if (getOrderWebAPI == nil) {
            getOrderWebAPI = GetOrderWebAPI()
        }
        return getOrderWebAPI!
    }
    
    public func getOrderServiceDetails(_ inputPayload : [String:Any], completionHandler: @escaping(GetOrderResponse?) -> Void) -> URLSessionDataTask {
        
        let urlBuilder = APIInterface.baseURL + GetOrderWebAPI.getOrderMethodName
        print(urlBuilder)
        var request = URLRequest(url: URL(string: urlBuilder)!)
        request.httpBody = APIInterface.instance().convertToJson(data: inputPayload)
        request.httpMethod = "POST"
        
        return APIInterface.instance().executeAuthenticatedWithTokenRequest(request: request, completionHandler: { (data, response, error) in
            if let data = data {
                do {
                    let jsonDecoder = JSONDecoder()
                    let response = try jsonDecoder.decode(GetOrderResponse.self, from: data)
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
