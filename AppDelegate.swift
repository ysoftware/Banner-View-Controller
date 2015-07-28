//
//  AppDelegate.swift
//  Ysoftware
//
//  Created by Yaroslav Erohin on 22.06.15.
//  Copyright © 2015 Yaroslav Erohin. All rights reserved.
//

import UIKit
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        setUpiAd()

        return true
    }

    func setUpiAd() {
        let shouldShowAds = true // put your code here
        if let window = self.window {
            if let rootVC = window.rootViewController {

                if shouldShowAds {
                    if let bannerVC = rootVC as? BannerViewController {
                        bannerVC.enabled(false)
                    }
                }
                else{
                    if !rootVC.isKindOfClass(BannerViewController) {
                        let bannerVC = BannerViewController(contentController: rootVC)
                        window.rootViewController = bannerVC
                    }
                }
            }
        }
    }
    
}