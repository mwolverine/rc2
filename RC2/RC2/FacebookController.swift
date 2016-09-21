//
//  FacebookController.swift
//  RC2
//
//  Created by Chris Yoo on 9/21/16.
//  Copyright © 2016 Chris Yoo. All rights reserved.
//

import Foundation
import FBSDKLoginKit
import FBSDKCoreKit
import Firebase
import FirebaseAuth

class FacebookController {
    
    var friendData: [String] = []
    var uid: String = ""
    static let sharedController = FacebookController()
    let firebaseURL = FIRDatabase.database().referenceFromURL("https://rc2p-15dd8.firebaseio.com/")
    
    //FIREBASE FACEBOOK: Integration with Firebase through authentication from Facebook

    func facebookCredential() {
        
        let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
        
        FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
            if let error = error {
                print(error)
            } else {
            
                print("Firebase authenticated")
                
                //FIREBASE: Create a user in database with the same authentication UID
                
                FIRAuth.auth()?.addAuthStateDidChangeListener({ (auth, user) in
                    
                    if (user != nil) {
                    
                        guard let user = user else { return }
                        guard let photoLink = user.photoURL else { return }
                        let photoStringURL = photoLink.absoluteString
                        
                        let newUser = ["displayName": user.displayName! as String, "email": user.email! as String, "photoURL": photoStringURL as String]
                        self.uid = user.uid as String
                        let usersReference = self.firebaseURL.child("users/\(self.uid)")
                        
                        usersReference.child("UserInfo").updateChildValues(newUser) { (err, ref) in
                            if err != nil {
                                print(err)
                                return
                            }
                            print("saved successful in firebase database")
                        }
                        
                        self.returnMyData()
                        self.returnFriendListData()
                    }
                })
            }
        }
    }

    // FACEBOOK returns data on current user
    func returnMyData(){
        if((FBSDKAccessToken.currentAccessToken()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, first_name, last_name, gender"]).startWithCompletionHandler({ (connection, result, error) -> Void in
                if ((error) != nil)
                {
                    print("Error: \(error)")
                }
                else
                {
                    let resultdict = result as! NSDictionary
                    
                    let fID = resultdict.objectForKey("id") as! String
                    let firstName = resultdict.objectForKey("first_name") as! String
                    let lastName = resultdict.objectForKey("last_name") as! String
                    let gender = resultdict.objectForKey("gender") as! String
                    
                    // Adds Facebook data to Firebase

                    let detailedUser = ["fID": fID, "firstName": firstName, "lastName": lastName, "gender": gender]
                    
                    self.addUserDetail(detailedUser)
                    
                 }
            })
        }
        
    }
    
    // FIREBASE adds detailed user information to Firebase from Facebook
    func addUserDetail(detailedUser: [String: AnyObject]){
        let usersReference = self.firebaseURL.child("users/\(self.uid)")
        
        usersReference.child("UserInfo").updateChildValues(detailedUser, withCompletionBlock: { (err, ref) in
            if err != nil {
                print(err)
                return
            }
        })
    }

    // FACEBOOK returns data on current user's friends with the app
    func returnFriendListData() {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "/me/friends", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                print("Error: \(error)")
            }
            else
            {
                let resultdict = result as! NSDictionary
                print("Result Dict: \(resultdict)")
                
                let data : NSArray = resultdict.objectForKey("data") as! NSArray
                
                for i in 0..<data.count {
                    let valueDict : NSDictionary = data[i] as! NSDictionary
                    let id = valueDict.objectForKey("id") as! String
                    let name = valueDict.objectForKey("name") as! String
                    
//                    print("the id value is \(id)")
//                    print("\(name)")
                    
                    self.createFriend("\(id)", friendName: "\(name)")
                    
                }
                
                let friends = resultdict.objectForKey("data") as! NSArray
                print("Found \(friends.count) friends")
                
                //Call function to add friends to friendlist - Retika
                
                //use the list of Facebook user id’s returned in the JSON and populate them into an array so you can compare those user id’s with the user scores in your database,
                
            }
        })
    }
    
    // FIREBASE adds information on friends to Firebase from Facebook

    func createFriend(friendID: String, friendName: String) {
        let usersReference = firebaseURL.child("users/\(uid)")
        
        let friendsInfo = [friendID: friendName]
        
        usersReference.child("FriendList").updateChildValues(friendsInfo, withCompletionBlock: { (err, ref) in
            if err != nil {
                print(err)
                return
            }
        })
    }
}
