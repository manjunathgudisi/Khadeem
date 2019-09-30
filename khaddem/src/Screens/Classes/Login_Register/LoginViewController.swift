//
//  LoginViewController.swift
//  LoyaltyApp
//
//  Created by Sreekanth Gudisi on 20/07/18.
//  Copyright © 2018 SimplyFI. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var gradientUIView: UIView!
    @IBOutlet weak var nextUIView: UIView!
    @IBOutlet weak var signInUIView: UIView!
    
    //MARK:- GlobalVariables
    var registerDictionary : NSMutableDictionary = NSMutableDictionary()
    var emailString = String()
    var mobileNumberString = String()
    var loginDetailsDic : NSMutableDictionary? = nil
    
    private var gradientView : UIView? = nil
    
    //MARK :- ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // Actual Credientials
        emailTextField.text = "sarath"
        passwordTextField.text = "sarath123"
        
        nextUIView.isHidden = false
        signInUIView.isHidden = true
        
        //        emailTextField.text = "shiva.nair@simplyfi.tech"
        //        passwordTextField.text = "KF162M"
        
        
        
        
        // Testing Credential
        //        emailTextField.text = "manasayalalla@gmail"
        //     //   emailTextField.text = "gudisisreekanth@gmail.com"
        //        passwordTextField.text = "899HNF"
        
        //        emailTextField.text = "me.geojoy@gmail.com"
        //        passwordTextField.text = "geojoy"
    }
    
    //MARK :- ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    //MARK :- IBActions
    @IBAction func passwordShowIcon(_ sender: Any) {
        
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        
        //        guard emailTextField.isValidEmail() == true else {
        //            APIInterface.instance().showAlert(title: "", message: "Please enter valid email ID")
        //            return
        //        }
        
        if emailTextField.text?.count != 0 {
            nextUIView.isHidden = true
            signInUIView.isHidden = false
        }else{
            //            APIInterface.instance().showAlert(title: "", message: "Please enter valid email ID")
            APIInterface.instance().showAlert(title: "", message: "Please enter email ID")
        }
        
    }
    
    @IBAction func signInButtonTapped(_ sender: Any) {
        
        postLoginService()
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController
        vc!.registerDetailsDic = self.registerDictionary
        self.navigationController?.present(vc!, animated: true, completion: nil)
        //        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func forgotButtonTapped(_ sender: Any) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "ForgotViewController") as? ForgotViewController
        vc!.forgotDetailsDic = self.registerDictionary
        self.navigationController?.present(vc!, animated: true, completion: nil)
    }
}


//extension LoginViewController{
//
//    //MARK:- LoginServive
//    func getLoginService() {
//
//        // step1: check all validations
//        guard (emailTextField.text?.count != 0 &&
//            passwordTextField.text?.count != 0) else {
//                APIInterface.instance().showAlert(title: "", message: "Please enter all the details")
//                return
//        }
//
//        guard emailTextField.isValidEmail() == true else {
//            APIInterface.instance().showAlert(title: "", message: "Please enter valid email ID")
//            return
//        }
//
//        // step2: prepare input payload
//        var inputPayload = [String:Any]()
//        inputPayload["email"] = emailTextField.text
//        inputPayload["password"] = passwordTextField.text
//
//        // step3: execute the service
//        self.showLoadingIndicator()
//        _ = LoginWebAPI.instance().loginServiceDetails(inputPayload, completionHandler: { (response) in DispatchQueue.main.async {
//                print("Sachin")
//                guard response == nil else {
//                    // step4: do action (like display data on UI, or go to different screen..etc)
//                    print(response!)
//                    APIInterface.instance().loginResponse = response
//                    SharedInformation.instance().loginResponse = response
//                    if SharedInformation.instance().loginResponse?.message
//                        == "invalid email, account doent exist" {
//                        APIInterface.instance().showAlert(title: "", message: "invalid email, account doent exist")
//
//                    }else if SharedInformation.instance().loginResponse?.message
//                        == "invalid password" {
//                            APIInterface.instance().showAlert(title: "", message: "Please enter correct password")
//                    }else if SharedInformation.instance().loginResponse?.access_token?.count != nil {
//                        UserDefaults.standard.set(response?.access_token, forKey: "Token")
//                        let storyboard = UIStoryboard(name: "HomeOfUser", bundle: Bundle.main)
//                        let vc = storyboard.instantiateInitialViewController() as? UsersTabBarViewcontroller
//                        vc?.selectedViewController = vc?.viewControllers?[0]
//                        self.present(vc!, animated: true, completion: nil)
//                    }
//                    self.hideLoadingIndicator()
//                    return
//                }
//            }
//        })
//    }
//
//}

//MARK: - UITextfield
extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }
}

//MARK:- Functions
extension LoginViewController{
    
    //MARK:- LoginServive
    func postLoginService() {
        
        // step1: check all validations
        guard (emailTextField.text?.count != 0 &&
            passwordTextField.text?.count != 0) else {
                APIInterface.instance().showAlert(title: "", message: "Please enter all the details")
                return
        }
        
        //        guard emailTextField.isValidEmail() == true else {
        //            APIInterface.instance().showAlert(title: "", message: "Please enter valid email ID")
        //            return
        //        }
        
        // step2: prepare input payload
        var inputPayload = [String:Any]()
        inputPayload["username"] = emailTextField.text
        inputPayload["password"] = passwordTextField.text
        
        // step3: execute the service
        self.showLoadingIndicator()
        _ = LoginWebAPI.instance().loginServiceDetails(inputPayload, completionHandler: { (response) in DispatchQueue.main.async {
            print("Sachin")
            guard response == nil else {
                // step4: do action (like display data on UI, or go to different screen..etc)
                print(response!)
                SharedInformation.instance().loginResponse = response
                self.hideLoadingIndicator()
                if SharedInformation.instance().loginResponse?.success == true {
                    let storyboard = UIStoryboard(name: "TabBar", bundle: Bundle.main)
                    let vc = storyboard.instantiateInitialViewController() as? TabBarViewController
                    vc?.selectedViewController = vc?.viewControllers?[0]
                    self.present(vc!, animated: true, completion: nil)
                }
                return
            }
            }
        })
    }
}

