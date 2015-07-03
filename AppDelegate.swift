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
        let shouldShowAds = NSUserDefaults.standardUserDefaults().objectForKey(Constants.UserDefaults.AdsDisabled) == nil
        guard let window = self.window else { return }
        guard let rootVC = window.rootViewController else { return }

        if shouldShowAds {
            if !rootVC.isKindOfClass(BannerViewController) {
                let bannerVC = BannerViewController(contentController: rootVC)
                window.rootViewController = bannerVC
            }
        }
        else{
            guard let bannerVC = rootVC as? BannerViewController else { return }
            window.rootViewController = bannerVC._contentViewController
        }
    }

}

