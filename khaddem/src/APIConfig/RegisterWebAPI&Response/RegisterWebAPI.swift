
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


class RegisterWebAPI {
    
    private static var registerWebAPI : RegisterWebAPI? = nil
    static let registerMethodName = "user/register"
    
    //Response
    var message : String? = ""
    var success : Bool?
    
    static func instance() -> RegisterWebAPI {
        if (registerWebAPI == nil) {
            registerWebAPI = RegisterWebAPI()
        }
        return registerWebAPI!
    }
    
    public func registerServiceDetails(_ inputPayload : [String:Any], completionHandler: @escaping(RegisterResponse?) -> Void) -> URLSessionDataTask {
        
//        Reachability.isInternetAvailable(webSiteToPing: nil) { (isInternetAvailable) in
//            guard isInternetAvailable else {
//                // Internet not available
//                completionHandler(false)
//                return
//            }
//            // Internet available
//
//        let urlBuilder = APIInterface.baseURL + NewProposalWebAPI.newProposalMethodName
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
        
        
        let urlBuilder = APIInterface.baseURL + RegisterWebAPI.registerMethodName
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
                    let responseModel = try jsonDecoder.decode(RegisterResponse.self, from: data)
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
//        let object: NSManagedObject? = NSEntityDescription.insertNewObject(forEntityName: "RegistationDetails", into: PersistenceServce.context )
//        object?.setValue(RegisterWebAPI.instance().message, forKey: "message")
//        object?.setValue(RegisterWebAPI.instance().success, forKey: "success")
//        
//        PersistenceServce.saveContext()
    }
}


