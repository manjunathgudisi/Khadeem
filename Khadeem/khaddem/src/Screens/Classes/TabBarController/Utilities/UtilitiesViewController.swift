//
//  UtilitiesViewController.swift
//  khaddem
//
//  Created by I0006 on 14/08/19.
//  Copyright © 2019 I0006. All rights reserved.
//

import UIKit
import Foundation

class UtilitiesViewController: UIViewController {

    //MARK:- IBOutlet
    @IBOutlet weak var gradientUIView: UIView!
    @IBOutlet weak var textButton: UIButton!
    @IBOutlet weak var voiceButton: UIButton!
    @IBOutlet weak var videoButton: UIButton!
    @IBOutlet weak var avatarButton: UIButton!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var voiceLabel: UILabel!
    @IBOutlet weak var videoLabel: UILabel!
    @IBOutlet weak var avatarLabel: UILabel!
    @IBOutlet weak var shadowUIView: UIView!
    @IBOutlet weak var viewControllersUIView: UIView!
    
    //MARK:- GolbalVariables
    private var gradientView : UIView? = nil
    var newImage: UIImage!
    var nameString: String!
    var isTextButtonSelect = false
    var isVoiceButtonSelect = false
    var isVideoButtonSelect = false
    var isAvatarButtonSelect = false
    var selectedTextColor = UIColor(red: 230.0/255.0, green: 126.0/255.0, blue: 34.0/255.0, alpha: 1.0)
    var unSelectedTextColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0)
    var textMessageViewController: TextMessageViewController? = nil
    var voiceMessageViewController: VoiceMessageViewController? = nil
    var videoMessageViewController: VideoMessageViewController? = nil
    var avatarMessageViewController: AvatarMessageViewController? = nil
    
    private var shadowLayer: CAShapeLayer!
    private var cornerRadius: CGFloat = 1.0
    private var fillColor: UIColor = .white //
    
    //MARK:- ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        shadowUIView.layer.cornerRadius = 0.0
//        shadowUIView.layer.shadowColor = UIColor.black.cgColor
//        shadowUIView.layer.shadowOffset = .zero
//        shadowUIView.layer.shadowOpacity = 0.6
//        shadowUIView.layer.shadowRadius = 0.5
//        shadowUIView.layer.shadowPath = UIBezierPath(rect: shadowUIView.bounds).cgPath
//        shadowUIView.layer.shouldRasterize = true

        showTextMessageViewController()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    //MARK:- IBActions
    @IBAction func textButtonTapped(_ sender: Any) {
        showTextMessageViewController()
    }
    
    @IBAction func voiceButtonTapped(_ sender: Any) {
        showVoiceMessageViewController()
    }
    
    @IBAction func videoButtonTapped(_ sender: Any) {
        showVideoMessageViewController()
    }
    
    @IBAction func avatarButtonTapped(_ sender: Any) {
        showAvatarMessageViewController()
    }
}

// MARK:- Functions
extension UtilitiesViewController {
    
    func showTextMessageViewController() {
        
        isTextButtonSelect = true
        isVoiceButtonSelect = false
        isVideoButtonSelect = false
        isAvatarButtonSelect = false
        textLabel.textColor = selectedTextColor
        voiceLabel.textColor = unSelectedTextColor
        videoLabel.textColor = unSelectedTextColor
        avatarLabel.textColor = unSelectedTextColor
        textButton.isSelected = true
        voiceButton.isSelected = false
        videoButton.isSelected = false
        avatarButton.isSelected = false
        
        if (self.textMessageViewController == nil) {
            
            let vc = UIStoryboard(name: "TextMessage", bundle: nil).instantiateViewController(withIdentifier: "TextMessageViewController") as! TextMessageViewController
            vc.newImage = newImage
            vc.nameString = nameString
            self.textMessageViewController = vc
            self.textMessageViewController?.homeViewController = self
        }
        var frame = self.viewControllersUIView.frame
        frame.origin.x = 0
        frame.origin.y = 0
        textMessageViewController?.view.frame = frame
        self.viewControllersUIView.addSubview(textMessageViewController!.view)
    }
    
    func showVoiceMessageViewController() {
        
        isVoiceButtonSelect = false
        isVoiceButtonSelect = true
        isVideoButtonSelect = false
        isAvatarButtonSelect = false
        textLabel.textColor = unSelectedTextColor
        voiceLabel.textColor = selectedTextColor
        videoLabel.textColor = unSelectedTextColor
        avatarLabel.textColor = unSelectedTextColor
        textButton.isSelected = false
        voiceButton.isSelected = true
        videoButton.isSelected = false
        avatarButton.isSelected = false
        
        if (self.voiceMessageViewController == nil) {
            
            let vc = UIStoryboard(name: "VoiceMessage", bundle: nil).instantiateViewController(withIdentifier: "VoiceMessageViewController") as! VoiceMessageViewController
            vc.newImage = newImage
            vc.nameString = nameString
            self.voiceMessageViewController = vc
            self.voiceMessageViewController?.homeViewController = self
        }
        var frame = self.viewControllersUIView.frame
        frame.origin.x = 0
        frame.origin.y = 0
        voiceMessageViewController?.view.frame = frame
        self.viewControllersUIView.addSubview(voiceMessageViewController!.view)
    }
    
    func showVideoMessageViewController() {
        
        isVideoButtonSelect = false
        isVoiceButtonSelect = false
        isVideoButtonSelect = true
        isAvatarButtonSelect = false
        textLabel.textColor = unSelectedTextColor
        voiceLabel.textColor = unSelectedTextColor
        videoLabel.textColor = selectedTextColor
        avatarLabel.textColor = unSelectedTextColor
        textButton.isSelected = false
        voiceButton.isSelected = false
        videoButton.isSelected = true
        avatarButton.isSelected = false
        
        if (self.videoMessageViewController == nil) {
            
            let vc = UIStoryboard(name: "VideoMessage", bundle: nil).instantiateViewController(withIdentifier: "VideoMessageViewController") as! VideoMessageViewController
            vc.newImage = newImage
            vc.nameString = nameString
            self.videoMessageViewController = vc
            self.videoMessageViewController?.homeViewController = self
        }
        var frame = self.viewControllersUIView.frame
        frame.origin.x = 0
        frame.origin.y = 0
        videoMessageViewController?.view.frame = frame;
        self.viewControllersUIView.addSubview(videoMessageViewController!.view)
    }
    
    func showAvatarMessageViewController() {
        
        isAvatarButtonSelect = false
        isVoiceButtonSelect = false
        isVideoButtonSelect = false
        isAvatarButtonSelect = true
        textLabel.textColor = unSelectedTextColor
        voiceLabel.textColor = unSelectedTextColor
        videoLabel.textColor = unSelectedTextColor
        avatarLabel.textColor = selectedTextColor
        textButton.isSelected = false
        voiceButton.isSelected = false
        videoButton.isSelected = false
        avatarButton.isSelected = true
        
        if (self.avatarMessageViewController == nil) {
            
            let vc = UIStoryboard(name: "AvatarMessage", bundle: nil).instantiateViewController(withIdentifier: "AvatarMessageViewController") as! AvatarMessageViewController
            vc.newImage = newImage
            vc.nameString = nameString
            self.avatarMessageViewController = vc
            self.avatarMessageViewController?.homeViewController = self
        }
        var frame = self.viewControllersUIView.frame
        frame.origin.x = 0
        frame.origin.y = 0
        avatarMessageViewController?.view.frame = frame;
        self.viewControllersUIView.addSubview(avatarMessageViewController!.view)
    }
}
