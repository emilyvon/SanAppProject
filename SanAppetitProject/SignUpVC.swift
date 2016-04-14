//
//  SignUpVC.swift
//  SanAppetitProject
//
//  Created by walid amachraa on 3/18/16.
//  Copyright © 2016 wallPrograms. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController, UITextFieldDelegate {

    //OUTLETS
    @IBOutlet weak var emailFieldSignUp: UITextField!
    @IBOutlet weak var passwordFieldSignUp: UITextField!
    @IBOutlet weak var usernameSignUp: UITextField!
    @IBOutlet weak var firstNameSignUp: UITextField!
    @IBOutlet weak var lastNameSignUp: UITextField!
    //Profile image outlet
    @IBOutlet weak var profileImageSignUpVCOutlet: UIImageView!

    
    
    //
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstNameSignUp.delegate = self
        firstNameSignUp.returnKeyType = UIReturnKeyType.Done
        
        lastNameSignUp.delegate = self
        lastNameSignUp.returnKeyType = UIReturnKeyType.Done
        
        usernameSignUp.delegate = self
        usernameSignUp.returnKeyType = UIReturnKeyType.Done
        
        emailFieldSignUp.delegate = self
        emailFieldSignUp.returnKeyType = UIReturnKeyType.Done
        
        passwordFieldSignUp.delegate = self
        passwordFieldSignUp.returnKeyType = UIReturnKeyType.Done
    }
    
    
    
    //
    
    
    
    //ACTIONS
    @IBAction func signUpAndLogInButtonPressed(sender: UIButton!) {
                
        if let emailSignUp = emailFieldSignUp.text where emailSignUp != "", let pwdSignUp = passwordFieldSignUp.text where pwdSignUp != "", let usernameSignUp = usernameSignUp.text where usernameSignUp != "", let firstNameSignUp = firstNameSignUp.text where firstNameSignUp != "", let lastNameSignUp = lastNameSignUp.text where lastNameSignUp != "" {
            
            //On success, gives a result in the form of a dictionary with the user data, including the user uid
            DataService.ds.REF_BASE.createUser(emailSignUp, password: pwdSignUp, withValueCompletionBlock: { error, result in
                
                if error != nil {
                    
                    print(error)
                    print(error.code)
                    
                    self.showErrorAlert("Could not create account", msg: "The email you have entered is already in use")
                    
                } else {
                    
                    //CREATE THE USER AND SEND THE DATA TO FIREBASE ONCE THAT NEW USER IS CREATED
                    DataService.ds.REF_BASE.authUser(emailSignUp, password: pwdSignUp, withCompletionBlock: { err, authData in
                        
                        // "" from the Firebase data
                        let user = ["provider": authData.provider!, "firstname": firstNameSignUp, "lastname": lastNameSignUp]  //Add image
                        DataService.ds.createFirebaseUser(authData.uid, user: user)
                        })
                    
                    self.showErrorAlert("Congratulations! Your account has been created", msg: "Go back to the main menu, log in and start your journey with us on (app name)!")
                }
            })
            
        } else {
            
            self.showErrorAlert("Incomplete Form", msg: "Please complete the sign up form in order to create your account.")
        }
    }
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
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
        
        usernameSignUp.resignFirstResponder()
        emailFieldSignUp.resignFirstResponder()
        passwordFieldSignUp.resignFirstResponder()

        return true
    }
}
