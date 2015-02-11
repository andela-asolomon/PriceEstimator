//
//  KeyboardAnimation.swift
//  Cash In Home
//
//  Created by Ayoola Solomon on 2/11/15.
//  Copyright (c) 2015 Ayoola Solomon. All rights reserved.
//

import Foundation
import UIKit

private var scrollViewKey : UInt8 = 0

class KeyboardAnimation: UIViewController {
}

extension UIViewController {
    
    func setupKeyboardNotifcationListenerForScrollView(scrollView: UIScrollView) {
        println(scrollView)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        internalScrollView = scrollView
    }
    
    func removeKeyboardNotificationListeners() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    private var internalScrollView: UIScrollView! {
        get {
            return objc_getAssociatedObject(self, &scrollViewKey) as? UIScrollView
        }
        set(newValue) {
            objc_setAssociatedObject(self, &scrollViewKey, newValue, UInt(OBJC_ASSOCIATION_ASSIGN))
        }
    }
    
    func keyboardWillShow(notification: NSNotification) {
        let userInfo = notification.userInfo as Dictionary<String, AnyObject>
        let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as NSTimeInterval
        let animationCurve = userInfo[UIKeyboardAnimationCurveUserInfoKey]!.intValue
        let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue()
        let keyboardFrameConvertedToViewFrame = view.convertRect(keyboardFrame!, fromView: nil)
        let curveAnimationOption = UIViewAnimationOptions(UInt(animationCurve))
        let options = UIViewAnimationOptions.BeginFromCurrentState | curveAnimationOption
        UIView.animateWithDuration(animationDuration, delay: 0, options:options, animations: { () -> Void in
            let insetHeight = (self.internalScrollView.frame.height + self.internalScrollView.frame.origin.y) - keyboardFrameConvertedToViewFrame.origin.y
            self.internalScrollView.contentInset = UIEdgeInsetsMake(0, 0, insetHeight, 0)
            self.internalScrollView.scrollIndicatorInsets  = UIEdgeInsetsMake(0, 0, insetHeight, 0)
            }) { (complete) -> Void in
        }
    }
    
    func keyboardWillHide(notification:NSNotification) {
        let userInfo = notification.userInfo as Dictionary<String, AnyObject>
        let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as NSTimeInterval
        let animationCurve = userInfo[UIKeyboardAnimationCurveUserInfoKey]!.intValue
        let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue()
        let keyboardFrameConvertedToViewFrame = view.convertRect(keyboardFrame!, fromView: nil)
        let curveAnimationOption = UIViewAnimationOptions(UInt(animationCurve))
        let options = UIViewAnimationOptions.BeginFromCurrentState | curveAnimationOption
        UIView.animateWithDuration(animationDuration, delay: 0, options:options, animations: { () -> Void in
            self.internalScrollView.contentInset = UIEdgeInsetsMake(0, 0,0 , 0)
            self.internalScrollView.scrollIndicatorInsets  = UIEdgeInsetsMake(0, 0, 0, 0)
            }) { (complete) -> Void in
        }
    }
}
