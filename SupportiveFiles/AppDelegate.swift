//
//  AppDelegate.swift
//  SoloProjectFireBase
//
//  Created by Olimpia on 2/23/19.
//  Copyright © 2019 Olimpia. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var usersession: UserSession!
    var storageManager: StorageManager!


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
         // Thread.sleep(forTimeInterval: 3.0)
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if let error = error {
                print("request authorization error: \(error)")
            } else if granted {
                print("autorization granted")
            } else {
                print("user denied notifications")
            }
        }
     
        // Override point for customization after application launch.
        FirebaseApp.configure()
        usersession = UserSession()
        storageManager = StorageManager()
        window = UIWindow(frame: UIScreen.main.bounds)
        
      
        if let _ = usersession.getCurrentUser() {
            let storyboard = UIStoryboard(name: "TaskStoryBoard", bundle: nil)
            let homeVC = storyboard.instantiateViewController(withIdentifier: "TasksTabBarController") as! TasksTabBarController
            homeVC.modalTransitionStyle = .crossDissolve
            homeVC.modalPresentationStyle = .overFullScreen
        
            //to change
            window?.rootViewController = homeVC
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginViewController = storyboard.instantiateInitialViewController()
            window?.rootViewController = loginViewController
        }
        
        // present the window
        window?.makeKeyAndVisible()
        
     
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
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
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

