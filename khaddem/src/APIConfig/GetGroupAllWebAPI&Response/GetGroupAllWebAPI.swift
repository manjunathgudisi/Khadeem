//
//  OTPforRedeemWebAPI.swift
//  LoyaltyApp
//
//  Created by Sreekanth Gudisi on 15/06/18.
//  Copyright © 2018 SimplyFI. All rights reserved.
//

import Foundation

class GetGroupAllWebAPI {

    private static var getGroupAllWebAPI : GetGroupAllWebAPI? = nil
    static let getGroupAllMethodName = "/api/v1/groups/all"

    static func instance() -> GetGroupAllWebAPI {
        if (getGroupAllWebAPI == nil) {
            getGroupAllWebAPI = GetGroupAllWebAPI()
        }
        return getGroupAllWebAPI!
    }
    
    public func getIOTDataServiceDetails(_ completionHandler: @escaping(GetGroupAllResponse?) -> Void) -> URLSessionDataTask {
        
        let urlBuilder = APIInterface.baseURL + GetGroupAllWebAPI.getGroupAllMethodName
        print(urlBuilder)
        var request = URLRequest(url: URL(string: urlBuilder)!)
        request.httpMethod = "POST"
        
        return APIInterface.instance().executeAuthenticatedWithTokenRequest(request: request, completionHandler: { (data, response, error) in
            if let data = data {
                do {
                    let jsonDecoder = JSONDecoder()
                    let response = try jsonDecoder.decode(GetGroupAllResponse.self, from: data)
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
