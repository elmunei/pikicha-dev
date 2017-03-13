//
//  AppDelegate.swift
//  pikicha
//
//  Created by Elvis Tapfumanei on 2017/03/11.
//  Copyright © 2017 Elvis Tapfumanei. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    
    override init () {
        super.init()
        FIRApp.configure()
        
    }
    
    
    var actInd = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    var container : UIView!
    
    
    class func instance() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
        
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //Facebook
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        takeToHome()
        return true
    }
    
    
    func takeToHome() {
        
        if FIRAuth.auth()!.currentUser != nil {
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let homeVC = storyboard.instantiateViewController(withIdentifier: "home") as! HomeViewController
//            self.window?.rootViewController = homeVC
            
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PostsVC") as! UITabBarController
            vc.selectedIndex = 0
            
            self.window?.rootViewController = vc
            //self.present(vc, animated: true, completion: nil)
            
        }
    }
    
    
    func showActivityIndicator() {
        if let window = window {
            container = UIView()
            container.frame = window.frame
            container.center = window.center
            container.backgroundColor = UIColor(white: 0, alpha: 0.8)
            
            actInd.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            actInd.hidesWhenStopped = true
            actInd.center = CGPoint(x: container.frame.size.width / 2, y: container.frame.size.height / 2)
            
            container.addSubview(actInd)
            window.addSubview(container)
            
            actInd.startAnimating()
            
        }
        
    }
    
    
    func dismissActivityIndicator() {
        
        if let _ = window {
            container.removeFromSuperview()
            
        }
        
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        FBSDKAppEvents.activateApp()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logOut()
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let handled = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String!, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        
        return handled
    }
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "pikicha")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

