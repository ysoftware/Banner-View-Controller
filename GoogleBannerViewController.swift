//
//  GoogleBannerViewController.swift
//  Ysoftware
//
//  Created by Yaroslav Erohin on 05.05.16.
//  Copyright © 2016 Yaroslav Erohin. All rights reserved.
//

import UIKit
import GoogleMobileAds

class GoogleBannerViewController: UIViewController, GADBannerViewDelegate {

    static let BannerViewActionWillBegin = "BannerViewActionWillBegin", BannerViewActionDidFinish = "BannerViewActionDidFinish",
    BannerViewDidFailToReceiveAd = "BannerViewDidFailToReceiveAdWithError", BannerViewDidLoadAd = "BannerViewDidLoadAd"

    func updateView() {
        view.setNeedsLayout()
        view.layoutIfNeeded()
        _contentViewController.view.setNeedsLayout()
        _contentViewController.view.layoutIfNeeded()
    }

    var _contentViewController:UIViewController!

    private var _bannerView = GADBannerView(adSize: UIApplication.sharedApplication().statusBarOrientation.isLandscape ? kGADAdSizeSmartBannerLandscape : kGADAdSizeSmartBannerPortrait)
    private var enabled = true
    private var bannerLoaded = false

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

    convenience init(contentController:UIViewController!, adUnitId:String) {
        self.init()
        _contentViewController = contentController
        _bannerView.delegate = self
        _bannerView.autoresizingMask = .FlexibleWidth
        _bannerView.adUnitID = adUnitId
    }

    override func loadView() {
        super.loadView()

        _bannerView.delegate = self
        _bannerView.autoresizingMask = .FlexibleWidth
        _bannerView.rootViewController = self
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        _bannerView.loadRequest(request)

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

            if bannerLoaded {
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

    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)

        _bannerView.adSize = UIApplication.sharedApplication().statusBarOrientation.isLandscape ? kGADAdSizeSmartBannerLandscape : kGADAdSizeSmartBannerPortrait
    }

    // MARK: - GADBannerViewDelegate

    func adView(view: GADBannerView!, didFailToReceiveAdWithError error: GADRequestError!) {
        bannerLoaded = false
        NSNotificationCenter.defaultCenter().postNotificationName(GoogleBannerViewController.BannerViewDidFailToReceiveAd, object: self)
        UIView.animateWithDuration(0.25) {
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
    }

    func adViewDidReceiveAd(view: GADBannerView!) {
        bannerLoaded = true
        NSNotificationCenter.defaultCenter().postNotificationName(GoogleBannerViewController.BannerViewDidLoadAd, object: self)
        UIView.animateWithDuration(0.25) {
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
    }

    func adViewDidDismissScreen(bannerView: GADBannerView!) {
        NSNotificationCenter.defaultCenter().postNotificationName(GoogleBannerViewController.BannerViewActionDidFinish, object: self)
    }

    func adViewWillPresentScreen(bannerView: GADBannerView!) {
        NSNotificationCenter.defaultCenter().postNotificationName(GoogleBannerViewController.BannerViewActionWillBegin, object: self)
    }
    
    
}

