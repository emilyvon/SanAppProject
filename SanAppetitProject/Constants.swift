//
//  File.swift
//  SanAppetitProject
//
//  Created by walid amachraa on 3/13/16.
//  Copyright © 2016 wallPrograms. All rights reserved.
//

import Foundation
import UIKit

let SHADOW_COLOR: CGFloat = 157.0 / 255.0

//Keys
let KEY_UID = "uid"

/////
let KEY_CURRENT_USER = "currentUid"
//////

//Segues
let SEGUE_LOGGED_IN = "currentlyLoggedIn"
let SEGUE_SIGN_UP = "signUp"
let SEGUE_NEW_USER_LOG_IN = "logInNewUser"

//Error codes, status codes
let STATUS_ACCOUNT_NONEXIST = -8
let STATUS_INVALID_EMAIL = -5
let STATUS_EMAIL_IN_USE = -9
let STATUS_INCORRECT_PASSWORD = -6