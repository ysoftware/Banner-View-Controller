//
//  BannerVC.swift
//  Ysoftware
//
//  Created by Ярослав Ерохин on 29.06.15.
//  Copyright © 2015 Yaroslav Erohin. All rights reserved.
//

import UIKit
import iAd

class BannerViewController: UIViewController, ADBannerViewDelegate {

    let BannerViewActionWillBegin = "BannerViewActionWillBegin",
    BannerViewActionDidFinish = "BannerViewActionDidFinish"

    var _contentViewController:UIViewController!
    let _bannerView = ADBannerView(adType: .Banner)

    convenience init(contentController:UIViewController!) {
        self.init()
        _contentViewController = contentController
        _bannerView.delegate = self
        _bannerView.autoresizingMask = .FlexibleWidth
    }

    override func loadView() {
        let contentView = UIView(frame: UIScreen.mainScreen().bounds)
        contentView.addSubview(_bannerView)
        addChildViewController(_contentViewController)
        contentView .addSubview(_contentViewController.view)
        _contentViewController.didMoveToParentViewController(self)
        view = contentView
    }

    override func shouldAutorotate() -> Bool {
        return _contentViewController.shouldAutorotate()
    }

    override func supportedInterfaceOrientations() -> Int {
        return _contentViewController.supportedInterfaceOrientations()
    }

    override func viewDidLayoutSubviews() {
        var contentFrame = view.bounds
        var bannerFrame = CGRectZero

        _bannerView.autoresizingMask = .FlexibleWidth
        bannerFrame.size = _bannerView.sizeThatFits(contentFrame.size)

        if _bannerView.bannerLoaded {
            contentFrame.size.height -= bannerFrame.size.height
            bannerFrame.origin.y = contentFrame.size.height
        }
        else {
            bannerFrame.origin.y = contentFrame.size.height
        }

        _contentViewController.view.frame = contentFrame
        _bannerView.frame = bannerFrame
    }

    func bannerViewDidLoadAd(banner: ADBannerView!) {
//        print("banner loaded")
        UIView.animateWithDuration(0.25) { () -> Void in
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
    }

    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
//        print("banner didn't load")
        UIView.animateWithDuration(0.25) { () -> Void in
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
    }

    func bannerViewActionShouldBegin(banner: ADBannerView!, willLeaveApplication willLeave: Bool) -> Bool {
        NSNotificationCenter.defaultCenter().postNotificationName(BannerViewActionWillBegin, object: self)
        return true
    }

    func bannerViewActionDidFinish(banner: ADBannerView!) {
        NSNotificationCenter.defaultCenter().postNotificationName(BannerViewActionDidFinish, object: self)
    }
    
}

