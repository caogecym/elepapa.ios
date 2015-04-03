//
//  AppDelegate.swift
//  elepapa.ios
//
//  Created by Yuming Cao on 11/26/14.
//  Copyright (c) 2014 papa. All rights reserved.
//

import UIKit

public func getPapaIdFromUrl(url: NSURL) -> Int {
    if let urlStr = url.absoluteString? {
        let urlArr = split(urlStr) {$0 == "/"}
        let proto: String = urlArr[0]
        let path: String? = urlArr.count > 1 ? urlArr[1] : nil
        if let papaId = path?.toInt() {
            return papaId
        }
    }
    return -1
}

func createPapaViewController(papaId: Int) -> DetailViewController? {
    // TODO: add navigator
    // expected behavior: should be able to nav to home page, i.e. nav controller
    if (papaId == -1) {
        println("no valid papa id detected")
        return nil
    }
    
    let papa = PapaModel(id: papaId, title: "", imageURL: nil)
    var pvc = DetailViewController()
    pvc.detailItem = papa
    pvc.papaDetailView = UIWebView(frame: UIScreen.mainScreen().bounds)
    pvc.view.addSubview(pvc.papaDetailView)
    return pvc
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        WXApi.registerApp("elepapa")
        return true
    }
    
    func displayPapa(pvc: DetailViewController) {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window!.rootViewController = pvc
        self.window!.makeKeyAndVisible()
    }
    
    func application(application: UIApplication, openURL url: NSURL,
                     sourceApplication: String?, annotation: AnyObject?) -> Bool {
                        
        let papaId = getPapaIdFromUrl(url)
        if let pvc = createPapaViewController(papaId) {
            displayPapa(pvc)
        }
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

