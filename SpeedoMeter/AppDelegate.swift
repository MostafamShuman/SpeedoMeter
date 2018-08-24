//
//  AppDelegate.swift
//  SpeedoMeter
//
//  Created by Mostafa Shuman on 8/16/18.
//  Copyright © 2018 Mostafa Shuman. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let mainAssembler = MainAssembler()
    let locationAuthorization: SPDLocationAuthorization
    
    override init(){
        locationAuthorization = mainAssembler.resolver.resolve(SPDLocationAuthorization.self)!
        super.init()
        locationAuthorization.delegate = self
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        locationAuthorization.checkAuthorization()
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) { }
    
    func applicationDidEnterBackground(_ application: UIApplication) { }
    
    func applicationWillEnterForeground(_ application: UIApplication) { }
    
    func applicationDidBecomeActive(_ application: UIApplication) { }
    
    func applicationWillTerminate(_ application: UIApplication) { }
}

extension AppDelegate: SPDLocationAuthorizationDelegate {
    func authorizationDenied(for locationAuthorization: SPDLocationAuthorization) {
        let alertController = UIAlertController(title: "Permission Denied", message: "Speedometer needs access to your location to function", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
}
