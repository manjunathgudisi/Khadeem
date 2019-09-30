//
//  BusyIndicator.swift
//  DieselApp
//
//  Created by Gudisi, Manjunath on 06/06/18.
//  Copyright © 2018 Narayan. All rights reserved.
//

import Foundation
import UIKit

class BusyIndicator: UIVisualEffectView {
    
    private static var busyIndicator : BusyIndicator? = nil
    static func showBusyIndicator(_ parentView: UIView) {
        if busyIndicator == nil {
            busyIndicator = BusyIndicator(text: "Loading...")
        }
        
        DispatchQueue.main.async {
            parentView.addSubview(busyIndicator!)
            parentView.isUserInteractionEnabled = false
            busyIndicator?.show()
        }

    }
    
    static func hideBusyIndicator() {
        busyIndicator?.superview?.isUserInteractionEnabled = true
        busyIndicator?.hide()
        busyIndicator?.removeFromSuperview()
    }
    
    var text: String? {
        didSet {
            label.text = text
        }
    }
    let activityIndictor: UIActivityIndicatorView = UIActivityIndicatorView(style: .white)
    let label: UILabel = UILabel()
    let blurEffect = UIBlurEffect(style: .light)
    let vibrancyView: UIVisualEffectView
    
    init(text: String) {
        self.text = text
        self.vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: blurEffect))
//        vibrancyView.backgroundColor = Branding.activityIndicatorBackGroundColor
        vibrancyView.backgroundColor = UIColor.yellow
        super.init(effect: blurEffect)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.text = ""
        self.vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: blurEffect))
        super.init(coder: aDecoder)
        self.setup()
    }
    
    func setup() {
        contentView.addSubview(vibrancyView)
        contentView.addSubview(activityIndictor)
        contentView.addSubview(label)
        activityIndictor.startAnimating()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if let superview = self.superview {
            
            let width = superview.frame.size.width / 2.3
            let height: CGFloat = 50.0
            self.frame = CGRect(x: superview.frame.size.width / 2 - width / 2,
                                y: superview.frame.height / 2 - height / 2,
                                width: 150,
                                height: 60)
            vibrancyView.frame = self.bounds
            
            let activityIndicatorSize: CGFloat = 40
//            activityIndictor.tintColor = Branding.orangeColor
            activityIndictor.frame = CGRect(x: 60,
                                            y: 0,
                                            width: activityIndicatorSize,
                                            height: activityIndicatorSize)
            
            layer.cornerRadius = 8.0
            layer.masksToBounds = true
            label.text = text
//            label.font = Branding.dinRegularFont()
            label.textAlignment = NSTextAlignment.center
            label.frame = CGRect(x: 0,
                                 y: 30,
                                 width: 150,
                                 height: 20)
            label.textColor = UIColor.white
            self.center = (self.superview?.center)!
        }
    }
    
    func show() {
        self.isHidden = false
    }
    
    func hide() {
        self.isHidden = true
    }
}
