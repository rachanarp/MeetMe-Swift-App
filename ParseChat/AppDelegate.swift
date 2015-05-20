//
//  AppDelegate.swift
//  ParseChat
//
//  Created by Rachana Bedekar on 4/30/15.
//  Copyright (c) 2015 Rachana Bedekar. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        Parse.setApplicationId("DXsvTSLgsKT03gSSqy6V5KbLwVpgfEjmEsKzzQUP", clientKey: "BXAzmCJhMtIVWhLVEiKIMzPCA5XI0Nt9NwvAOPVd")
        
        defaultLogin()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:("userDidLogin"), name: UserDidLoginNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:("userDidLogout"), name: UserDidLogoutNotification, object: nil)
        
        return true
    }
    
    func defaultLogin() {
        var user = PFUser()
        if (nil != User.getCurrentUser())
        {
        user.username = User.getCurrentUser()?.name
        user.email = User.getCurrentUser()?.name
        user.password = User.getCurrentUser()?.password
        // other fields can be set just like with PFObject
        //user["location"] =
        
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
    
    func userDidLogin(){
       // window = UIWindow(frame: UIScreen.mainScreen().bounds)

        var storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        var chatsViewController = storyboard.instantiateViewControllerWithIdentifier("ChatsVC")  as! ChatViewController
        self.window?.rootViewController = UINavigationController(rootViewController: chatsViewController)
    }
    
    func userDidLogout() {
        var storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        var loginViewController = storyboard.instantiateViewControllerWithIdentifier("LoginVC") as! LoginViewController
        self.window?.rootViewController = UINavigationController(rootViewController: loginViewController)
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

