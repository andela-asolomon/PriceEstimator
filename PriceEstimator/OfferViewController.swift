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
    
    var toPass: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Apply blurring effect
        var blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        var blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        backgroundImage.addSubview(blurEffectView)
        
        offerLabel.text = self.toPass
    }
}
