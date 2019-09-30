//
//  BaseViewController.swift
//  GSRTC
//
//  Created by Manjunath Gudisi on 4/20/17.
//  Copyright © 2017 Sreekanth Gudisi. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

import UIKit
import NVActivityIndicatorView

class BaseViewController: UIViewController {
    
    var hidenavigationbar = false
    var hidebackButton = false // to hide naviagtion button
    var showclosebutton = false // to close the controller
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.isHidden = false
        self.initialCall()
    }
    
    //        override func viewWillAppear(_ animated: Bool) {
    //            super.viewWillAppear(animated)
    //            self.customiseCall()
    //
    //            if let nav = self.navigationController {
    //                nav.isNavigationBarHidden = self.hidenavigationbar
    //            }
    //
    //            self.navigationItem.hidesBackButton = self.hidebackButton
    //
    //            if self.showclosebutton {
    //                self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Close", style: .done, target: self, action: #selector(closeButtonCliked))
    //            } else {
    //                self.navigationItem.rightBarButtonItem = nil
    //            }
    //        }
    
    // @mthod: to initialise and preload the view
    func initialCall(){
        
    }
    //
    //    // @mthod: to customise the view
    //    func customiseCall() {
    //
    //    }
    
    // @mthod: close button clicked
    func closeButtonCliked() {
        self.dismiss(animated: true, completion: nil)
    }
    
    //    // to get the navigation controlller
    //    func getNavigationController(_ controller:UIViewController)->UINavigationController {
    //        let navigation = UINavigationController(rootViewController: controller)
    //        /*navigation.navigationBar.barTintColor = self.navigationController?.navigationBar.barTintColor
    //        navigation.navigationBar.barStyle = (self.navigationController?.navigationBar.barStyle)!
    //        navigation.navigationBar.titleTextAttributes = self.navigationController?.navigationBar.titleTextAttributes
    //        navigation.navigationBar.tintColor = self.navigationController?.navigationBar.tintColor
    //        navigation.navigationBar.isTranslucent = (self.navigationController?.navigationBar.isTranslucent)!*/
    //        return navigation
    //    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showAlert(title: String?, message: String?, button1Title: String?, button2Title: String?) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if (button1Title != nil) {
            controller.addAction(UIAlertAction(title: button1Title, style: .default, handler: { (action:UIAlertAction) in
                self.button1Action();
            }))
        }
        if (button2Title != nil) {
            controller.addAction(UIAlertAction(title: button2Title, style: .default, handler: { (action:UIAlertAction) in
                self.button2Action();
            }))
        }
        //let vc : UIViewController = (self.view.window?.rootViewController)!
        self.present(controller, animated: true, completion: nil)
    }
    
    func button1Action() {}
    func button2Action() {}
    
    @IBAction func navigationPopview(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func dismissPresentedview(_ sender: Any) {
        self.dismiss(animated: true) {
            //nothing
        }
    }
}

// MARK: Loading indicators
extension BaseViewController {
    
    // @method: to show the loading indicator
    func showLoadingIndicator() {
        let activitydata = ActivityData(size: CGSize(width: 40, height: 40),
                                        message: "Please wait",
                                        type: NVActivityIndicatorType.ballScaleRippleMultiple,
                                        color: UIColor.white,
                                        padding: 10.0,
                                        displayTimeThreshold: nil,
                                        minimumDisplayTime: nil)
        
        let indicator = NVActivityIndicatorPresenter.sharedInstance
        indicator.startAnimating(activitydata, nil)
    }
    
    // @method: to hide the loading indicator
    func hideLoadingIndicator() {
        let indicator = NVActivityIndicatorPresenter.sharedInstance
        indicator.stopAnimating(nil)
    }
}

//web service consumption exceptions
extension BaseViewController {
    func parseResponseDataForException(dict : [AnyHashable : Any]?) -> Bool {
        
        let exception : String? = dict?["Exception"] as? String;
        if (exception == nil) {
            return false
        }
        
        self.showAlert(title: "Exception", message: exception, button1Title: "OK", button2Title: nil)
        return true;
    }
}
