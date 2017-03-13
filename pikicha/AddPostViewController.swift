//
//  AddPostViewController.swift
//  FirebaseLive
//
//  Created by Frezy Mboumba on 1/15/17.
//  Copyright © 2017 Frezy Mboumba. All rights reserved.
//

import UIKit
import Firebase
import EZLoadingActivity
import TGCameraViewController


class AddPostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverPresentationControllerDelegate, UIPickerViewDelegate, UITextViewDelegate, TGCameraDelegate {

    
    var netService = NetworkingService()
    var userinfo = User.self
    
    @IBOutlet weak var postImageView: UIImageView! {
    
        didSet{
        
            self.postImageView.alpha = 0
        }
    
    
    }
    
    @IBOutlet weak var addPhotoBtn: UIButton!
    @IBOutlet weak var postScrollView: UIScrollView!
    @IBOutlet weak var posterName: UILabel!
    
    @IBOutlet weak var posterImage: CustomizableImageView!
    
    @IBOutlet weak var postTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
         //set custom tint color
        TGCameraColor.setTint(.white)
        posterImage.clipsToBounds = true
        fetchCurrentUserInfo()
        self.addPhotoBtn.isHidden = false
        self.postImageView.alpha = 1.0
        
        postScrollView.becomeFirstResponder()
        postTextView.delegate = self
        postTextView.text = "What's happening?"
        postTextView.textColor = UIColor.lightGray
        
        // Do any additional setup after loading the view.
    }
    
    
    
    // MARK: TGCameraDelegate - Required methods
    
    func cameraDidCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    func cameraDidTakePhoto(_ image: UIImage!) {
       self.postImageView.image = image
        dismiss(animated: true, completion: nil)
    }
    
    func cameraDidSelectAlbumPhoto(_ image: UIImage!) {
        self.postImageView.image = image
        dismiss(animated: true, completion: nil)
    }

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    private func fetchCurrentUserInfo() {
        
        netService.fetchCurrentUser { (user) in
            
            if let user = user {
                
                self.posterName.text = user.getFullName()
               
                self.posterImage.sd_setImage(with: URL(string: user.profilePictureUrl), placeholderImage: UIImage(named: "default"))
                
                
                
            }
            
        }
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextView) -> Bool
    {
        postTextView.resignFirstResponder()
        return true
        
    }
    
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        postScrollView.setContentOffset(CGPoint(x: 0, y:5), animated: true)
        if postTextView.textColor == UIColor.lightGray {
            postTextView.text = nil
            postTextView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        postScrollView.setContentOffset(CGPoint(x: 0, y:0), animated: true)
        if postTextView.text.isEmpty {
            postTextView.text = "What's happening?"
            postTextView.textColor = UIColor.lightGray
            dismissKeyboard()
           
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
    
    
  
    

    @IBAction func addPhotoBtnAction(_ sender: UIButton) {
        
        let navigationController = TGCameraNavigationController.new(with: self)
        present(navigationController!, animated: true, completion: nil)
        
//        let pickerController = UIImagePickerController()
//        pickerController.delegate = self
//        pickerController.allowsEditing = true
//        pickerController.modalPresentationStyle = .popover
//        pickerController.popoverPresentationController?.delegate = self
//        pickerController.popoverPresentationController?.sourceView = postImageView
//        let alertController = UIAlertController(title: "Add a Picture", message: "Choose From", preferredStyle: .actionSheet)
//        
//        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
//            pickerController.sourceType = .camera
//            self.present(pickerController, animated: true, completion: nil)
//            
//        }
//        let photosLibraryAction = UIAlertAction(title: "Photos Library", style: .default) { (action) in
//            pickerController.sourceType = .photoLibrary
//            self.present(pickerController, animated: true, completion: nil)
//            
//        }
//        
//        let savedPhotosAction = UIAlertAction(title: "Saved Photos Album", style: .default) { (action) in
//            pickerController.sourceType = .savedPhotosAlbum
//            self.present(pickerController, animated: true, completion: nil)
//            
//        }
//        
//        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
//        
//        alertController.addAction(cameraAction)
//        alertController.addAction(photosLibraryAction)
//        alertController.addAction(savedPhotosAction)
//        alertController.addAction(cancelAction)
//        
//        
//        present(alertController, animated: true, completion: nil)
        

    }
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        
//        if let chosenImage = info[UIImagePickerControllerEditedImage] as? UIImage {
//            self.postImageView.image = chosenImage
//        }
//        self.dismiss(animated: true, completion: nil)
//    }
//    
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        picker.dismiss(animated: true, completion: nil)
//    }
    
    @IBAction func createPost(_ sender: CustomizableButton) {
        EZLoadingActivity.show("Posting...", disableUI: true)
         self.view.endEditing(true)
        
        let metadata = FIRStorageMetadata()
        
        metadata.contentType = "image/jpeg"
        let uid = FIRAuth.auth()!.currentUser!.uid
        let ref = FIRDatabase.database().reference()
        let storage = FIRStorage.storage().reference(forURL: "gs://pikicha-88aee.appspot.com")
        
        let postDate = NSDate().timeIntervalSince1970 as NSNumber
        var postText = ""
        
                    if let text = postTextView.text {
                        postText = text
                    }
        let key = ref.child("posts").childByAutoId().key
        let imageRef = storage.child("posts").child(uid).child("\(key).jpg")
        let data = UIImageJPEGRepresentation(self.postImageView.image!, 0.6)
        
        
        
        let uploadTask = imageRef.put(data!,metadata: metadata) {(metadata, error) in
            
            if error != nil {
                EZLoadingActivity.hide(true, animated: false)
                print(error!.localizedDescription)
                AppDelegate.instance().dismissActivityIndicator()
                return
                
            }
        
            imageRef.downloadURL(completion: { (url, error) in
                if let url = url {
                    
                    let post = ["userID": uid,
                                "postImageUrl": url.absoluteString,
                                "likes": 0,
                                "postText" : postText,
                                "author" : FIRAuth.auth()!.currentUser!.displayName!,
                                "postDate" : postDate,
                                "postID" : key] as [String : Any]
                    
//                    let post = Post(postId: postId, userId: FIRAuth.auth()!.currentUser!.uid, postText: postText, postImageUrl: String(describing: url), postDate: postDate)
                    
                    
                                    let postFeed = ["\(key)" : post]
                    
                                    ref.child("posts").updateChildValues(postFeed)
                    EZLoadingActivity.hide(true, animated: false)
                    let alertView = SCLAlertView()
                    _ = alertView.showSuccess("Success", subTitle: "Post was saved successfully", /*closeButtonTitle: "Done",*/ duration: 1, colorStyle: UIColor(colorWithHexValue: 0x3D5894), colorTextButton: UIColor.white)
                    
                    self.dismiss(animated: true, completion: nil)
                    
                }
                
                
                
            })
            
        }
        
        uploadTask.resume()
        

        
    }

   
}
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
