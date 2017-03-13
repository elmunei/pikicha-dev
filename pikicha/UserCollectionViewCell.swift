//
//  UserCollectionViewCell.swift
//  pikicha
//
//  Created by Elvis Tapfumanei on 2017/02/26.
//  Copyright © 2017 Elvis Tapfumanei. All rights reserved.
//

import UIKit
import Firebase

class UserCollectionViewCell: UICollectionViewCell {
   
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var verifiedUserImageView: UIImageView!
    
    
  
    
    func configureCellForUser(user: User) {
        
        self.usernameLabel.text = user.getFullName()
        self.countryLabel.text = user.country
        downloadImageFromFirebase(urlString: user.profilePictureUrl)
        //self.verifiedUserImageView.isHidden = !user.isVerified
        self.userImageView.sd_setImage(with: URL(string: user.profilePictureUrl), placeholderImage: UIImage(named: "default"))
        
    }
    
    func downloadImageFromFirebase(urlString: String) {
        
        let storageRef = FIRStorage.storage().reference(forURL: urlString)
        storageRef.data(withMaxSize: 1 * 1024 * 1024) { (imageData, error) in
            
            if error != nil {
                print(error!.localizedDescription)
                
            } else {
                
                if let data = imageData {
                    DispatchQueue.main.async(execute: {
                        self.userImageView.image = UIImage(data: data)
                    })
                    
                }
                
            }
            
            
            
        }
        
        
    }

    
    
}
