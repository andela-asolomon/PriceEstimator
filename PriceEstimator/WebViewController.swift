//
//  WebViewController.swift
//  FoodPin
//
//  Created by Ayoola Solomon on 1/12/15.
//  Copyright (c) 2015 AppCoda. All rights reserved.
//

import UIKit


class WebViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    var address: String?
    var zipCode: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        loadForm(zipCode!, address: address!)
        
    }
    
    func loadForm(zip : Int, address: String){
        let encodedTerm = (address as NSString).stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        
        let requestUrl = NSURL(string: "http://soldtoday.com/app/?sub=app&zip=\(zip)&address=\(encodedTerm)")
        let request = NSURLRequest(URL: requestUrl!)
        webView.loadRequest(request)
    }
    
    func webViewDidStartLoad(_: UIWebView) {
        activity.startAnimating()
    }
    
    func webViewDidFinishLoad(_: UIWebView) {
        activity.stopAnimating()
    }
    
}
