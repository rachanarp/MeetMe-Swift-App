//
//  LoginViewController.swift
//  ParseChat
//
//  Created by Rachana Bedekar on 4/30/15.
//  Copyright (c) 2015 Rachana Bedekar. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func onSignupTapped(sender: AnyObject) {
        var user = PFUser()
        user.username = usernameField.text
        user.email = usernameField.text
        user.password = passwordField.text
        // other fields can be set just like with PFObject
        //user["location"] =
        
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
    
    @IBAction func onSigninTapped(sender: AnyObject) {
        PFUser.logInWithUsernameInBackground(usernameField.text, password:passwordField.text) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                // Do stuff after successful login.
                var currUser = User().initWithPFUser(user)
                currUser?.password = self.passwordField.text
                User.setCurrentUserWith(currUser)
                
                println("SIGNED IN")
                self.performSegueWithIdentifier("showChatSegue", sender: self)
            } else {
                // The login failed. Check error to see why.
            }
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    /*override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }*/


}
