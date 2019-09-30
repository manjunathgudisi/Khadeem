//
//  APIConfig.swift
//  CarbonTrades
//
//  Created by Sreekanth Gudisi on 03/05/18.
//  Copyright © 2018 SimplyFI. All rights reserved.
//

//
//  APIConfig.swift
//  STFForiPad
//
//  Created by Sreekanth Gudisi on 04/02/18.
//  Copyright © 2018 Sreekanth Gudisi. All rights reserved.
//
import Foundation
import UIKit

class APIInterface {
    
    private static var apiInterface : APIInterface? = nil
    static let baseURL = "http://157.245.97.110:8118"
    
    static func instance() -> APIInterface {
        
        if (apiInterface == nil) {
            apiInterface = APIInterface()
        }
        return apiInterface!
    }
    
    private init() {
        // Fetch logged in keys
        //loadAuthentication()
    }
    
    // MARK: - APiConfig Reuse methods
    
    private func loadAuthentication() {
        // TODO: Use Keychain.
    }
    
    public func executeAuthenticatedWithOutTokenRequest(request: URLRequest, _ autoErrorHandling: Bool = false, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Swift.Void) -> URLSessionDataTask {
        var request = request
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return executeRequest(request:request, autoErrorHandling, completionHandler: completionHandler)
    }
    
    public func executeRequest(request: URLRequest, _ autoErrorHandling: Bool = false, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Swift.Void) -> URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                BusyIndicator.hideBusyIndicator()
            }
            
            if error != nil && autoErrorHandling {
                self.showError(error: error)
            }
            
            //check for error message
            if let data = data {
                print(data)
                completionHandler(data, response, error)
            }
            //            if let data = data {
            //                do {
            //                    let jsonDecoder = JSONDecoder()
            //                    let errorCheck = try jsonDecoder.decode(ErrorMessage.self, from: data)
            //                    if (errorCheck.message != nil) {
            //                        APIInterface.instance().showAlert(title: "Error", message: errorCheck.message)
            //                        completionHandler(nil, response, error)
            //                        return
            //                    }
            //                } catch let error as NSError {
            //                    print(error.localizedDescription)
            //                    completionHandler(nil, response, error)
            //                    return
            //                }
            //            }
            
            //completionHandler(data, response, error)
        }
        task.resume()
        return task
    }
    
    public func executeAuthenticatedWithTokenRequest(request: URLRequest, _ autoErrorHandling: Bool = false, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Swift.Void) -> URLSessionDataTask {
        var request = request
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return executeRequestWithNoErrorCheck(request:request, autoErrorHandling, completionHandler: completionHandler)
    }
    
    public func executeAuthenticatedRequestWithNoErrorCheck(request: URLRequest, _ autoErrorHandling: Bool = false, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Swift.Void) -> URLSessionDataTask {
        var request = request
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return executeRequestWithNoErrorCheck(request:request, autoErrorHandling, completionHandler: completionHandler)
    }
    
    public func executeRequestWithNoErrorCheck(request: URLRequest, _ autoErrorHandling: Bool = false, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Swift.Void) -> URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if error != nil && autoErrorHandling {
                self.showError(error: error)
            }
            
            //check for error message
            if let data = data {
                completionHandler(data, response, error)
            }
            
            completionHandler(nil, response, error)
        }
        task.resume()
        return task
    }
    
    public func showError(error: Error?) {
        showAlert(title: "Error", message: error?.localizedDescription)
    }
    
    public func showAlert(title: String, message: String?,_ handler: ((UIAlertAction) -> Swift.Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: handler))
        currentTopViewController()?.present(alert, animated: true, completion: nil)
    }
    
    public func currentTopViewController() -> UIViewController? {
        var topVC: UIViewController? = UIApplication.shared.delegate?.window??.rootViewController
        while topVC?.presentedViewController != nil {
            topVC = topVC?.presentedViewController
        }
        return topVC
    }
    
    public func convertToJson(data: Any) -> Data? {
        do {
            
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
            return jsonData
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    func convertToJsonObject(data : Data) -> Any? {
        do {
            return try JSONSerialization.jsonObject(with: data, options: [])
        } catch {
            print(error.localizedDescription)
            let errordata = String(data: data, encoding: .utf8) ?? ""
            print(errordata)
        }
        return nil
    }
    
    func convertToJsonObject(from string: String?) -> Any? {
        do {
            if string == nil {
                return nil
            }
            let data = string?.data(using: String.Encoding.utf8)
            return try JSONSerialization.jsonObject(with: data!, options: [])
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    func convertToJsonString(data : Any) -> Any? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
            let string = String.init(data: jsonData, encoding: String.Encoding.utf8)
            return string
        } catch {
            print(error.localizedDescription)
            let errordata = String(data: data as! Data, encoding: .utf8) ?? ""
            print(errordata)
        }
        return nil
    }
}
