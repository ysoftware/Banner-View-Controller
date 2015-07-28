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
        //Replace rootViewController with BannerViewController (with rootViewController inside)
        if !(window?.rootViewController is BannerViewController) {
            let bannerVC = BannerViewController(contentController: window?.rootViewController)
            window?.rootViewController = bannerVC
        }

        if let bannerVC = window?.rootViewController as? BannerViewController {
            //Set banner rotation on or off
            if IAPShare.sharedHelper().iap.isPurchasedProductsIdentifier(Constants.InAppPurchases.RemoveAds) {
                bannerVC.enabled(false)
            }
            else{
                bannerVC.enabled(true)
            }
        }
    }

}