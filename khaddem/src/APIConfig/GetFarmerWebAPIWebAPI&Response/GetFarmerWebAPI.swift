//
//  OTPforRedeemWebAPI.swift
//  LoyaltyApp
//
//  Created by Sreekanth Gudisi on 15/06/18.
//  Copyright © 2018 SimplyFI. All rights reserved.
//

import Foundation

class GetFarmerWebAPI {

    private static var getFarmerWebAPI : GetFarmerWebAPI? = nil
    static let getFarmerMethodName = "/getFarmer"
    
    static func instance() -> GetFarmerWebAPI {
        if (getFarmerWebAPI == nil) {
            getFarmerWebAPI = GetFarmerWebAPI()
        }
        return getFarmerWebAPI!
    }
    
    public func getFarmerServiceDetails(_ inputPayload : [String:Any], completionHandler: @escaping(GetFarmerResponse?) -> Void) -> URLSessionDataTask {
        
        let urlBuilder = APIInterface.baseURL + GetFarmerWebAPI.getFarmerMethodName
        print(urlBuilder)
        var request = URLRequest(url: URL(string: urlBuilder)!)
        request.httpBody = APIInterface.instance().convertToJson(data: inputPayload)
        request.httpMethod = "POST"
        
        return APIInterface.instance().executeAuthenticatedWithTokenRequest(request: request, completionHandler: { (data, response, error) in
            if let data = data {
                do {
                    let jsonDecoder = JSONDecoder()
                    let response = try jsonDecoder.decode(GetFarmerResponse.self, from: data)
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
