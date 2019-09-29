//
//  OTPforRedeemWebAPI.swift
//  LoyaltyApp
//
//  Created by Sreekanth Gudisi on 15/06/18.
//  Copyright © 2018 SimplyFI. All rights reserved.
//

import Foundation

class GetIOTDataWebAPI {

    private static var getIOTDataWebAPI : GetIOTDataWebAPI? = nil
    static let getIOTDataMethodName = "/getIOTData"

    static func instance() -> GetIOTDataWebAPI {
        if (getIOTDataWebAPI == nil) {
            getIOTDataWebAPI = GetIOTDataWebAPI()
        }
        return getIOTDataWebAPI!
    }
    
    public func getIOTDataServiceDetails(_ inputPayload : [String:Any], completionHandler: @escaping(GetIOTDataResponse?) -> Void) -> URLSessionDataTask {
        
        let urlBuilder = APIInterface.baseURL + GetIOTDataWebAPI.getIOTDataMethodName
        print(urlBuilder)
        var request = URLRequest(url: URL(string: urlBuilder)!)
        request.httpBody = APIInterface.instance().convertToJson(data: inputPayload)
        request.httpMethod = "POST"
        
        return APIInterface.instance().executeAuthenticatedWithTokenRequest(request: request, completionHandler: { (data, response, error) in
            if let data = data {
                do {
                    let jsonDecoder = JSONDecoder()
                    let response = try jsonDecoder.decode(GetIOTDataResponse.self, from: data)
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
