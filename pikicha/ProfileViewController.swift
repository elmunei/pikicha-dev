//
//  ProfileViewController.swift
//  pikicha
//
//  Created by Elvis Tapfumanei on 2017/02/23.
//  Copyright © 2017 Elvis Tapfumanei. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {

    var ref: FIRDatabaseReference!
    var netService = NetworkingService()
    
    
    
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var firstNameLbl: UILabel!
    @IBOutlet weak var lastNameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var countryLbl: UILabel!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setGuestUserInfo()
    }

    private func setGuestUserInfo() {
    
        if let ref = ref {
            netService.fetchGuestUser(ref: ref, completion: { (user) in
                if let user = user {
                    self.countryLbl.text = user.country
                    self.emailLbl.text = user.email
                    self.firstNameLbl.text = user.firstname
                    self.lastNameLbl.text = user.lastname
                   self.profilePhoto.sd_setImage(with: URL(string: user.profilePictureUrl), placeholderImage: UIImage(named: "default"))
                   
                
                }
                
                
                
                
            })
        
        }
    
    }



}
