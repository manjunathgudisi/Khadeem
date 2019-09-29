
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
    static var loginMethodName = "user/sign-in"
    
    //Response
    var message : String? = ""
    var success : Bool?
    var token : String? = ""
    var userArray = [String]()
    var fullName : String? = ""
    var emailId : String? = ""
    
    static func instance() -> LoginWebAPI {
        if (loginWebAPI == nil) {
            loginWebAPI = LoginWebAPI()
        }
        return loginWebAPI!
    }
    
    public func loginServiceDetails(_ inputPayload : [String:Any], completionHandler: @escaping(LoginResponse?) -> Void) -> URLSessionDataTask {
        
//        Reachability.isInternetAvailable(webSiteToPing: nil) { (isInternetAvailable) in
//            guard isInternetAvailable else {
//                // Internet not available
//                completionHandler(false)
//                return
//            }
//            // Internet available
//
//        let urlBuilder = APIInterface.baseURL + LoginWebAPI.loginMethodName
//        print(urlBuilder)
//        var request = URLRequest(url: URL(string: urlBuilder)!)
//        request.httpBody = APIInterface.instance().convertToJson(data: inputPayload)
//        request.httpMethod = "POST"
//
//            return  APIInterface.instance().executeAuthenticatedWithOutTokenRequest(request: request, completionHandler: { (data, response, error) in
//                if let data = data {
//                    do {
//                        //let url = Bundle.main.url(forResource:"contents", withExtension: "json")
//                        //let fileData = try Data(contentsOf:url!)
//                        let jsonDecoder = JSONDecoder()
//                        //jsonDecoder.dateDecodingStrategy = .formatted(APIInterface.dateFormatterWithTime)
//                        let responseModel = try jsonDecoder.decode(NewProposalResponse.self, from: data)
//                        //String.init(data: data, encoding: String.Encoding.utf8)
//                        completionHandler(responseModel)
//                    }
//                    catch let error as NSError {
//                        APIInterface.instance().showError(error: error)
//                        completionHandler(nil)
//                    }
//                }
//                //            else if let error = error {
//                //                APIInterface.instance().showError(error: error)
//                //                completionHandler(nil)
//                //            }
//            })
//
//        }
        
        
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
    
    // SaveCoreData
    class func saveResponseToCoreData() {
        //save to core data
//        let object: NSManagedObject? = NSEntityDescription.insertNewObject(forEntityName: "LoginDetalis", into: PersistenceServce.context )
//        object?.setValue(LoginWebAPI.instance().message, forKey: "message")
//        object?.setValue(LoginWebAPI.instance().success, forKey: "success")
//        object?.setValue(LoginWebAPI.instance().token, forKey: "token")
//        
//        let userObject: NSManagedObject? = NSEntityDescription.insertNewObject(forEntityName: "UserFromLoginDetails", into: PersistenceServce.context )
//        userObject?.setValue(LoginWebAPI.instance().message, forKey: "fullName")
//        userObject?.setValue(LoginWebAPI.instance().success, forKey: "emailId")
//        
//        PersistenceServce.saveContext()
    }
}


