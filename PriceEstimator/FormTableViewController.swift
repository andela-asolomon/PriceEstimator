//
//  FormTableViewController.swift
//  PriceEstimator
//
//  Created by Ayoola Solomon on 1/16/15.
//  Copyright (c) 2015 Ayoola Solomon. All rights reserved.
//

import UIKit

class FormTableViewController: UITableViewController, EstimatorAPIProtocol {

    @IBOutlet weak var addressLabel: UITextField!
    @IBOutlet weak var zipCodeLabel: UITextField!
    
    var api : EstimatorAPI = EstimatorAPI()
    var searchResultsData : AnyObject = []
    var currency: String = ""
    
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
            
            var address: String = addressLabel.text
            var zipCode: Int = zipCodeLabel.text.toInt()!
            
            api.query(address, zipCode: zipCode)
            activityIndicator.startAnimating()
        }
    }
    
    func JSONAPIResults(results: AnyObject) {
        dispatch_async(dispatch_get_main_queue(), {
            self.searchResultsData = results
            self.currency = results["currency"] as String
            
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
        
        activityIndicator.center = self.view.center
        activityIndicator.color = UIColor(red: 255.0/255.0, green: 89.0/255.0, blue: 20.0/255.0, alpha: 1)
        activityIndicator.hidden = true
        self.view.addSubview(activityIndicator)
        
        self.navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little 
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "showOffer") {
            clearLabels()
            if self.searchResultsData.count != 0 {
                (segue.destinationViewController as OfferViewController).toPass = currency
            }
        }
    }
}
