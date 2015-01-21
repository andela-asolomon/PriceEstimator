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
    
    @IBAction func checkItOutButton(sender: UIButton) {
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        var errorFied = ""
        
        if addressLabel.text == "" {
            errorFied = "Address"
        } else if zipCodeLabel.text == "" {
            errorFied = "Zip Code"
        }
        
        if errorFied != "" {
            var alert = UIAlertController(title: "Oops", message: "We can't proceed as you forgot to fill in your \(errorFied). All fields are mandatory.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
        } else {
            
            var address: String? = addressLabel.text
            var zipCode: Int? =  zipCodeLabel.text.toInt()
            
            api.query(address!, zipCode: zipCode!)
        }
    }
    
    func JSONAPIResults(results: AnyObject) {
        dispatch_async(dispatch_get_main_queue(), {
            self.searchResultsData = results
        })
    }
    
    func clearLabels(){
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        
        addressLabel.text = ""
        zipCodeLabel.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.api.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little 
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "showOffer") {
            var Ans = "Ayoola"
            let svc = segue.destinationViewController as OfferViewController
            svc.numb = Ans
        }
    }
}
