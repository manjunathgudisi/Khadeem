//
//  OTPforRedeemWebAPI.swift
//  LoyaltyApp
//
//  Created by Sreekanth Gudisi on 15/06/18.
//  Copyright © 2018 SimplyFI. All rights reserved.
//

import Foundation

class SetIOTDataWebAPI {

    private static var setIOTDataWebAPI : SetIOTDataWebAPI? = nil
    static let setIOTDataMethodName = "/setIOTdata"
    
    static func instance() -> SetIOTDataWebAPI {
        if (setIOTDataWebAPI == nil) {
            setIOTDataWebAPI = SetIOTDataWebAPI()
        }
        return setIOTDataWebAPI!
    }
    
    public func setIOTDataServiceDetails(_ inputPayload : [String:Any], completionHandler: @escaping(SetIOTDataResponse?) -> Void) -> URLSessionDataTask {
        
        let urlBuilder = APIInterface.baseURL + SetIOTDataWebAPI.setIOTDataMethodName
        print(urlBuilder)
        var request = URLRequest(url: URL(string: urlBuilder)!)
        request.httpBody = APIInterface.instance().convertToJson(data: inputPayload)
        request.httpMethod = "POST"
        
        return APIInterface.instance().executeAuthenticatedWithTokenRequest(request: request, completionHandler: { (data, response, error) in
            if let data = data {
                do {
                    let jsonDecoder = JSONDecoder()
                    let response = try jsonDecoder.decode(SetIOTDataResponse.self, from: data)
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
