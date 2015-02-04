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
    
    var offer: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Apply blurring effect
        var blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        var blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        backgroundImage.addSubview(blurEffectView)
        
        
        var offerToString = String(offer)
        var result = convertToUSD(offerToString)
        offerLabel.text = "\(result)"
        
        btnLabel.layer.cornerRadius = 4
    }
    
    // MARK: - Converting the offer to USD
    func convertToUSD(var result: String) -> String {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        formatter.locale = NSLocale(localeIdentifier: "en_US")
        var numberFromField = (NSString(string: result).doubleValue)
        result = formatter.stringFromNumber(numberFromField)!
        
        return result
    }

}
