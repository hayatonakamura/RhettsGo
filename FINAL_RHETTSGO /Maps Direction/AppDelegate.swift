//
//  AppDelegate.swift
//  Maps Direction
//
//  Created by Agus Cahyono on 2/9/17.
//  Copyright © 2017 balitax. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import LyftSDK
import UberCore

@available(iOS 9, *)
func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
    let handledUberURL = UberAppDelegate.shared.application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplicationOpenURLOptionsKey.annotation] as Any)
    
    return handledUberURL
}

func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
    let handledUberURL = UberAppDelegate.shared.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    
    return handledUberURL
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

    //var googleAPIKey = "AIzaSyBPg6a5c6LnUn89J61Zv7rKC-UdsbfKqGU"
	var googleAPIKey = "AIzaSyBmfx4IFOzlx1BkXJgZdzyVsQRyM_yYhPo"

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		
		GMSServices.provideAPIKey(googleAPIKey)
		GMSPlacesClient.provideAPIKey(googleAPIKey)
		
		LyftConfiguration.developer = (token: "XP5RMGxaO8Z6EslNAWrTt5i27XJ3hHvVFaHZtveTk367e00+oksrA3c4U+8+G/RHGCbuHXtINUwSWZ857ySJ8bHrxBUYWyU9sILT39zUeKI7QA0uwNZZ+j8=", clientId: "zHj7ZcmoeZxf")
        
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

