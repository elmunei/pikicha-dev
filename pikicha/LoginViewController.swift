//
//  ViewController.swift
//  Swiftify
//
//  Created by Frezy Mboumba on 12/17/16.
//  Copyright © 2016 Frezy Mboumba. All rights reserved.
//

import UIKit
import Firebase
import RevealingSplashView
import FBSDKLoginKit
import EZLoadingActivity

class LoginViewController: UIViewController, UITextFieldDelegate,FBSDKLoginButtonDelegate {

    @IBOutlet weak var emailTextField: CustomizableTextfield! {
        didSet{
            emailTextField.delegate = self
        }
    }
    @IBOutlet weak var passwordTextField: CustomizableTextfield!{
        didSet{
            passwordTextField.delegate = self
        }
    }

    @IBOutlet weak var forgotDetailButton: UIButton!
    @IBOutlet weak var signInButton: CustomizableButton!
    
    
    var networkingService = NetworkingService()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loginButton = FBSDKLoginButton()
        view.addSubview(loginButton)
        //Facebook Code
        loginButton.frame = CGRect(x: 57, y: 468, width: 259, height: 50)
        loginButton.delegate = self
        loginButton.readPermissions = ["email", "public_profile"]
        

        
        //Initialize a revealing Splash with with the iconImage, the initial size and the background color
        let revealingSplashView = RevealingSplashView(iconImage: UIImage(named: "Logo")!,iconInitialSize: CGSize(width: 100, height: 100), backgroundColor: UIColor(colorWithHexValue: 0xFFFFFF))
        
        //Adds the revealing splash view as a sub view
        self.view.addSubview(revealingSplashView)
        
        revealingSplashView.animationType = SplashAnimationType.swingAndZoomOut

        
        //Starts animation
        revealingSplashView.startAnimation(){
            print("Completed")
        }
        
        
        // Do any additional setup after loading the view, typically from a nib.
        setTapGestureRecognizerOnView()
        setSwipeGestureRecognizerOnView()
        
        
        
    }

    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did log out of facebook")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            return
        }
        
        let loginButton = FBSDKLoginManager()
        loginButton.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            
            if error != nil {
                print("Elvis: Unable to authenticate with Facebook")
                
            } else if result?.isCancelled == true {
                
                print("Elvis: User cancelled Facebook authentication")
                
            }  else {
                
                print("Elvis: User successfully authenticated with Facebook")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
                
                
                
                
                
                let viewController = self.storyboard!.instantiateViewController(withIdentifier: "setUp")
                
                self.present(viewController, animated: true, completion: nil)
                
            }
        }
    }
    
    
    func firebaseAuth(_ credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("Elvis: Unable to authenticate with Firebase - \(error)")
            } else {
                print("Elvis: User successfully authenticated with Firebase")
                if let user = user {
                    let userData = ["provider": credential.provider]
                    self.completeSign(id: user.uid, userData: userData)
                }
            }
        })
        
    }
    

    func completeSign(id: String, userData: Dictionary<String, String>) {
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData )
    }

    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    

    @IBAction func signInAction(_ sender: CustomizableButton) {
        EZLoadingActivity.show("Loading...", disableUI: true)
        
        let email = emailTextField.text!.lowercased()
        let finalEmail = email.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let password = passwordTextField.text!
        
        FIRAuth.auth()?.signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
        if let error = error {
            EZLoadingActivity.hide()

            let alert = SCLAlertView()
            _ = alert.showWarning("⛔️", subTitle: error.localizedDescription)
            
            }
        })
        if email.isEmpty || finalEmail.isEmpty || password.isEmpty {
            EZLoadingActivity.hide()

         
        }else {
            if isValidEmail(email: finalEmail) {
                signInButton.isEnabled = true
                self.networkingService.signIn(email: finalEmail , password: password)
                
                
            }
            
            
        }
        
        self.view.endEditing(true)
    }
  
    
   
    

}

extension LoginViewController {
    
    @IBAction func unwindToLogin(_ storyboardSegue: UIStoryboardSegue){}
    
    private func hideForgotDetailButton(isHidden: Bool){
        self.forgotDetailButton.isHidden = isHidden
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        animateView(up: true, moveValue: 80)
        hideForgotDetailButton(isHidden: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        animateView(up: false, moveValue:
            80)
        hideForgotDetailButton(isHidden: false)
    }
    
    // Move the View Up & Down when the Keyboard appears
    func animateView(up: Bool, moveValue: CGFloat){
        
        let movementDuration: TimeInterval = 0.3
        let movement: CGFloat = (up ? -moveValue : moveValue)
        UIView.beginAnimations("animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
        
        
    }
    
    @objc private func hideKeyboardOnTap(){
        self.view.endEditing(true)
        
    }
    
    func setTapGestureRecognizerOnView(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.hideKeyboardOnTap))
        tapGesture.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapGesture)
        
    }
    func setSwipeGestureRecognizerOnView(){
    let swipDown = UISwipeGestureRecognizer(target: self, action: #selector(LoginViewController.hideKeyboardOnTap))
    swipDown.direction = .down
    self.view.addGestureRecognizer(swipDown)
    }
}
