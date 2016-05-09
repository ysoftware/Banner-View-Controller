# Banner View Controller

A port of Apple's BannerViewController to Swift. Requires target of iOS 8.1 or higher.
There is also a pure adMob version.
Works great with both iPad and iPhone.

####Installation

Add files to your project. Don't forget to set the target.

####How to use

This class wraps around your rootViewController, shows the banner and resizes rootViewController with animation. Check AppDelegate.swift for live usage example.

```swift
let bannerVC = BannerViewController(contentController: window.rootViewController)
window.rootViewController = bannerVC
```

For adMob:
```swift
let bannerVC = GoogleBannerViewController(contentController: window?.rootViewController, adUnitId: "your_ad_unit_id")
window.rootViewController = bannerVC
```

####Controlling the banner

You can turn on/off the banner when needed.

```swift
bannerVC.enabled(false) // Removes ad banner from the view hierarchy 
```

Also when ADBannerView state changes these notifications are posted:
```swift
BannerViewActionWillBegin // User clicked on banner
BannerViewActionDidFinish // User dismissed the full screen experience
BannerViewDidFailToReceiveAdWithError // Banner didn't load. Get description from userinfo["error"] (String)
BannerViewDidLoadAd // Ad banner successfully loaded
```

Watch "Optimize Your Earning Power With iAd" from WWDC 2014 to for more details.
