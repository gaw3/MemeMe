//
//  AppDelegate.swift
//  MemeMe
//
//  Created by Gregory White on 10/5/15.
//  Copyright © 2015 Gregory White. All rights reserved.
//

import UIKit

import SwiftyBeaver

let log = SwiftyBeaver.self

// MARK: -
// MARK: - 

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        initLogging()
        return true
    }
    
}



// MARK: -
// MARK: - Private Helpers

private extension AppDelegate {
    
    enum SB {
        
        enum Console {
            static let format   = "[$Dyyyy-MM-dd HH:mm:ss.SSS$d], $T, $C$L$c, $N.$F:$l, $M"
            static var minLevel = SwiftyBeaver.Level.verbose
        }
        
    }
    
    func initLogging() {
        let console = ConsoleDestination()
        
        console.format         = SB.Console.format
        console.asynchronously = false
        console.minLevel       = SB.Console.minLevel
        
        log.addDestination(console)
    }

}
