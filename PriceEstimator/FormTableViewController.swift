//
//  FormTableViewController.swift
//  PriceEstimator
//
//  Created by Ayoola Solomon on 1/16/15.
//  Copyright (c) 2015 Ayoola Solomon. All rights reserved.
//

import UIKit

class FormTableViewController: UITableViewController {
    
    @IBOutlet weak var addressLabel: UITextField!
    @IBOutlet weak var zipCodeLabel: UITextField!
    
    var api = EstimatorAPI()
    
    @IBAction func checkItOutButton(sender: UIButton) {
        
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
            
            getEstimate()
            clearLabels()
            
        }
        
    }
    
    func getEstimate(){
        var address: String? = addressLabel.text
        var zipCode: Int? =  zipCodeLabel.text.toInt()
        
        api.query(address, zipCode: zipCode)
    }
    
    func clearLabels(){
        addressLabel.text = ""
        zipCodeLabel.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }

}
