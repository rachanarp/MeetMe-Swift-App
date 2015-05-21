//
//  EventViewController.swift
//  ParseChat
//
//  Created by Rob Hislop on 5/20/15.
//  Copyright (c) 2015 Rachana Bedekar. All rights reserved.
//

import UIKit

class EventViewController: UIViewController {

    @IBOutlet weak var destinationTextField: UITextField!
    @IBAction func onSetDestination(sender: AnyObject) {
        destinationAddressString = destinationTextField.text
        self.navigationController?.popViewControllerAnimated(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        destinationTextField.text = destinationAddressString
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
