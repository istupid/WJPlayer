//
//  AppDelegate.swift
//  PlayerPro
//
//  Created by William on 2019/4/19.
//  Copyright © 2019 William. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow()
        window?.backgroundColor = UIColor.white
        window?.rootViewController = ViewController()
        window?.makeKeyAndVisible()
        
        /// 应用称为第一响应者
        UIApplication.shared.becomeFirstResponder()
        /// 开启可以接受远程事件
        UIApplication.shared.beginReceivingRemoteControlEvents()
        
        return true
    }
    
    override func becomeFirstResponder() -> Bool {
        return true
    }
    
    func registerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(setRootViewController(n:)), name: NSNotification.Name(kChangeRootViewController), object: nil)
    }
    
    @objc private func setRootViewController(n: Notification) {
        if n.object == nil {
            
        } else {
            
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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

    /// 系统远程事件
    override func remoteControlReceived(with event: UIEvent?) {
        if event?.type == UIEvent.EventType.remoteControl {
            switch event?.subtype {
            case .remoteControlPlay?:
                WJMusicPlayerViewModel.sharedInstance.play()
                break
            case .remoteControlPause?:
                WJMusicPlayerViewModel.sharedInstance.pause()
                break
            case .remoteControlStop?:
                WJMusicPlayerViewModel.sharedInstance.pause()
                break
            case .remoteControlNextTrack?:
                WJMusicPlayerViewModel.sharedInstance.next()
                break
            case .remoteControlPreviousTrack?:
                WJMusicPlayerViewModel.sharedInstance.forward()
                break
            default:
                break
            }
        }
    }
}

