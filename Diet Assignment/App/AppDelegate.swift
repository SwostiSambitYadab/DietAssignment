//
//  AppDelegate.swift
//  Diet Assignment
//
//  Created by Swosti Sambit Yadab on 21/06/25.
//

import Foundation
import UIKit


class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        NetworkMonitor.shared.startMonitoring()
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        NetworkMonitor.shared.stopMonitoring()
    }
}

