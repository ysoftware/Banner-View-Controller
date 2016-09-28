//
//  BannerViewController.swift
//  Ysoftware
//
//  Created by Yaroslav Erohin on 05.05.16.
//  Copyright © 2016 Yaroslav Erohin. All rights reserved.
//

import UIKit
import GoogleMobileAds

final class BannerViewController: UIViewController, GADBannerViewDelegate {

    static let BannerViewActionWillBegin = "BannerViewActionWillBegin", BannerViewActionDidFinish = "BannerViewActionDidFinish",
    BannerViewDidFailToReceiveAd = "BannerViewDidFailToReceiveAdWithError", BannerViewDidLoadAd = "BannerViewDidLoadAd"

    /// BannerViewController wraps around this view controller to show ads.
    var _contentViewController:UIViewController!

    /// When ad cannot be loaded, these views will appear. If this array is empty, banner will hide with animation.
    var fallbackViews:[UIView] = []

    fileprivate var enabled = true
    fileprivate var bannerLoaded = false
    fileprivate var _bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)

    fileprivate var _fallbackView:UIView?

    fileprivate var isLandscape:Bool {
        return UIApplication.shared.statusBarOrientation.isLandscape
    }

    // MARK: - Methods

    /// Set 'true' to enable banner rotation, 'false' to remove banner from view hierarchy
    func setEnabled(_ value:Bool, animated:Bool) {
        enabled = value

        if enabled {
            if _bannerView.superview == nil {
                view.addSubview(_bannerView)
            }
            let request = GADRequest()
            request.testDevices = [kGADSimulatorID, "480fffafb3ce50a6066f2814e15d53b6"]
            _bannerView.load(request)
            _bannerView.isAutoloadEnabled = true
        }
        else {
            _bannerView.removeFromSuperview()
            _bannerView.isAutoloadEnabled = false
        }

        UIView.animate(withDuration: animated ? 0.25 : 0, animations: {
            self.updateView()
        }) 
    }

    fileprivate func updateView() {
        view.setNeedsLayout()
        view.layoutIfNeeded()
        _contentViewController.view.setNeedsLayout()
        _contentViewController.view.layoutIfNeeded()
    }

    // MARK: - UIViewController overrides

    convenience init(contentController:UIViewController!, adUnitId:String) {
        self.init()
        _contentViewController = contentController
        _bannerView.delegate = self
        _bannerView.isAutoloadEnabled = false
        _bannerView.autoresizingMask = .flexibleWidth
        _bannerView.adUnitID = adUnitId
        setEnabled(enabled, animated: false)
    }

    override func loadView() {
        super.loadView()

        _bannerView.autoresizingMask = .flexibleWidth
        _bannerView.rootViewController = self

        let contentView = UIView(frame: UIScreen.main.bounds)
        contentView.addSubview(_bannerView)
        addChildViewController(_contentViewController)
        contentView.addSubview(_contentViewController.view)
        _contentViewController.didMove(toParentViewController: self)
        view = contentView
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        var contentFrame = view.bounds
        var bannerFrame = CGRect.zero
        var fallbackFrame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 0)

        if enabled {
            if bannerLoaded {
                bannerFrame.size = _bannerView.sizeThatFits(view.bounds.size)
                contentFrame.size.height -= bannerFrame.size.height
                bannerFrame.origin.y = contentFrame.size.height
                _bannerView.frame = bannerFrame

                for s in view.subviews {
                    if s is FallbackBanner {
                        s.removeFromSuperview()
                    }
                }
            }
            else if fallbackViews.count > 0 {
                _fallbackView = fallbackViews.randomItem()
                if let fbv = _fallbackView {
                    view.addSubview(fbv)
                }
                _fallbackView?.autoresizingMask = .flexibleWidth

                fallbackFrame.size = CGSize(width: view.bounds.width, height: min(70, view.bounds.height / 10))
                contentFrame.size.height -= fallbackFrame.size.height
                fallbackFrame.origin.y = contentFrame.size.height
                _fallbackView?.frame = fallbackFrame
            }
        }

        _contentViewController.view.frame = contentFrame
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        updateView()
    }

    override var shouldAutorotate : Bool {
        return _contentViewController.shouldAutorotate
    }

    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return _contentViewController.supportedInterfaceOrientations
    }

    override var childViewControllerForStatusBarStyle : UIViewController? {
        return _contentViewController
    }

    override var childViewControllerForStatusBarHidden : UIViewController? {
        return _contentViewController
    }

    // MARK: - GADBannerViewDelegate

    func adView(_ view: GADBannerView!, didFailToReceiveAdWithError error: GADRequestError!) {
        print("AdMob banner: ad failed (\(error.localizedDescription))")
        bannerLoaded = false

        UIView.animate(withDuration: 0.25, animations: {
            self.updateView()
        }) { _ in
            NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: BannerViewController.BannerViewDidFailToReceiveAd), object: self))
        }
    }

    func adViewDidReceiveAd(_ view: GADBannerView!) {
        print("AdMob banner: loaded ad")
        bannerLoaded = true

        UIView.animate(withDuration: 0.25, animations: {
            self.updateView()
        }) { _ in
            NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: BannerViewController.BannerViewDidLoadAd), object: self))
        }
    }

    func adViewDidDismissScreen(_ bannerView: GADBannerView!) {
        print("AdMob banner: did dismiss screen")
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: BannerViewController.BannerViewActionDidFinish), object: self))
    }

    func adViewWillPresentScreen(_ bannerView: GADBannerView!) {
        print("AdMob banner: will present screen")
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: BannerViewController.BannerViewActionWillBegin), object: self))
    }
    
    
}

