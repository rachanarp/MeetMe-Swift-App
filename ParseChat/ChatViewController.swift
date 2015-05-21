//
//  ChatViewController.swift
//  ParseChat
//
//  Created by Rachana Bedekar on 4/30/15.
//  Copyright (c) 2015 Rachana Bedekar. All rights reserved.
//

import UIKit


class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var messages = NSArray()

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var chatfield: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        //Start refreshing the chats
        timer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSend(sender: AnyObject) {
        
        var message = Message()
        message.text = chatfield.text
        ParseClient().sharedInstance.sendMessage(message)
        
     /*   var gameScore = PFObject(className:"Message")
        gameScore["text"] = chatfield.text
        gameScore["user"] = PFUser.currentUser()
        gameScore.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                // The object has been saved.
                println(gameScore["text"])
            } else {
                // There was a problem, check error.description
            }
        }*/
    }
    
    func queryMessages() {
        self.messages = ParseClient().sharedInstance.queryMessages()!
        self.tableView.reloadData()
    }
    
    
    func timer() {
        NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "queryMessages", userInfo: nil, repeats: true)
    }
    
    // MARK: UITableViewDataSource methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ChatCell", forIndexPath: indexPath) as! UITableViewCell
        
        var messageStr = ""
        let message = messages[indexPath.row] as! Message
        if (nil != message.text) {
            messageStr = message.text!
        }
        
        //TODO: use the location to show the friend's status
        var locationStr = ""
        if (nil != message.location) {
            locationStr = message.location!
        }
        cell.textLabel?.text = messageStr + " : " + locationStr
        return cell
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
