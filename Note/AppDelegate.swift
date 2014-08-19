//
//  AppDelegate.swift
//  Note
//
//  Created by Joel Klabo on 6/28/14.
//  Copyright (c) 2014 Joel Klabo. All rights reserved.
//

import UIKit
import CloudKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
    var window: UIWindow?
    var backgroundQueue = NSOperationQueue.mainQueue()


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        // Override point for customization after application launch.
        self.window!.backgroundColor = UIColor.whiteColor()
        self.window!.makeKeyAndVisible()
        
        self.window!.rootViewController = MapViewController(nibName: nil, bundle: nil)
        
        
        if (!NSUserDefaults.standardUserDefaults().objectForKey("currentUserID")) {
            // Query the private DB for user info
            let privateDatabase = CKContainer.defaultContainer().privateCloudDatabase
            let any = NSPredicate(value: true)
            let currentUserQuery = CKQuery(recordType: "CurrentUser", predicate: any)
            privateDatabase.performQuery(currentUserQuery, inZoneWithID: nil, completionHandler: { (results:[AnyObject]!, error:NSError!) -> Void in
                var resultsArray = results as [CKRecord]
                if (resultsArray.count > 0) {
                    println(resultsArray)
                } else {
                    let currentUserRecord = CKRecord(recordType: "CurrentUser")
                    currentUserRecord.setValue(NSUUID.UUID().UUIDString, forKey: "userID")
                    privateDatabase.saveRecord(currentUserRecord, completionHandler: { (userRecord, error) -> Void in
                        // User record was successfully saved. Add it to user defaults
                        if (userRecord) {
                            NSUserDefaults.standardUserDefaults().setObject(userRecord.valueForKey("userID"), forKey: "currentUserID")
                            NSUserDefaults.standardUserDefaults().synchronize()
                            println("created user \(userRecord)")
                        }
                    })
                }
            })
        }
        
        // Find users friends
        let discoverContactsOperation = CKDiscoverAllContactsOperation()
        discoverContactsOperation.queuePriority = .Low
        discoverContactsOperation.qualityOfService = .Background
        discoverContactsOperation.discoverAllContactsCompletionBlock = { (users: [AnyObject]!, error: NSError!) -> Void in
            println(users)
            println(error)
        }
        
        let discoverUserInfosOperation = CKDiscoverUserInfosOperation(emailAddresses: ["joelklabo@gmail.com"], userRecordIDs: nil)
        discoverUserInfosOperation.queuePriority = .Low
        discoverUserInfosOperation.qualityOfService = .Background
        discoverUserInfosOperation.discoverUserInfosCompletionBlock = { (emails: [NSObject : AnyObject]!, recordIDs: [NSObject : AnyObject]!, error: NSError!) -> Void in
            println(emails)
            println(recordIDs)
            println(error)
        }
        
        backgroundQueue.addOperation(discoverContactsOperation)
        backgroundQueue.addOperation(discoverUserInfosOperation)
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

