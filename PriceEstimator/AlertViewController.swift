//
//  AlertViewController.swift
//  PriceEstimator
//
//  Created by Ayoola Solomon on 2/11/15.
//  Copyright (c) 2015 Ayoola Solomon. All rights reserved.
//

import UIKit

class AlertViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func statusCodeAlert(){
        var alert = UIAlertController(title: "Oops", message: "We could not find the estimate for the house you are looking for. Please contact our customer service for more info.", preferredStyle: UIAlertControllerStyle.Alert)
        
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
    
    func zeroOffer(){
        var alert = UIAlertController(title: "Whoops", message: "We could not perform your operation right at the moment. Please try again or contact our call center at (800)-288-0275 ", preferredStyle: UIAlertControllerStyle.Alert)
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
