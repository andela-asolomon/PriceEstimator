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
    
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        loadAddress()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadAddress(){
        let requestUrl = NSURL(string: "http://www.soldtoday.com")
        let request = NSURLRequest(URL: requestUrl!)
        webView.loadRequest(request)
    }
    
    func webViewDidStartLoad(_: UIWebView) {
        spinner.startAnimating()
    }
    
    func webViewDidFinishLoad(_: UIWebView) {
        spinner.stopAnimating()
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
