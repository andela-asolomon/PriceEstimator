//
//  FormTableViewController.swift
//  PriceEstimator
//
//  Created by Ayoola Solomon on 1/16/15.
//  Copyright (c) 2015 Ayoola Solomon. All rights reserved.
//

import UIKit

class FormTableViewController: UITableViewController, EstimatorAPIProtocol, UITextFieldDelegate {

    @IBOutlet weak var btnLabel: UIButton!
    @IBOutlet weak var addressLabel: UITextField!
    @IBOutlet weak var zipCodeLabel: UITextField!
    
    var connectionIsAvailable : Connectivity = Connectivity()
    
    var api : EstimatorAPI = EstimatorAPI()
    var searchResultsData : AnyObject = []
    var offer: Int?
    
    var address: String?
    var zipCode: Int?
    
    let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
    
    @IBAction func checkItOutButton(sender: UIButton) {
        
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
                addressLabel.resignFirstResponder()
                zipCode = zipCodeLabel.text.toInt()!
                zipCodeLabel.resignFirstResponder()
                
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
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        var result = true
        
        let prospectiveText = (textField.text as NSString).stringByReplacingCharactersInRange(range, withString: string)
        
        if countElements(string) > 0 {
            let inverseSet = NSCharacterSet(charactersInString: "0123456789").invertedSet
            let replaceStringIsLegal = string.rangeOfCharacterFromSet(inverseSet) == nil
            
            let resultingStringLengthIsLegal = countElements(prospectiveText) <= 5
            
            let components = string.componentsSeparatedByCharactersInSet(inverseSet)
            
            result = resultingStringLengthIsLegal && replaceStringIsLegal
        }
        
        return result
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
            message = "The Server encountered a temporary error and could not complete your request. Please try again later or contact our call center on (800)-288-0275."
        } else {
             message = "We could not find the estimate for the house you are looking for. Please contact our customer service for more info."
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
