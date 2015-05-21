//
//  User.swift
//  ParseChat
//
//  Created by Rachana Bedekar on 5/20/15.
//  Copyright (c) 2015 Rachana Bedekar. All rights reserved.
//

import Foundation
import UIKit


let UserDidLoginNotification = "UserDidLoginNotification"
let UserDidLogoutNotification = "UserDidLogoutNotification"
let kCurrentUserKey = "currentUserName"
let kCurrentUserPassword = "currentUserPassword"

class User: NSObject{
    
    var name : String?
    var password : String?
    var location : String? //location of the message sender - will only be set in the context of a message
    
    static var currentUser : User? = nil
    
    
    func initWithPFUser(user: PFUser?) -> User?{
        if (nil != user)
        {
            self.name = user!.username
            self.password = user!.password
            return self
        }
        return nil
    }
    
    func initWith(name: String?, password: String?) -> User?{
        self.name = name
        self.password = password
        return self
    }
    
    static func getCurrentUser() -> User? {
        if (currentUser == nil) {
            var defaults = NSUserDefaults.standardUserDefaults()
            let userName: String? = (defaults.objectForKey(kCurrentUserKey) as? String)
            let password : String? = (defaults.objectForKey(kCurrentUserPassword) as? String)
            if (nil != userName && nil != password) {
                currentUser = User().initWith(userName, password: password)
            }
        }
        return currentUser
    }
    
    static func setCurrentUserWith(user : User?) {
        if (nil != currentUser) {
            NSUserDefaults.standardUserDefaults().setObject(currentUser?.name, forKey: kCurrentUserKey)
             NSUserDefaults.standardUserDefaults().setObject(currentUser?.password, forKey: kCurrentUserPassword)
        } else {
            NSUserDefaults.standardUserDefaults().setObject(user?.name, forKey: kCurrentUserKey)
            NSUserDefaults.standardUserDefaults().setObject(user?.password, forKey: kCurrentUserPassword)
        }
        if (nil == user) {
            NSUserDefaults.standardUserDefaults().removeObjectForKey(kCurrentUserKey)
            NSUserDefaults.standardUserDefaults().removeObjectForKey(kCurrentUserPassword)
        }
        NSUserDefaults.standardUserDefaults().synchronize()
    }
}
