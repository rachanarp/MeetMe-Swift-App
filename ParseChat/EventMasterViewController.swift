//
//  EventMasterViewController.swift
//  ParseChat
//
//  Created by Yale Thomas on 5/21/15.
//  Copyright (c) 2015 Rachana Bedekar. All rights reserved.
//

import UIKit

class EventMasterViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var events: [EventGroup]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        ParseClient().sharedInstance.queryEvents({ (eventArr: [EventGroup]) -> Void in
            self.events = eventArr
            self.tableView.reloadData()
        })

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    


}
extension EventMasterViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("evtCell") as! EventTableViewCell
        var myEvent = self.events?[indexPath.row]
        cell.updateWithEvent(myEvent!)
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let num = self.events?.count {
            return num
        }
        return 0
    }
}
