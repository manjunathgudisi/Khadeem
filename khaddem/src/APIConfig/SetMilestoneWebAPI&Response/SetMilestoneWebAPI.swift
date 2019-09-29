//
//  OTPforRedeemWebAPI.swift
//  LoyaltyApp
//
//  Created by Sreekanth Gudisi on 15/06/18.
//  Copyright © 2018 SimplyFI. All rights reserved.
//

import Foundation

class SetMilestoneWebAPI {

    private static var setMilestoneWebAPI : SetMilestoneWebAPI? = nil
    static let setMilestoneMethodName = "/setMilestone"
    
    static func instance() -> SetMilestoneWebAPI {
        if (setMilestoneWebAPI == nil) {
            setMilestoneWebAPI = SetMilestoneWebAPI()
        }
        return setMilestoneWebAPI!
    }
    
    public func setMilestoneDataServiceDetails(_ inputPayload : [String:Any], completionHandler: @escaping(SetIOTDataResponse?) -> Void) -> URLSessionDataTask {
        
        let urlBuilder = APIInterface.baseURL + SetMilestoneWebAPI.setMilestoneMethodName
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
