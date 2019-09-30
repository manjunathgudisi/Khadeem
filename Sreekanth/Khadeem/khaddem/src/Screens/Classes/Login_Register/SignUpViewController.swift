//
//  SignUpViewController.swift
//  khaddem
//
//  Created by I0006 on 12/08/19.
//  Copyright © 2019 I0006. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    //MARK:- IBOutlets
    @IBOutlet weak var fristNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var buildingTextField: UITextField!
    @IBOutlet weak var streetTextField: UITextField!
    @IBOutlet weak var picodeTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var reEnterPasswordTextField: UITextField!
    @IBOutlet weak var mobileNumberTextField: UITextField!
    
    @IBOutlet weak var gradientUIView: UIView!
    
    //MARK:- GlobalVariables
    var registerDetailsDic : NSMutableDictionary? = nil
    private var gradientView : UIView? = nil
    
    private var isFocus = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mobileNumberTextField.keyboardType = .numberPad
        
    }
    

    //MARK :- IBActions
    @IBAction func passwordShowIcon(_ sender: Any) {
        
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
    }
    @IBAction func reEnterPasswordShowIcon(_ sender: Any) {
        
        reEnterPasswordTextField.isSecureTextEntry = !reEnterPasswordTextField.isSecureTextEntry
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signInButtonTapped(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
}


//extension SignUpViewController{
//
//    //MARK:- RegisterServive
//    private func resisterService() {
//
//        // step1: check all validations
//        guard (userNameTextField.text?.count != 0 &&
//            emailTextField.text?.count != 0 &&
//            mobileNumberTextField.text?.count != 0 &&
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
//        guard mobileNumberTextField.isValidPhone() == true else {
//            APIInterface.instance().showAlert(title: "", message: "Please enter valid mobile number")
//            return
//        }
//
//        let mobileString = mobileNumberTextField.text
//        guard mobileString!.isPhoneNumber else {
//            APIInterface.instance().showAlert(title: "", message: "Phone number to have a minimum of 10 characters")
//            return
//        }
//
//        guard passwordTextField.isValidPassword() == true else {
//            passwordPolicy()
//            return
//        }
//
//        // step2: prepare input payload
//        var inputPayload = [String:Any]()
//        inputPayload["name"] = userNameTextField.text
//        inputPayload["email"] = emailTextField.text
//        let number = Int64(mobileNumberTextField.text!)
//        inputPayload["number"] = number
//        print(inputPayload["number"]!)
//        inputPayload["password"] = passwordTextField.text
//
//        // step3: execute the service
//        self.showLoadingIndicator()
//        _ = RegistrationWebAPI.instance().registerServiceDetails(inputPayload, completionHandler: { (response) in
//            DispatchQueue.main.async {
//                guard response == nil else {
//                    // step4: do action (like display data on UI, or go to different screen..etc)
//                    print(response!)
//                    if response?.message == "user profile pending, email for verification sent"{
//
//                        let alertController = UIAlertController(title: "Check mail", message: "Verification link has been sent to your email address", preferredStyle: UIAlertControllerStyle.alert)
//                        let OKAction = UIAlertAction(title: "Ok", style: .default) {
//                            (action:UIAlertAction!) in
//                            self.registerDetailsDic!.removeAllObjects()
//                            self.registerDetailsDic!.setObject(self.userNameTextField.text as Any,forKey: "username" as NSCopying)
//                            self.registerDetailsDic!.setObject(self.emailTextField.text as Any,forKey: "emailID" as NSCopying)
//                            self.registerDetailsDic!.setObject(self.mobileNumberTextField.text as Any,forKey: "number" as NSCopying)
//                            self.registerDetailsDic!.setObject(self.passwordTextField.text as Any,forKey: "password" as NSCopying)
//                            self.dismiss(animated: true, completion: nil)
//                        }
//                        alertController.applyBranding()
//                        alertController.applyActionBranding()
//                        alertController.addAction(OKAction)
//                        self.present(alertController, animated: true, completion: nil)
//
//
//                    }else if response?.status == "error"{
//                        APIInterface.instance().showAlert(title: "SignUP", message: "email already exists")
//                    }
//                    self.hideLoadingIndicator()
//                    //   APIInterface.instance().loginResponse = response
//                    return
//                }
//            }
//        })
//    }
//
//}

//MARK: - UITextfield
extension SignUpViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        fristNameTextField.resignFirstResponder()
        lastNameTextField.resignFirstResponder()
        buildingTextField.resignFirstResponder()
        streetTextField.resignFirstResponder()
        picodeTextField.resignFirstResponder()
        cityTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        reEnterPasswordTextField.resignFirstResponder()
        mobileNumberTextField.resignFirstResponder()
        return true
    }
}

extension SignUpViewController {
    
    func passwordPolicy() {
        
        let message1 = "1) Password should be atleast 6 characters \n"
        let message2 = "2) It should be alphanumeric \n"
        let message3 = "3) It should contain special characters \n"
        let message4 = "4) It should contain one small and one capital letter. \n"
        let message = " \n " + message1 + message2 + message3 + message4
        
        let alert = UIAlertController(title: "Password Policy: \n", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler:{ (UIAlertAction)in
            
        }))
        self.present(alert, animated: true, completion: {
            //nothing
        })
    }
    
    //    func passwordPolicyString() -> String{
    //
    //        let message1 = "1) Password should be atleast 6 characters \n"
    //        let message2 = "2) It should be alphanumeric \n"
    //        let message3 = "3) It should contain special characters \n"
    //        let message4 = "4) It should contain one small and one capital letter. \n"
    //        let message = message1 + message2 + message3 + message4
    //
    //        let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.actionSheet)
    //        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler:{ (UIAlertAction)in
    //
    //        }))
    //        self.present(alert, animated: true, completion: {
    //            //nothing
    //        })
    //        return message
    //    }
}

//MARK:- Functions
extension SignUpViewController {
    
    // GradientUIVIew
    private func gradientUIVIew() {
        let topColor = UIColor(red: 249.0/255.0, green: 250.0/255.0, blue: 245.0/255.0, alpha: 1.0)
        let bottomColor = UIColor(red: 234.0 / 255.0, green: 234.0 / 255.0, blue: 232.0 / 255.0, alpha: 1.0)
        gradientUIView.backgroundColor = UIColor.clear
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = gradientUIView.bounds
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientUIView.layer.insertSublayer(gradientLayer, at: 0)
    }
}

