//
//  AddCommentViewController.swift
//  FirebaseLive
//
//  Created by Frezy Mboumba on 1/15/17.
//  Copyright © 2017 Frezy Mboumba. All rights reserved.
//

import UIKit
import Firebase

class AddCommentViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverPresentationControllerDelegate, UIPickerViewDelegate, UITextViewDelegate  {
    
    
    var netService = NetworkingService()
    var postId: String!
    
    @IBOutlet weak var commentsImageView: UIImageView! {
        
        didSet{
            
            self.commentsImageView.alpha = 0
        }
        
        
    }
    
    @IBOutlet weak var addPhotoBtn: UIButton!
    @IBOutlet weak var commentScrollView: UIScrollView!
    
    
    @IBOutlet weak var commentTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        commentScrollView.delegate = self
        commentTextView.delegate = self
        commentTextView.text = "What would you like to share?"
        commentTextView.textColor = UIColor.lightGray
        
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if (textField == commentTextView)
        {
            commentTextView.becomeFirstResponder()
            return true
        }
            
        else if (textField == commentTextView)
        {
            commentTextView.resignFirstResponder()
            return true
        }
        
        return false
        
    }
    
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        commentScrollView.setContentOffset(CGPoint(x: 0, y:5), animated: true)
        if commentTextView.textColor == UIColor.lightGray {
            commentTextView.text = nil
            commentTextView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        commentScrollView.setContentOffset(CGPoint(x: 0, y:0), animated: true)
        if commentTextView.text.isEmpty {
            commentTextView.text = "What would you like to share?"
            commentTextView.textColor = UIColor.lightGray
        }
        
        
        
    }
    
    //    @objc private func hideKeyboardOnTap(){
    //        self.view.endEditing(true)
    //    }
    //
    //
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    @IBAction func createComment(_ sender: CustomizableButton) {
        
        self.view.endEditing(true)
        
        
        var commentText = ""
        
        if let text = commentTextView.text {
            commentText = text
        }
        
        let commentId = NSUUID().uuidString
        let commentDate = NSDate().timeIntervalSince1970 as NSNumber
        let comment = Comment(commentId: commentId, userId: FIRAuth.auth()!.currentUser!.uid, commentText: commentText, postId: self.postId, commentImageUrl: "", commentDate: commentDate, key: "TEXT")
        
        self.netService.saveCommentToDB(comment: comment, completed: {
            self.dismiss(animated: true, completion: nil)
        })
    
}
}
