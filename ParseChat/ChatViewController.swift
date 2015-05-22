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
    var myEvent: EventGroup?

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var chatfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 70
        
        //Start refreshing the chats
        timer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func queryMessages() {
        self.messages = ParseClient().sharedInstance.queryMessages()!
        var out = [Message]()
        for message in self.messages {
            if let msg = message as? Message {
                if msg.groupID == self.myEvent!.groupID {
                    out.append(msg)
                }
            }
        }
        self.messages = out
        self.tableView.reloadData()
    }
    
    
    func timer() {
        NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "queryMessages", userInfo: nil, repeats: true)
    }
    
    // MARK: UITableViewDataSource methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ChatCell", forIndexPath: indexPath) as! MessageTableViewCell
        
        
        let message = self.messages[indexPath.row] as! Message
        
        cell.updateWithMessage(message)
        
        return cell
    }

    @IBAction func onSent(sender: AnyObject) {
        var message = Message()
        message.text = chatfield.text
        message.groupID = myEvent?.groupID
        message.user = User.currentUser
        message.destination = myEvent?.destination
        ParseClient().sharedInstance.sendMessage(message)
        queryMessages()
        chatfield.text = ""
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
