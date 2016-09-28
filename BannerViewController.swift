//
//  BannerVC.swift
//  Ysoftware
//
//  Created by Yaroslav Erohin on 29.06.15.
//  Copyright © 2015 Yaroslav Erohin. All rights reserved.
//

import UIKit
import iAd

class BannerViewController: UIViewController, ADBannerViewDelegate {

    static let BannerViewActionWillBegin = "BannerViewActionWillBegin", BannerViewActionDidFinish = "BannerViewActionDidFinish",
    BannerViewDidFailToReceiveAdWithError = "BannerViewDidFailToReceiveAdWithError", BannerViewDidLoadAd = "BannerViewDidLoadAd"

    func updateView() {
        view.setNeedsLayout()
        view.layoutIfNeeded()
        _contentViewController.view.setNeedsLayout()
        _contentViewController.view.layoutIfNeeded()
    }

    var _contentViewController:UIViewController!

    private var _bannerView = ADBannerView(adType: .Banner)
    private var enabled = true

    // MARK: - Methods

    /// Set 'true' to enable banner rotation, 'false' to remove banner from view hierarchy
    func setEnabled(value:Bool, animated:Bool) {
        enabled = value
        if enabled {
            _bannerView.delegate = self
            if _bannerView.superview == nil {
                view.addSubview(_bannerView)
            }
        }
        else {
            _bannerView.delegate = nil
            _bannerView.removeFromSuperview()
        }

        if animated {
            UIView.animateWithDuration(0.25) {
                self.updateView()
            }
        }
        else {
            updateView()
        }
    }

    // MARK: - UIViewController

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

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return _contentViewController.supportedInterfaceOrientations()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        var contentFrame = view.bounds
        var bannerFrame = CGRectZero

        if enabled {
            _bannerView.autoresizingMask = .FlexibleWidth
            bannerFrame.size = _bannerView.sizeThatFits(contentFrame.size)

            if _bannerView.bannerLoaded {
                contentFrame.size.height -= bannerFrame.size.height
                bannerFrame.origin.y = contentFrame.size.height
            }
            else {
                bannerFrame.origin.y = contentFrame.size.height
            }
        }

        _contentViewController.view.frame = contentFrame
        _bannerView.frame = bannerFrame
    }

    // MARK: - ADBannerViewDelegate

    func bannerViewDidLoadAd(banner: ADBannerView!) {
        (UIApplication.sharedApplication().delegate as! AppDelegate).setUpiAd()
        UIView.animateWithDuration(0.25, animations: {
            self.updateView()
            }) { _ in
                NSNotificationCenter.defaultCenter().postNotificationName(BannerViewController.BannerViewDidLoadAd, object: self)
        }
    }

    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.updateView()
            }) { _ in
                NSNotificationCenter.defaultCenter().postNotificationName(BannerViewController.BannerViewDidFailToReceiveAdWithError, object: self)
        }
    }

    func bannerViewActionShouldBegin(banner: ADBannerView!, willLeaveApplication willLeave: Bool) -> Bool {
        NSNotificationCenter.defaultCenter().postNotificationName(BannerViewController.BannerViewActionWillBegin, object: self)
        return true
    }

    func bannerViewActionDidFinish(banner: ADBannerView!) {
        NSNotificationCenter.defaultCenter().postNotificationName(BannerViewController.BannerViewActionDidFinish, object: self)
    }
    
}
