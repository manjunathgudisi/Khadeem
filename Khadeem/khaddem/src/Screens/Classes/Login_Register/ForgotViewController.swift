//
//  ForgotViewController.swift
//  LoyaltyApp
//
//  Created by Sreekanth Gudisi on 02/01/19.
//  Copyright © 2018 SimplyFI. All rights reserved.
//

import UIKit

class ForgotViewController: BaseViewController {

    //MARK:- IBOutlets
    @IBOutlet weak var gradientUIView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    
    //MARK:- GlobalVariables
    var forgotDetailsDic : NSMutableDictionary? = nil
    
    //MARK:- ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        emailTextField.text = "abc@gmail.com"
        //gradientUIVIew()
    }

    //MARK:- IBActions
    @IBAction func signInButtonTapped(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendButtonTapped(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
}


//extension ForgotViewController{
//
//    // MARK:- FotGotService
//    func fotGotService() {
//
//        // step1: check all validations
//        guard emailTextField.isValidEmail() == true else {
//            APIInterface.instance().showAlert(title: "", message: "Please enter valid email ID")
//            return
//        }
//
//        // step2: prepare input payload
//        var inputPayload = [String:Any]()
//        inputPayload["email"] = emailTextField.text
//
//        // step3: execute the service
//        self.showLoadingIndicator()
//        _ = ForgotPasswordWebAPI.instance().forgotPasswordServiceDetails(inputPayload, completionHandler: { (response) in DispatchQueue.main.async {
//            print("Sachin")
//
//            guard response == nil else {
//                // step4: do action (like display data on UI, or go to different screen..etc)
//                print(response!)
//
//                if response?.message == "email not found" {
//                    APIInterface.instance().showAlert(title: "Forgot password", message: "Please check you are email")
//                }else if response?.message == "reset email send" {
//                    let alertController = UIAlertController(title: "Check mail", message: "Forgot password link has been sent to your email address", preferredStyle: UIAlertControllerStyle.alert)
//                    let OKAction = UIAlertAction(title: "Ok", style: .default) {
//                        (action:UIAlertAction!) in
//                        self.navigationController?.popViewController(animated: true)
//                    }
//                    alertController.addAction(OKAction)
//                    alertController.applyBranding()
//                    self.present(alertController, animated: true, completion: nil)
//                }
//                self.hideLoadingIndicator()
//                return
//            }
//            }
//        })
//    }
//
//}

//MARK: - UITextfield
extension ForgotViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        return true
    }
}

//MARK:- Functions
extension ForgotViewController {
    
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

