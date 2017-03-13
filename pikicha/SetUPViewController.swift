//
//  SetUPViewController.swift
//  Pikicha
//
//  Created by Elvis Tapfumanei on 2017/02/17.
//  Copyright © 2017 Vasil Nunev. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import FBSDKCoreKit
import FBSDKLoginKit
import EZLoadingActivity



class SetUPViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var firstNameTextField: CustomizableTextfield!
    @IBOutlet weak var lastNameTextField: CustomizableTextfield!
    @IBOutlet weak var countryTextField: CustomizableTextfield!
    @IBOutlet weak var signUpProPic: CustomizableImageView!

    var ref: FIRDatabaseReference!
    var imgPicker = UIImagePickerController();
    var countryArrays: [String] = []
    var pickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setTapGestureRecognizerOnView()
        setSwipeGestureRecognizerOnView()
        getCountries()
        setCountryPickerView()
        
        imgPicker.delegate = self;
        
        signUpProPic.layer.cornerRadius = signUpProPic.frame.size.width / 2
        signUpProPic.clipsToBounds = true
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
        
    
    @IBAction func addProPicAction(_ sender: UITapGestureRecognizer) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.modalPresentationStyle = .popover
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
    }
    }

    @IBAction func createAccount(_ sender: CustomizableButton) {
   
       EZLoadingActivity.show("Creating Account...", disableUI: true)
        
        if firstNameTextField.text == "" || lastNameTextField.text == "" || countryTextField.text == "" {
            
            EZLoadingActivity.hide(true, animated: false)
            let alertController = UIAlertController(title: "Error", message: "field(s) cannot be blank", preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
                
            }
            
            alertController.addAction(OKAction)
            
            
            
            self.present(alertController, animated: true, completion:nil)

            print("error!")
            

        
            return
        
        
        }
        
        
        
        if signUpProPic != nil && firstNameTextField.text != nil && lastNameTextField.text != nil && countryTextField.text != nil {
            
            
            
            let databaseRef = FIRDatabase.database().reference()
            
            let uid = FIRAuth.auth()?.currentUser?.uid
            
            let uploadData = UIImageJPEGRepresentation(self.signUpProPic.image!, 0.4)
            
            let imageName = NSUUID().uuidString
            
            let storageRef = FIRStorage.storage().reference().child("users").child("\(imageName).jpg")
            storageRef.put(uploadData!, metadata: nil) {
                metadata, error in
                
                if error != nil {
                    
                    print("error!")
                    EZLoadingActivity.hide(true, animated: false)
                    
                    return
                    
                }
                else {
                    
                    
                    let firstname = self.firstNameTextField.text
                    let lastname = self.lastNameTextField.text
                    let country = self.countryTextField.text
                    
                    if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                        
                        let user = ["uid" as NSObject : uid! as String,
                                    "country" as NSObject : country! as String,
                                    "firstname" as NSObject : firstname! as String,
                                    "lastname" as NSObject : lastname! as String,
                                    "provider" as NSObject : FIRFacebookAuthProviderID,
                                    "profilePictureUrl": profileImageUrl] as [AnyHashable : Any]
                        
                        Pikicha.sharedInstance.signUpProPic = profileImageUrl
                        
                        let childUpdates = ["users/\(uid!)/" : user]
                        databaseRef.updateChildValues(childUpdates)
                        
                        let appDel = UIApplication.shared.delegate as! AppDelegate
                        appDel.takeToHome()
                        
                    }
                    
                }
            } 
            
        }
        

    }
    
    func getCountries(){
        
        for code in NSLocale.isoCountryCodes as [String]{
            let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
            let name = NSLocale(localeIdentifier: "en_EN").displayName(forKey: NSLocale.Key.identifier, value: id) ?? "Country not found for code: \(code)"
            
            countryArrays.append(name)
            countryArrays.sort(by: { (name1, name2) -> Bool in
                name1 < name2
            })
        }
    }
    
    func setCountryPickerView(){
        
        pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.backgroundColor = UIColor(colorWithHexValue: 0xa4a7b7)
        countryTextField.inputView = pickerView
    }

    
    
    func completeSign(id: String, userData: Dictionary<String, String>) {
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData )
    }

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        signUpProPic.image = image
        self.dismiss(animated: true, completion: nil);
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if (textField == firstNameTextField)
        {
            lastNameTextField.becomeFirstResponder()
            return true
        }
            
        else if (textField == lastNameTextField)
        {
            countryTextField.becomeFirstResponder()
            
            return true
        }
            
        else if (textField == countryTextField)
        {
            countryTextField.resignFirstResponder()
            return true
        }
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        animateView(up: true, moveValue: 70)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        animateView(up: false, moveValue:
            70)
    }
    
    
    func animateView(up: Bool, moveValue: CGFloat){
        
        let movementDuration: TimeInterval = 0.3
        let movement: CGFloat = (up ? -moveValue : moveValue)
        UIView.beginAnimations("animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
        
    }
    
    @objc func hideKeyboardOnTap(){
        self.view.endEditing(true)
        
    }
    
    func setTapGestureRecognizerOnView(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SetUPViewController.hideKeyboardOnTap))
        tapGesture.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapGesture)
        
    }
    
    func setSwipeGestureRecognizerOnView(){
        let swipDown = UISwipeGestureRecognizer(target: self, action: #selector(SetUPViewController.hideKeyboardOnTap))
        swipDown.direction = .down
        self.view.addGestureRecognizer(swipDown)
    }

    // MARK: - Picker view data source
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return countryArrays[row]
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        countryTextField.text = countryArrays[row]
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countryArrays.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let title = NSAttributedString(string: countryArrays[row], attributes: [NSForegroundColorAttributeName: UIColor.white])
        return title
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 20)
        label.text = countryArrays[row]
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.center
        return label
    }

    
}
