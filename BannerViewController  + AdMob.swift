//
//  BannerVC.swift
//  Ysoftware and tosbaha
//

import Foundation
import iAd
import GoogleMobileAds

class BannerViewController1: UIViewController, ADBannerViewDelegate, GADBannerViewDelegate {

    // MARK: - Set Up

    let BannerViewActionWillBegin = "BannerViewActionWillBegin", BannerViewActionDidFinish = "BannerViewActionDidFinish"
    var _contentViewController:UIViewController!,
    isShowingiAd = true, isShowingAdMob = false

    let _adMobBanner = GADBannerView(adSize: kGADAdSizeBanner),
    _bannerView = ADBannerView(adType: .Banner)
    private var enabled = true

    //AdMob set up
    let adUnitID = "SOME_ID"

    // MARK: - UIViewController

    convenience init(contentController:UIViewController!) {
        self.init()
        _contentViewController = contentController

        //iAd
        _bannerView.delegate = self
        _bannerView.autoresizingMask = .FlexibleWidth

        //AdMob
        _adMobBanner.adUnitID = adUnitID
        _adMobBanner.delegate = self
        _adMobBanner.autoresizingMask = .FlexibleWidth
        _adMobBanner.rootViewController = self
        var request = GADRequest()
        // request.testDevices = [kGADSimulatorID,"1111111"] // you can show test banners for simulator and other devices.
        _adMobBanner.loadRequest(request)
        _adMobBanner.hidden = true
    }

    override func loadView() {
        let contentView = UIView(frame: UIScreen.mainScreen().bounds)
        contentView.addSubview(_bannerView)
        contentView.addSubview(_adMobBanner)
        addChildViewController(_contentViewController)
        contentView.addSubview(_contentViewController.view)
        _contentViewController.didMoveToParentViewController(self)
        self.view = contentView
    }

    override func shouldAutorotate() -> Bool {
        return _contentViewController.shouldAutorotate()
    }

    override func supportedInterfaceOrientations() -> Int {
        return _contentViewController.supportedInterfaceOrientations()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        var contentFrame = view.bounds
        var bannerFrame = CGRectZero

        if enabled {
            _bannerView.autoresizingMask = .FlexibleWidth
            _adMobBanner.autoresizingMask = .FlexibleWidth
            bannerFrame.size = _bannerView.sizeThatFits(contentFrame.size)

            if (_bannerView.bannerLoaded || _adMobBanner.hidden == false) && (enabled == true) {
                contentFrame.size.height -= bannerFrame.size.height
                bannerFrame.origin.y = contentFrame.size.height
            }
            else {
                bannerFrame.origin.y = contentFrame.size.height
            }
        }
        _contentViewController.view.frame = contentFrame
        _bannerView.frame = bannerFrame
        _adMobBanner.frame = bannerFrame
    }

    // MARK: - Methods

    func enabled(value:Bool) {
        enabled = value
        if enabled {
            if _bannerView.superview == nil {
                view.addSubview(_bannerView)
            }
            if _adMobBanner.superview == nil {
                view.addSubview(_adMobBanner)
            }
        }
        else {
            _adMobBanner.removeFromSuperview()
            _bannerView.removeFromSuperview()
        }
        UIView.animateWithDuration(0.25) { () -> Void in
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
    }

    // MARK: - ADBannerViewDelegate

    func bannerViewDidLoadAd(banner: ADBannerView!) {
        _adMobBanner.hidden = true
        _bannerView.hidden = false
        isShowingiAd = true
        isShowingAdMob = false
        UIView.animateWithDuration(0.25) { () -> Void in
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
    }

    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        isShowingiAd = false
        _bannerView.hidden = true
        _adMobBanner.hidden = false
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

    // MARK: - GADBannerViewDelegate

    func adView(view: GADBannerView!, didFailToReceiveAdWithError error: GADRequestError!) {
        isShowingAdMob = false
        _adMobBanner.hidden = true
        UIView.animateWithDuration(0.25) { () -> Void in
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
    }

    func adViewDidReceiveAd(view: GADBannerView!) {
        if (isShowingiAd == false) && (isShowingAdMob == false) {
            _adMobBanner.hidden = false
            isShowingAdMob = true
            UIView.animateWithDuration(0.25) { () -> Void in
                self.view.setNeedsLayout()
                self.view.layoutIfNeeded()
            }
        }
    }
    
}