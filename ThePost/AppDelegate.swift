//
//  AppDelegate.swift
//  ThePost
//
//  Created by Andrew Robinson on 12/23/16.
//  Copyright © 2016 The Post. All rights reserved.
//

import UIKit
import Firebase
import Fabric
import Crashlytics
import SwiftKeychainWrapper

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FIRApp.configure()
        Fabric.with([Answers.self, Crashlytics.self])
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        // UnComment this to load jeep selector on starup everytime.
//        KeychainWrapper.standard.removeObject(forKey: Constants.UserInfoKeys.UserSelectedJeep.rawValue)
        
        let selectedJeep = KeychainWrapper.standard.integer(forKey: Constants.UserInfoKeys.UserSelectedJeep.rawValue)
        var mainViewController:UIViewController
        if selectedJeep == nil {
            mainViewController = mainStoryboard.instantiateViewController(withIdentifier: "jeepSelectorViewController") as! JeepSelectorViewController
        } else {
            mainViewController = mainStoryboard.instantiateViewController(withIdentifier: "slidingSelectionTabBarController") as! SlidingSelectionTabBarController
        }
        
        self.window?.rootViewController = mainViewController
        
        self.window?.makeKeyAndVisible()
        
        if let pass = KeychainWrapper.standard.string(forKey: Constants.UserInfoKeys.UserPass.rawValue) {
            if let email = FIRAuth.auth()?.currentUser?.email {
                
                let credential = FIREmailPasswordAuthProvider.credential(withEmail: email, password: pass)
                FIRAuth.auth()!.currentUser!.reauthenticate(with: credential, completion: { error in
                    if let error = error {
                        print("Error reauthenticating: \(error.localizedDescription)")
                        do {
                            try FIRAuth.auth()?.signOut()
                        } catch {
                            print("Error signing out")
                        }
                    }
                    
                })
            } else {
            }
        } else {
            do {
                try FIRAuth.auth()?.signOut()
            } catch {
                print("Error signing out")
            }
        }
        
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

