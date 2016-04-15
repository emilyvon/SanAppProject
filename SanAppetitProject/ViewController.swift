//
//  ViewController.swift
//  SanAppetitProject
//
//  Created by walid amachraa on 3/13/16.
//  Copyright © 2016 wallPrograms. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class ViewController: UIViewController, UITextFieldDelegate {

    //OUTLETS
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    //Keyboard
    @IBOutlet weak var textFieldEmailOutlet: UITextField!
    @IBOutlet weak var textFieldPasswordOutlet: UITextField!

    
    
    //
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFieldEmailOutlet.delegate = self
        textFieldEmailOutlet.returnKeyType = UIReturnKeyType.Done
        
        textFieldPasswordOutlet.delegate = self
        textFieldPasswordOutlet.returnKeyType = UIReturnKeyType.Done
    }
    
    override func viewDidAppear(animated: Bool) {
        //Segues don't work in viewDidLoad
        
        //If they are already logged in, they don't have to log in again
        if NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) != nil {
            
            self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
        }
    }
    
    
    
    //
    
    
    
    //ACTIONS
    @IBAction func fbButtonPressed(sender: UIButton!) {
        
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logInWithReadPermissions(["email"]) { (facebookResult: FBSDKLoginManagerLoginResult!, facebookError: NSError!) -> Void in
            
            if facebookError != nil {
                
                print("Facebook login failed. Error \(facebookError)")
                
            } else {
                
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString  //grab the access token stored by Facebook
                print("Successfully logged in with facebook. \(accessToken)")  //Print it in the log
                
                //NOW MAKE IT TALK TO FIREBASE AND USE THE OAUTH FOR THE AUTHENTIFICATION WITH FACEBOOK TO LOG THE USER IN
                
                //Grab the firebase base reference and authenticate it using the provider
                //You can use dot syntax with DataService, a singleton instead of DataService()
                //authwithOAuthProvider is for a provider and a token
                DataService.ds.REF_BASE.authWithOAuthProvider("facebook", token: accessToken, withCompletionBlock: { error, authData in
                    
                    if error != nil {
                        
                        print("login failed. \(error)")
                        
                    } else {
                        
                        print("Logged in! \(authData)")
                        
                        //Create a Firebase user, with values as dictionary <String, String>
                        let user = ["provider": authData.provider!]  //Grab the name of Facebook for the username?
                        //no if let since we don't want it to keep going if there is no user
                        //If Firebase has a problem, then use the if let
                        DataService.ds.createFirebaseUser(authData.uid, user: user)
                        
                        //THIS GRABS THE DATA FROM THE DATASERVICE AND FINDS THE PATH WITH THE UNIQUE ID AND IT SETS THE VALUE OF THE UNIQUE ID
                        
                        //Save the newly created Firebase account with the uid using its key
                        //Store on the device the token of the Firebase user id
                        NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: KEY_UID)
                        
                        //When logged in, send to the view controller
                        self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                    }
                })
            }
        }
    }
    
    @IBAction func emailButtonPressed(sender: UIButton!) {
        
        if let email = emailField.text where email != "", let pwd = passwordField.text where pwd != "" {
            
            //authUser is for email, password
            DataService.ds.REF_BASE.authUser(email, password: pwd, withCompletionBlock: { error, authData in
                
                if error != nil {
                    
                    print(error)
                    
                    if error.code == STATUS_ACCOUNT_NONEXIST {
                        
                        self.showErrorAlert("Incorrect Email or Password", msg: "Try a different Email or Password, or use the sign up button to create your new account.")
                    }
                    
                    if error.code == STATUS_INVALID_EMAIL {
                        
                        self.showErrorAlert("Invalid Email address", msg: "Please enter a valid Email address.")
                    }
                    
                    if error.code == STATUS_INCORRECT_PASSWORD {
                        
                        self.showErrorAlert("Incorrect Password", msg: "Please enter the correct Password.")
                    }
                    
                } else {
                    
                    //Save the Firebase user account
                    //////////////
                    NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: KEY_UID)
                    print("Saved user uid: \(authData.uid)")
                    self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                    
                    //Get the user credentials
                    DataService.ds.observeCurrentUser()
                    //////////////
                    
//                    NSUserDefaults.standardUserDefaults().setValue(SEGUE_LOGGED_IN, forKey: KEY_UID)
//                    self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                }
            })
            
        } else {
            
            showErrorAlert("Email and Password Required", msg: "You must enter an email and a password.")
        }
    }
    
    @IBAction func signUpButtonPressed(sender: UIButton!) {
        
        self.performSegueWithIdentifier(SEGUE_SIGN_UP, sender: nil)
    }
    //
            
    //FUNCTIONS
    func showErrorAlert(title: String, msg: String) {
        
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
    
    textFieldEmailOutlet.resignFirstResponder()
    textFieldPasswordOutlet.resignFirstResponder()
    
    return true
    }

}

