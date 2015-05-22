//
//  Message.swift
//  ParseChat
//
//  Created by Rachana Bedekar on 5/20/15.
//  Copyright (c) 2015 Rachana Bedekar. All rights reserved.
//

import Foundation
import UIKit

let kDefaultMeetMeDestination = "1026 Valencia St, San Francisco, CA" //Ritual Coffee Roasters is the default meeting location
let kDefaultMeetMeGroupID = "RitualRoastersMeetMeGroup"

class Message: NSObject {
    //Sometimes messages are sent by a user without text - these are just location updates for the user. 
    
    var text: String?
    var user: User?
    var destination: String? // Store the group destination in Message so it can be updated on the fly?
    var groupID: String?
    var location: String?
    var myEvent: EventGroup?
    
      static func initWithPFObjectArray(objects: [PFObject]) -> NSArray?{
        //TODO : filter the list of object to only care for the MeetMe app ones
        var messages = NSMutableArray()
        var userslocation = NSMutableDictionary()
        for object in objects {
            if let user : PFUser = object["user"] as? PFUser {
                var message = Message()
                message.user = User().initWithPFUser(user)
                message.user!.location = object["location"] as? String //TODO: convert to CLLocationCoordinate2D?
                message.text = object["text"] as? String
                message.destination = object["destination"] as? String
                message.groupID = object["groupID"] as? String
                message.location = object["location"] as? String
                var evt = ParseClient.eventList.filter({ (event: EventGroup?) -> Bool in
                    event!.groupID == message.groupID
                }).first
                if (evt == nil) {
                    evt = EventGroup()
                    evt!.initWithId(message.groupID, dest: message.destination)
                    ParseClient.eventList.append(evt!)
                }
                message.myEvent = evt
                if let dest = message.myEvent!.destination {
                    message.destination = dest
                }
                
                if let username : String? = message.user!.name {
                    if (nil != (message as? Message)!.location) {
                        userslocation.setValue(message, forKey: username!)
                    }
                
                }
                
                if ( nil != message.text) {
                    messages.addObject(message)
                }

            }
        }
        
        for object in userslocation {
            messages.addObject(object.value)
        }

        return messages
        }

}