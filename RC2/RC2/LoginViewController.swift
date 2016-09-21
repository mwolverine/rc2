//
//  LoginViewController.swift
//  RC2
//
//  Created by Chris Yoo on 9/19/16.
//  Copyright © 2016 Chris Yoo. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import Firebase
import FirebaseAuth

class ViewController: UIViewController, FBSDKLoginButtonDelegate {
    var uid: String = ""
    
    static let sharedController = ViewController()
    
    @IBOutlet weak var faceBookButton: NSLayoutConstraint!
    
    @IBAction func faceBookButtonTapped(sender: AnyObject) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // FACEBOOK: Checks if user is logged in
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
        }
        else
        {
            //FACEBOOK: PLaces Facebook Logo
            let loginView : FBSDKLoginButton = FBSDKLoginButton()
            self.view.addSubview(loginView)
            loginView.center = self.view.center
            
            //FACEBOOK: Data Access
            loginView.readPermissions = ["public_profile", "email", "user_friends"]
            loginView.delegate = self
        }
        return
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError?) {
        
        if let error = error {
            print(error.localizedDescription)
            return
        }
        print("User logged in")
        
        FacebookController.sharedController.facebookCredential()
    }
    
 
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    
    @IBAction func returnUserDataButtonTapped(sender: AnyObject) {
        FacebookController.sharedController.returnUserData()
    }
    //COPY
    
    func signedIn(user: FIRUser?) {
        //        MeasurementHelper.sendLoginEvent()
        //        AppState.sharedInstance.displayName = user?.displayName ?? user?.email
        //        AppState.sharedInstance.signedIn = true
        //        NSNotificationCenter.defaultCenter().postNotificationName(Constants.NotificationKeys.SignedIn, object: nil, userInfo: nil)
        //        performSegueWithIdentifier(Constants.Segues.SignInToFp, sender: nil)
    }
}

