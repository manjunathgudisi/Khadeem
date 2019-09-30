//
//  TextMessageViewController.swift
//  khaddem
//
//  Created by I0006 on 14/08/19.
//  Copyright © 2019 I0006. All rights reserved.
//

import UIKit

class TextMessageViewController: UIViewController {
    
    public var homeViewController : UIViewController? = nil

    //MARK:- IBOutlest
    @IBOutlet weak var subjectTextField: UITextField!
    @IBOutlet weak var enterMaessageTextView: UITextView!
    
    //MARK:- GolbalVariables
    var newImage: UIImage!
    var nameString: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        enterMaessageTextView.resignFirstResponder()
        let alert = UIAlertController(title: "Text message sent", message: "Your text message has been sent successfully", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.homeViewController?.navigationController?.popToRootViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        enterMaessageTextView.resignFirstResponder()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        enterMaessageTextView.resignFirstResponder()
    }
}
