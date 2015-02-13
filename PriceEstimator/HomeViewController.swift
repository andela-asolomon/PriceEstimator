//
//  HomeViewController.swift
//  Cash In Home
//
//  Created by Ayoola Solomon on 2/11/15.
//  Copyright (c) 2015 Ayoola Solomon. All rights reserved.
//

import Foundation
import UIKit

class HomeViewController: UIViewController, EstimatorAPIProtocol, UITextFieldDelegate {

    @IBOutlet weak var btnLabel: UIButton!
    @IBOutlet weak var addressLabel: UITextField!
    @IBOutlet weak var zipCodeLabel: UITextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    var connectionIsAvailable : Connectivity = Connectivity()
    
    var animateDistance = CGFloat()
    
    var api : EstimatorAPI = EstimatorAPI()
    var searchResultsData : AnyObject = []
    var offer: Int?
    
    var address: String?
    var zipCode: Int?
    
    let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
    
    @IBAction func checkItOutButton(sender: UIButton) {
        
        view.endEditing(true)
        var errorField = ""
        
        if addressLabel.text == "" {
            errorField = "Address"
        } else if zipCodeLabel.text == "" {
            errorField = "Zip Code"
        }
        
        if errorField != "" {
            activityIndicator.stopAnimating()
            var alert = UIAlertController(title: "Oops", message: "We can't proceed as you forgot to fill in your \(errorField). All fields are mandatory.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
        } else {
            
            if connectionIsAvailable.isConnectedToNetwork() {
                address = addressLabel.text
                zipCode = zipCodeLabel.text.toInt()!
                
                api.query(address!, zipCode: zipCode!)
                activityIndicator.startAnimating()
                
            } else {
                var alert = UIAlertController(title: "Oops", message: "Internet Connection is not enabled. Please go to settings", preferredStyle: UIAlertControllerStyle.Alert)
                
                var settingsAction = UIAlertAction(title: "Settings", style: .Default) { (_) -> Void in
                    let settingsUrl = NSURL(string: UIApplicationOpenSettingsURLString)
                    if let url = settingsUrl {
                        UIApplication.sharedApplication().openURL(url)
                    }
                }
                
                alert.addAction(settingsAction)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    func JSONAPIResults(results: AnyObject) {
        dispatch_async(dispatch_get_main_queue(), {
            self.offer = Int(results as NSNumber)
            self.performSegueWithIdentifier("showOffer", sender: nil)
        })
    }
    
    
    func clearLabels(){
        addressLabel.text = ""
        zipCodeLabel.text = ""
        activityIndicator.stopAnimating()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.api.delegate = self
        
        zipCodeLabel.delegate = self
        addressLabel.delegate = self
        
        activityIndicator.center = self.view.center
        activityIndicator.color = UIColor(red: 255.0/255.0, green: 89.0/255.0, blue: 20.0/255.0, alpha: 1)
        activityIndicator.hidden = true
        self.view.addSubview(activityIndicator)
        
        self.navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        
        btnLabel.layer.cornerRadius = 4
        
    }
    
    func statusCodeAlert(){
        
        activityIndicator.stopAnimating()
        
        var message = ""
        
        if self.offer! == 0 {
            
            message = "We could not find the cash value for the property you are looking for. Please contact our customer service on (800)-288-0275 for more info."
        } else {
            message = "The Server encountered a temporary error and could not complete your request. Please try again later or contact our call center on (800)-288-0275."
        }
        
        var alert = UIAlertController(title: "Oops", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        var callAction = UIAlertAction(title: "(800)-288-0275", style: .Default) { (_) -> Void in
            
            let phone = "tel://(800)-288-0275";
            let settingsUrl = NSURL(string: phone)
            if let url = settingsUrl {
                UIApplication.sharedApplication().openURL(url)
            }
        }
        
        alert.addAction(callAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "showOffer") {
            if let svc = segue.destinationViewController as? OfferViewController {
                if self.offer! == StatusCode.internalServerError {
                    statusCodeAlert()
                } else if self.offer == nil {
                    statusCodeAlert()
                } else if self.offer! == 0 {
                    clearLabels()
                    statusCodeAlert()
                } else {
                    clearLabels()
                    svc.offer = Double(self.offer!)
                    svc.zipCode = zipCode!
                    svc.address = address!
                }
            }
        }
    }
}

// MARK: - Extend HomeViewController

extension HomeViewController {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        addressLabel.resignFirstResponder()
        zipCodeLabel.resignFirstResponder()
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        var result = true
        
        let prospectiveText = (textField.text as NSString).stringByReplacingCharactersInRange(range, withString: string)
        
        if textField == zipCodeLabel {
            if countElements(string) > 0 {
                let inverseSet = NSCharacterSet(charactersInString: "0123456789").invertedSet
                let replaceStringIsLegal = string.rangeOfCharacterFromSet(inverseSet) == nil
                
                let resultingStringLengthIsLegal = countElements(prospectiveText) <= 5
                
                let components = string.componentsSeparatedByCharactersInSet(inverseSet)
                
                result = resultingStringLengthIsLegal && replaceStringIsLegal
            }
        }
        
        return result
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        let textFieldRect : CGRect = self.view.window!.convertRect(textField.bounds, fromView: textField)
        let viewRect : CGRect = self.view.window!.convertRect(self.view.bounds, fromView: self.view)
        
        let midline : CGFloat = textFieldRect.origin.y + 0.5 * textFieldRect.size.height
        let numerator : CGFloat = midline - viewRect.origin.y - MoveKeyboard.MINIMUM_SCROLL_FRACTION * viewRect.size.height
        let denominator : CGFloat = (MoveKeyboard.MAXIMUM_SCROLL_FRACTION - MoveKeyboard.MINIMUM_SCROLL_FRACTION) * viewRect.size.height
        var heightFraction : CGFloat = numerator / denominator
        
        if heightFraction < 0.0 {
            heightFraction = 0.0
        } else if heightFraction > 1.0 {
            heightFraction = 1.0
        }
        
        let orientation : UIInterfaceOrientation = UIApplication.sharedApplication().statusBarOrientation
        if (orientation == UIInterfaceOrientation.Portrait || orientation == UIInterfaceOrientation.PortraitUpsideDown) {
            animateDistance = floor(MoveKeyboard.PORTRAIT_KEYBOARD_HEIGHT * heightFraction)
        } else {
            animateDistance = floor(MoveKeyboard.LANDSCAPE_KEYBOARD_HEIGHT * heightFraction)
        }
        
        var viewFrame : CGRect = self.view.frame
        viewFrame.origin.y -= animateDistance
        
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(NSTimeInterval(MoveKeyboard.KEYBOARD_ANIMATION_DURATION))
        
        self.view.frame = viewFrame
        
        UIView.commitAnimations()
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        var viewFrame : CGRect = self.view.frame
        viewFrame.origin.y += animateDistance
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        
        UIView.setAnimationDuration(NSTimeInterval(MoveKeyboard.KEYBOARD_ANIMATION_DURATION))
        
        self.view.frame = viewFrame
        
        UIView.commitAnimations()

    }
}
