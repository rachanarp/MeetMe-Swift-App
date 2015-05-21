//
//  Group.swift
//  ParseChat
//
//  Created by Rachana Bedekar on 5/21/15.
//  Copyright (c) 2015 Rachana Bedekar. All rights reserved.
//

import Foundation

class EventGroup: NSObject{
    var userslocation = NSMutableDictionary()
    var groupID : String?
    var destination : String?
    
    func initWithId(grpID: String!, loc: String!) {
        self.groupID = grpID
        self.destination = loc
    }
    
    func initWithMessages(messages : NSArray) {
     for message in messages {
        if let username : String? = (message as? Message)!.user!.name {
            if (nil != (message as? Message)!.location) {
                userslocation.setValue((message as? Message)!.location, forKey: username!)
            }
        }
     }
    }
    
    func getUsersLocations()-> NSDictionary {
        return userslocation
    }
}