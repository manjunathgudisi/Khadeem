//
//  Animations.swift
//  DieselApp
//
//  Created by Gudisi, Manjunath on 03/06/18.
//  Copyright © 2018 Narayan. All rights reserved.
//

import Foundation
import UIKit

//shake animation: http://stackoverflow.com/questions/27987048/shake-animation-for-uitextfield-uiview-in-swift
public extension UIView {
    
    func shake(count : Float? = nil,for duration : TimeInterval? = nil,withTanslation translation : Float? = nil) {
        let animation : CABasicAnimation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        
        animation.repeatCount = count ?? 2
        animation.duration = (duration ?? 0.5)/TimeInterval(animation.repeatCount)
        animation.autoreverses = true
        animation.byValue = translation ?? -5
        layer.add(animation, forKey: "shake")
    }
}

//rotate: https://www.andrewcbancroft.com/2014/10/15/rotate-animation-in-swift/
extension UIView {
    func rotate360Degrees(duration: CFTimeInterval = 1.0, completionDelegate: AnyObject? = nil) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(Double.pi * 2.0)
        rotateAnimation.duration = duration
        
        if let delegate: AnyObject = completionDelegate {
            rotateAnimation.delegate = delegate as? CAAnimationDelegate
        }
        self.layer.add(rotateAnimation, forKey: nil)
    }
}

//zoom http://stackoverflow.com/questions/31320819/scale-uibutton-animation-swift
extension UIView {
    
    func stopAnimation() {
        transform = CGAffineTransform.identity
    }
    
    /**
     Simply zooming in of a view: set view scale to 0 and zoom to Identity on 'duration' time interval.
     - parameter duration: animation duration
     */
    func zoomIn(duration: TimeInterval = 0.5) {
        self.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        UIView.animate(withDuration: duration, delay: 0.0, options: [.curveLinear], animations: { () -> Void in
            self.transform = CGAffineTransform.identity
        }) { (animationCompleted: Bool) -> Void in
        }
    }
    
    /**
     Simply zooming out of a view: set view scale to Identity and zoom out to 0 on 'duration' time interval.
     - parameter duration: animation duration
     */
    func zoomOut(duration: TimeInterval = 0.5) {
        self.transform = CGAffineTransform.identity
        UIView.animate(withDuration: duration, delay: 0.0, options: [.curveLinear], animations: { () -> Void in
            self.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        }) { (animationCompleted: Bool) -> Void in
        }
    }
    
    /**
     Zoom in any view with specified offset magnification.
     - parameter duration:     animation duration.
     - parameter easingOffset: easing offset.
     */
    func zoomInWithEasing(duration: TimeInterval = 0.3, easingOffset: CGFloat = 0.2) {
        let easeScale = 1.0 + easingOffset
        let easingDuration = TimeInterval(easingOffset) * duration / TimeInterval(easeScale)
        let scalingDuration = duration - easingDuration
        UIView.animate(withDuration: scalingDuration, delay: 0.0, options: .curveEaseIn, animations: { () -> Void in
            self.transform = CGAffineTransform(scaleX: easeScale, y: easeScale)
        }, completion: { (completed: Bool) -> Void in
            UIView.animate(withDuration: easingDuration, delay: 0.0, options: .curveEaseOut, animations: { () -> Void in
                self.transform = CGAffineTransform.identity
            }, completion: { (completed: Bool) -> Void in
            })
        })
    }
    
    /**
     Zoom out any view with specified offset magnification.
     - parameter duration:     animation duration.
     - parameter easingOffset: easing offset.
     */
    func zoomOutWithEasing(duration: TimeInterval = 0.3, easingOffset: CGFloat = 0.2) {
        let easeScale = 1.0 + easingOffset
        let easingDuration = TimeInterval(easingOffset) * duration / TimeInterval(easeScale)
        let scalingDuration = duration - easingDuration
        UIView.animate(withDuration: easingDuration, delay: 0.0, options: .curveEaseOut, animations: { () -> Void in
            self.transform = CGAffineTransform(scaleX: easeScale, y: easeScale)
        }, completion: { (completed: Bool) -> Void in
            UIView.animate(withDuration: scalingDuration, delay: 0.0, options: .curveEaseOut, animations: { () -> Void in
                self.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
            }, completion: { (completed: Bool) -> Void in
            })
        })
    }
    
}

extension UIViewController {
    
//  
//    func stopAnimationViewController() {
//        transform = CGAffineTransform.identity
//    }
//    
//    /**
//     Simply zooming in of a view: set view scale to 0 and zoom to Identity on 'duration' time interval.
//     - parameter duration: animation duration
//     */
//    func zoomInViewController(duration: TimeInterval = 0.5) {
//        self.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
//        UIView.animate(withDuration: duration, delay: 0.0, options: [.curveLinear], animations: { () -> Void in
//            self.transform = CGAffineTransform.identity
//        }) { (animationCompleted: Bool) -> Void in
//        }
//    }
//    
//    /**
//     Simply zooming out of a view: set view scale to Identity and zoom out to 0 on 'duration' time interval.
//     - parameter duration: animation duration
//     */
//    func zoomOutViewController(duration: TimeInterval = 0.5) {
//        self.transform = CGAffineTransform.identity
//        UIView.animate(withDuration: duration, delay: 0.0, options: [.curveLinear], animations: { () -> Void in
//            self.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
//        }) { (animationCompleted: Bool) -> Void in
//        }
//    }
//    
//    /**
//     Zoom in any view with specified offset magnification.
//     - parameter duration:     animation duration.
//     - parameter easingOffset: easing offset.
//     */
//    func zoomInWithEasingViewController(duration: TimeInterval = 0.3, easingOffset: CGFloat = 0.2) {
//        let easeScale = 1.0 + easingOffset
//        let easingDuration = TimeInterval(easingOffset) * duration / TimeInterval(easeScale)
//        let scalingDuration = duration - easingDuration
//        UIView.animate(withDuration: scalingDuration, delay: 0.0, options: .curveEaseIn, animations: { () -> Void in
//            self.transform = CGAffineTransform(scaleX: easeScale, y: easeScale)
//        }, completion: { (completed: Bool) -> Void in
//            UIView.animate(withDuration: easingDuration, delay: 0.0, options: .curveEaseOut, animations: { () -> Void in
//                self.transform = CGAffineTransform.identity
//            }, completion: { (completed: Bool) -> Void in
//            })
//        })
//    }
//    
//    /**
//     Zoom out any view with specified offset magnification.
//     - parameter duration:     animation duration.
//     - parameter easingOffset: easing offset.
//     */
//    func zoomOutWithEasingViewController(duration: TimeInterval = 0.3, easingOffset: CGFloat = 0.2) {
//        let easeScale = 1.0 + easingOffset
//        let easingDuration = TimeInterval(easingOffset) * duration / TimeInterval(easeScale)
//        let scalingDuration = duration - easingDuration
//        UIView.animate(withDuration: easingDuration, delay: 0.0, options: .curveEaseOut, animations: { () -> Void in
//            self.transform = CGAffineTransform(scaleX: easeScale, y: easeScale)
//        }, completion: { (completed: Bool) -> Void in
//            UIView.animate(withDuration: scalingDuration, delay: 0.0, options: .curveEaseOut, animations: { () -> Void in
//                self.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
//            }, completion: { (completed: Bool) -> Void in
//            })
//        })
//    }
}
