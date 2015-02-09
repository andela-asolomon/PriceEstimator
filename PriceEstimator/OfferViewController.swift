//
//  OfferViewController.swift
//  PriceEstimator
//
//  Created by Ayoola Solomon on 1/19/15.
//  Copyright (c) 2015 Ayoola Solomon. All rights reserved.
//

import UIKit

class OfferViewController: UIViewController {
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var offerLabel: UILabel!
    @IBOutlet weak var btnLabel: UIButton!
    @IBOutlet weak var callBtn: UIButton!
    @IBOutlet weak var estimatedOfferByPercent: UILabel!
    
    @IBAction func callAction(sender: UIButton) {
        var alert = UIAlertController(title: "Call Us", message: "We'll tell you the Exact Cash Value of your home and make you an offer to buy it", preferredStyle: UIAlertControllerStyle.Alert)
        
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
    
    var address: String?
    var zipCode: Int?
    
    var offer: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Apply blurring effect
        var blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        var blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        backgroundImage.addSubview(blurEffectView)
        
        let roundUpOffer = roundUp(offer)
        let offerToString = String(Int(roundUpOffer))
        let result = convertToUSD(offerToString)
        offerLabel.text = "\(result)"
        
        let estimateByPercent = getSecondOffer(offer)
        let estimateByPercentToString = String(Int(estimateByPercent))
        let secondOffer = convertToUSD(estimateByPercentToString)
        estimatedOfferByPercent.text = secondOffer
        
        btnLabel.layer.cornerRadius = 4
        callBtn.layer.cornerRadius = 4
    }
    
    // MARK: - Converting the offer to USD
    func convertToUSD(var result: String) -> String {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        formatter.locale = NSLocale(localeIdentifier: "en_US")
        var numberFromField = (NSString(string: result).doubleValue)
        result = formatter.stringFromNumber(numberFromField)!.stringByDeletingPathExtension
        
        return result
    }
    
    
    // MARK: - Calculate the second offer based on the responsed offer from API
    func getSecondOffer(offer: Double) -> Double {
        let percentAdded = offer * 20/100
        let result = offer + percentAdded
        let ans = roundUp(result)
        return ans
    }
    
    func roundUp(offer: Double) -> Double {
        var roundedOffer = round(offer / 1000) * 1000
        return roundedOffer
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "passData") {
            if var data = segue.destinationViewController as? WebViewController {
                data.address = address!
                data.zipCode = zipCode!
            }
        }
    }

}
