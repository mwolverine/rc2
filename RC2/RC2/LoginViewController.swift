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
        self.returnUserData()
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
        //FIREBASE: Integration with Firebase through authentication
        
        let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
        
        FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
            if let error = error {
                print(error)
            } else {
            
            self.signedIn(user)
                
            print("Firebase authenticated")
                
        //FIREBASE: Create a user in database with the same authentication UID
                
                FIRAuth.auth()?.addAuthStateDidChangeListener({ (auth, user) in
                    let firebaseURL = FIRDatabase.database().referenceFromURL("https://rc2p-15dd8.firebaseio.com/")

                    if (user != nil) {
                        
                        guard let user = user else { return }
                        guard let photoLink = user.photoURL else { return }
                        let photoStringURL = photoLink.absoluteString

                        let newUser = ["provider": user.providerID as String, "displayName": user.displayName! as String, "email": user.email! as String, "photoURL": photoStringURL as String]
                        let uid = user.uid as String
                        let usersReference = firebaseURL.child("users/\(uid)")
                        
                        
                        usersReference.child("UserInfo").updateChildValues(newUser) { (err, ref) in
                            if err != nil {
                                print(err)
                                return
                            }
                            print("saved successful in firebase database")
                        }
                    }
                })
            }
        }
    }
    
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    
    @IBAction func returnUserDataButtonTapped(sender: AnyObject) {
        returnUserData()
    }
    
    func returnUserData()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                print("Error: \(error)")
            }
            else
            {
                print("fetched user: \(result)")
                let userName : NSString = result.valueForKey("name") as! NSString
                print("User Name is: \(userName)")
                
        
                //                let userEmail : NSString = result.valueForKey("email") as! NSString
                //                print("User Email is: \(userEmail)")
            }
        })
    }
    
    func signedIn(user: FIRUser?) {
//        MeasurementHelper.sendLoginEvent()
//        AppState.sharedInstance.displayName = user?.displayName ?? user?.email
//        AppState.sharedInstance.signedIn = true
//        NSNotificationCenter.defaultCenter().postNotificationName(Constants.NotificationKeys.SignedIn, object: nil, userInfo: nil)
//        performSegueWithIdentifier(Constants.Segues.SignInToFp, sender: nil)
    }
}

