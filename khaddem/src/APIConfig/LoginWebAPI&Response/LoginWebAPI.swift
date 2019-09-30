
//
//  NewProposalWebAPI.swift
//  CarbonTrades
//
//  Created by Sreekanth Gudisi on 04/11/18.
//  Copyright © 2018 SimplyFI. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class LoginWebAPI {
    
    private static var loginWebAPI : LoginWebAPI? = nil
    static var loginMethodName = "/api/v1/login"

    static func instance() -> LoginWebAPI {
        if (loginWebAPI == nil) {
            loginWebAPI = LoginWebAPI()
        }
        return loginWebAPI!
    }
    
    public func loginServiceDetails(_ inputPayload : [String:Any], completionHandler: @escaping(LoginResponse?) -> Void) -> URLSessionDataTask {

        let urlBuilder = APIInterface.baseURL + LoginWebAPI.loginMethodName
        print(urlBuilder)
        var request = URLRequest(url: URL(string: urlBuilder)!)
        request.httpBody = APIInterface.instance().convertToJson(data: inputPayload)
        request.httpMethod = "POST"

        return APIInterface.instance().executeAuthenticatedWithOutTokenRequest(request: request, completionHandler: { (data, response, error) in
            if let data = data {
                do {
                    //let url = Bundle.main.url(forResource:"contents", withExtension: "json")
                    //let fileData = try Data(contentsOf:url!)
                    let jsonDecoder = JSONDecoder()
                    //jsonDecoder.dateDecodingStrategy = .formatted(APIInterface.dateFormatterWithTime)
                    let responseModel = try jsonDecoder.decode(LoginResponse.self, from: data)
                    //String.init(data: data, encoding: String.Encoding.utf8)
                    completionHandler(responseModel)
                }
                catch let error as NSError {
                    APIInterface.instance().showError(error: error)
                    completionHandler(nil)
                }
            }
        //            else if let error = error {
        //                APIInterface.instance().showError(error: error)
        //                completionHandler(nil)
        //            }
        })
    }
}


