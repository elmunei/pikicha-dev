//
//  UserProfileViewController.swift
//  FirebaseLive
//
//  Created by Frezy Mboumba on 1/15/17.
//  Copyright © 2017 Frezy Mboumba. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class UserProfileViewController: UIViewController {
    
    
    @IBOutlet weak var userProfilePhoto: CustomizableImageView!
    @IBOutlet weak var firstname: CustomizableTextfield!
    @IBOutlet weak var lastname: CustomizableTextfield!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var country: UILabel!
    
    
   var netService = NetworkingService()
    
  

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        fetchCurrentUserInfo()
    }
    
   
    
    private func fetchCurrentUserInfo() {
    
        netService.fetchCurrentUser { (user) in
            
            if let user = user {
                
                self.country.text = user.country
                self.email.text = user.email
                self.firstname.text = user.firstname
                self.lastname.text = user.lastname
                self.userProfilePhoto.sd_setImage(with: URL(string: user.profilePictureUrl), placeholderImage: UIImage(named: "default"))
               
            
            
            }
            
        }
        
    
    }

}


