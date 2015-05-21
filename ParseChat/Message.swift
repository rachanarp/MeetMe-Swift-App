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

class Message: NSObject {
    //Sometimes messages are sent by a user without text - these are just location updates for the user. 
    
    var text: String?
    var user: User?
    var destination: String? // Store the group destination in Message so it can be updated on the fly?
    
      static func initWithPFObjectArray(objects: [PFObject]) -> NSArray?{
        var messages = NSMutableArray()
        for object in objects {
            if let user : PFUser = object["user"] as? PFUser {
                var message = Message();
                message.user = User().initWithPFUser(user)
                message.user!.location = object["location"] as? String //TODO: convert to CLLocationCoordinate2D?
                message.text = object["text"] as? String
                message.destination = object["destination"] as? String
                if (nil == message.destination) {
                    message.destination = kDefaultMeetMeDestination
                }
                
                messages.addObject(message)
            }
        }

        return messages
    }

}