//
//  DataService.swift
//  SanAppetitProject
//
//  Created by walid amachraa on 3/18/16.
//  Copyright © 2016 wallPrograms. All rights reserved.
//

import Foundation
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit

let URL_BASE = "https://sanappetite.firebaseio.com"

class DataService {
    
    static let ds = DataService()  //static, only one instance in memory and make it globally accessible
    
    //Implement thing that can  interact with Firebase in DataService
    
    private var _REF_BASE = Firebase(url: "\(URL_BASE)")
    private var _REF_POSTS = Firebase(url: "\(URL_BASE)/posts")
    private var _REF_USERS = Firebase(url: "\(URL_BASE)/users")

    
    var REF_BASE: Firebase {
        
        return _REF_BASE
    }
    
    var REF_POSTS: Firebase {
        
        return _REF_POSTS
    }
    
    var REF_USERS: Firebase {
        
        return _REF_USERS
    }
    
    var REF_USER_CURRENT: Firebase {
        
        //Get the uid and the user url, add the uid to the user url to get the current user
        let uid = NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) as! String
        let user = Firebase(url: "\(URL_BASE)").childByAppendingPath("users").childByAppendingPath(uid)
        return user!
    }
    
    //THIS IS HOW YOU CREATE A USER AND ADDS IT TO FIREBASE AUTOMATICALLY
    //Create a user with a uid and keys and values
    func createFirebaseUser(uid: String, user: Dictionary<String, String>) {
        
        //To save data to the Firebase database, you can just call the setValue method. In the code, it’ll save the user object to the users database reference under the given uid child node
        REF_USERS.childByAppendingPath(uid).setValue(user)
    }
    
    ///////////
    func observeCurrentUser() {
        REF_USER_CURRENT.observeSingleEventOfType(.Value) { (snapshot: FDataSnapshot!) in
            let user = snapshot.value as! [String: AnyObject]
            NSUserDefaults.standardUserDefaults().setObject(user, forKey: KEY_CURRENT_USER)
        }
    }
    //////////////
    
    
    
    
    
    
    
    
    
    
    
    
    //Use this function inside the createFirebaseUser function
    func fetchFacebookUserData(completion: ((userInfo: Dictionary<String, AnyObject>!, error: NSError!) -> Void)) {
        
        let graphRequest: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "first_name, last_name"])
        
        graphRequest.startWithCompletionHandler( { (connection, result, error) -> Void in
            
            if error != nil {
                
                print("Error: \(error)")
                print(error.description)
                completion(userInfo: nil, error: error)
                
            } else {
                
                //Create userInfo dictionary with the user information from facebookResult
                var userInfo = Dictionary<String, AnyObject>()
                
                //Populate the userInfo Dictionary
                if let firstName = result["first_name"] as? String {
                    
                    userInfo["firstName"] = firstName
                }
                
                if let lastName = result["last_name"] as? String {
                    
                    userInfo["lastName"] = lastName
                }
                
                print("These are the user info: \(userInfo)")
                
                //                print("the access token is \(FBSDKAccessToken.currentAccessToken().tokenString)")
            }
            }
        )}
    
    func createFirebaseUserFacebook(uid: String, firebaseUser: Dictionary<String, AnyObject>) {
        
        var newUser = firebaseUser
        
        fetchFacebookUserData { (userInfo, error) in
            
            if error != nil {
                
                print(error)
                
            } else {
                
                if let first = userInfo["firstName"] as? String {
                    
                    newUser["firstname"] = first
                }
                
                if let last = userInfo["lastName"] as? String {
                    
                    newUser["lastname"] = last
                }
            }
        }
        
        self.REF_USERS.childByAppendingPath(uid).setValue(firebaseUser)
        
        print("This is the new user information added to Firebase: \(firebaseUser)")
    }
}



