//
//  ContactsViewController.swift
//  pikicha
//
//  Created by Elvis Tapfumanei on 2017/03/12.
//  Copyright © 2017 Elvis Tapfumanei. All rights reserved.
//

import UIKit
import Firebase
import EZLoadingActivity

class ContactsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var usersArray = [User]()
    var netService = NetworkingService()
    
    
     @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchAllUsers()
    }

    
    private func fetchAllUsers() {
        netService.fetchAllUsers { (users) in
            self.usersArray = users
            
            self.collectionView.reloadData()
        }
        
    }
    
    var databaseRef: FIRDatabaseReference! {
        
        return FIRDatabase.database().reference()
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showGuest" {
            if let indexPath = collectionView.indexPathsForSelectedItems?.first{
                let guestVC = segue.destination as! ProfileViewController
                guestVC.ref = usersArray[indexPath.row].ref
                
            }
            
        }         
        
    }
    
    @IBAction func unwindToContacts(storyboardSegue: UIStoryboardSegue) {
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showGuest", sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.usersArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "userCell", for: indexPath) as! UserCollectionViewCell
        cell.configureCellForUser(user: self.usersArray[indexPath.row])
        
        return cell
    }

    
}
