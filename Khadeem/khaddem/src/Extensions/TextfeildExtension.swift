//
//  TextfeildExtension.swift
//  LoyaltyApp
//
//  Created by Sreekanth Gudisi on 04/12/18.
//  Copyright © 2018 SimplyFI. All rights reserved.
//

import Foundation
import UIKit

private var maxLengths = [UITextField: Int]()

public enum PasswordStrenth : Int {
    case notValidPassword
    case weak
    case normal
    case strong
}

extension UITextField {
    
    func isValidEmail() -> Bool {
        if let text = text {
            let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            let result = emailTest.evaluate(with: text)
            return result
        }
        return false
    }
    
    func isValidPhone() -> Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: text!, options: [], range: NSMakeRange(0, text!.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == text!.count
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    
    func isValidPassword()-> Bool {
        return UITextField.isValidPassword(from: text)
    }
    
    static func passwordStrenth(from text: String?) -> PasswordStrenth {
        if UITextField.isValidPassword(from: text) == true {
            if (text?.count)! == 6 {
                return PasswordStrenth.weak
            } else if (text?.count)! >= 7 && (text?.count)! <= 13 {
                return PasswordStrenth.normal
            } else if (text?.count)! >= 14 {
                return PasswordStrenth.strong
            }
        }
        return PasswordStrenth.notValidPassword
    }
    
    static func isValidPassword(from text: String?) -> Bool {
        /*
         
         Kindly do below validations in password during registration
         
         
         1) Password should be atleast 6 characters (if only 6 characters then show it is as weak)
         
         2) It should be alphanumeric
         
         3) It should contain special characters
         
         4) It should contain one small and one capital letter.
         
         5) If contains 14 characters then show the password strength as strong.
         
         6) If it is between 6-14 characters then show as normal
         
         */
        let regularExpression = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{6,}"
        let passwordValidation = NSPredicate.init(format: "SELF MATCHES %@", regularExpression)
        return passwordValidation.evaluate(with: text)
    }
    
    
}

// Allowing PlaceHolderColor in textfield
extension UITextField {
    
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            if let color = self.attributedPlaceholder?.attribute(.foregroundColor, at: 0, effectiveRange: nil) as? UIColor {
                return color
            }
            return nil
        }
        set (setOptionalColor) {
            if let setColor = setOptionalColor {
                let string = self.placeholder ?? ""
                self.attributedPlaceholder = NSAttributedString(string: string , attributes:[NSAttributedString.Key.foregroundColor: setColor])
            }
        }
    }
}

// Allowing maximum numbers in textfield
extension UITextField {
    @IBInspectable var maxLength: Int {
        get {
            guard let l = maxLengths[self] else {
                return 150 // (global default-limit. or just, Int.max)
            }
            return l
        }
        set {
            maxLengths[self] = newValue
            addTarget(self, action: #selector(fix), for: .editingChanged)
        }
    }
    @objc func fix(textField: UITextField) {
        let t = textField.text
        textField.text = t?.safelyLimitedTo(length: maxLength)
    }
}
extension String
{
    func safelyLimitedTo(length n: Int)->String {
        if (self.count <= n) {
            return self
        }
        return String( Array(self).prefix(upTo: n) )
    }
}


