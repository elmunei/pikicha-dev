//
//  Pikicha.swift
//  Pikicha
//
//  Created by Elvis Tapfumanei on 2017/01/23.
//  Copyright © 2017 Elvis Tapfumanei. All rights reserved.
//

import Foundation
import UIKit

class Pikicha: NSObject
    
{
    
    
    static let sharedInstance: Pikicha = Pikicha()
    
    //Facebook Variables
    var facebookToken: String = ""
    var facebookProfilePic: String = ""
    var facebookName: String = ""
    var facebookEmail: String = ""
    
    //Sign Up Variables
    var emailTextField: String = ""
    var usernameTextField: String = ""
    var signUpProPic: String = ""
    
    // var user: User?
    
    var joinedGroup: Bool = false
    
    // var groups: [Chat] = [Chat]()
    
    var groupId: String = ""
    
    var messageId: String = ""
    
    var controller: UIViewController?
    
    var createdGroup: Bool = false
    
    var profileUpdated: Bool = false
    
    var groupIndex: Int = 0
    
    
    
    


}
