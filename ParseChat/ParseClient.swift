//
//  ParseClient.swift
//  ParseChat
//
//  Created by Rachana Bedekar on 5/20/15.
//  Copyright (c) 2015 Rachana Bedekar. All rights reserved.
//

import Foundation

class ParseClient : NSObject {
    
    var lastMessagesCache = NSArray()
    
    var sharedInstance :ParseClient {
        struct Singleton {
            static let instance = ParseClient()// Parse.setApplicationId("DXsvTSLgsKT03gSSqy6V5KbLwVpgfEjmEsKzzQUP", clientKey: "BXAzmCJhMtIVWhLVEiKIMzPCA5XI0Nt9NwvAOPVd")
        }
        
        return Singleton.instance
    }

    func signUpWithEmail(username: String, password: String) {
        var user = PFUser()
        user.username = username
        user.email = username
        user.password = password
        // other fields can be set just like with PFObject
        
        user.signUpInBackgroundWithBlock {
            (suceeded, error) -> Void in
            if let error = error {
                let errorString = error.userInfo?["error"] as? NSString
                // Show the errorString somewhere and let the user try again.
                println(errorString)
            } else {
                // Hooray! Let them use the app now.
                // we might redirect them somewhere
                
            }
        }
    }
    
    
    func login() {
        var user = PFUser()
        if (nil != User.getCurrentUser())
        {
            user.username = User.getCurrentUser()?.name
            user.email = User.getCurrentUser()?.name
            user.password = User.getCurrentUser()?.password
            
            PFUser.logInWithUsernameInBackground(user.username!, password: user.password!) {
                (user: PFUser?, error: NSError?) -> Void in
                if user != nil {
                    // Do stuff after successful login.
                    var currUser = User().initWithPFUser(user)
                    currUser?.password = User.getCurrentUser()?.password
                    User.setCurrentUserWith(currUser)
                    
                    println("SIGNED IN")
                    NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: UserDidLoginNotification, object: nil))
                    
                } else {
                    // The login failed. Check error to see why.
                    println(error)
                    NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: UserDidLogoutNotification, object: nil))
                }
            }
            
        }
        else {
            NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: UserDidLogoutNotification, object: nil))
        }
    }
    
    func loginWithUsername( username: String, password: String) {
        PFUser.logInWithUsernameInBackground(username, password: password) {
            (user: PFUser?, error: NSError?) -> Void in
                if user != nil {
                    // Do stuff after successful login.
                    var currUser = User().initWithPFUser(user)
                    currUser?.password = password
                    User.setCurrentUserWith(currUser)
                    
                    println("SIGNED IN")
                    NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: UserDidLoginNotification, object: nil))
                   
                    
                } else {
                    // The login failed. Check error to see why.
                    println(error)
                    NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: UserDidLogoutNotification, object: nil))
                }
        }

    }

    func logout() {
        PFUser.logOutInBackgroundWithBlock { (error: NSError?) -> Void in
            if (nil != error) {
                println(error)
            }
            
            println ("Logged Out")
            
            User.setCurrentUserWith(nil)
            
            NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: UserDidLogoutNotification, object: nil))
        }
    }
    
     func queryMessages() -> NSArray? {
        var query = PFQuery(className:"Message")
        query.includeKey("user")
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                println("Successfully retrieved \(objects!.count) scores.")
                // Do something with the found objects
                
                if let objects = objects as? [PFObject] {
                    //cache the last set of messages
                    self.lastMessagesCache = Message.initWithPFObjectArray(objects)!
                }
            } else {
                // Log details of the failure
                println("Error: \(error!) \(error!.userInfo!)")
            }
        }
        return lastMessagesCache
    }
    
    func queryEvents(completion: ([EventGroup]) -> Void) {
        var query = PFQuery(className:"Message")
        query.includeKey("user")
        var out = [EventGroup]()
        var excluder = [String]()
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                println("Successfully retrieved \(objects!.count) scores.")
                // Do something with the found objects
                
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        var test = find(excluder, object["groupID"] as! String)
                        if (test == nil) {
                            excluder.append(object["groupID"] as! String)
                            var newEvt = EventGroup()
                            newEvt.initWithId(object["groupID"] as! String, loc: object["groupID"] as! String)
                            out.append(newEvt)
                        }
                    }
                }
                completion(out)
            } else {
                // Log details of the failure
                println("Error: \(error!) \(error!.userInfo!)")
            }
        }
    }
    
    func getMessageCache() -> NSArray {
        return lastMessagesCache
    }
    
    func sendMessage(message : Message) {
        var pfmessage = PFObject(className:"Message")
        
        if (nil != message.text){
           pfmessage["text"] = message.text
        }
        
        pfmessage["user"] = PFUser.currentUser()
        pfmessage["groupID"] = message.groupID
        if (nil != message.location){
            //This is just the location fix so prefix it with MeetME to make it easy to find in the list.
            pfmessage["location"] = message.location!
        }
        pfmessage.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                // The object has been saved.
                println(pfmessage["text"])
            } else {
                // There was a problem, check error.description
            }
        }
    }

}