//
//  OTPforRedeemWebAPI.swift
//  LoyaltyApp
//
//  Created by Sreekanth Gudisi on 15/06/18.
//  Copyright © 2018 SimplyFI. All rights reserved.
//

import Foundation

class GetMilestoneWebAPI {

    private static var getMilestoneWebAPI : GetMilestoneWebAPI? = nil
    static let getMilestoneMethodName = "/getMilestone"
    
    static func instance() -> GetMilestoneWebAPI {
        if (getMilestoneWebAPI == nil) {
            getMilestoneWebAPI = GetMilestoneWebAPI()
        }
        return getMilestoneWebAPI!
    }
    
    public func getMilestoneServiceDetails(_ inputPayload : [String:Any], completionHandler: @escaping(GetMilestoneResponse?) -> Void) -> URLSessionDataTask {
        
        let urlBuilder = APIInterface.baseURL + GetMilestoneWebAPI.getMilestoneMethodName
        print(urlBuilder)
        var request = URLRequest(url: URL(string: urlBuilder)!)
        request.httpBody = APIInterface.instance().convertToJson(data: inputPayload)
        request.httpMethod = "POST"
        
        return APIInterface.instance().executeAuthenticatedWithTokenRequest(request: request, completionHandler: { (data, response, error) in
            if let data = data {
                do {
                    let jsonDecoder = JSONDecoder()
                    let response = try jsonDecoder.decode(GetMilestoneResponse.self, from: data)
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
