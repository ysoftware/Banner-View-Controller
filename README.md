# Banner View Controller

A port of Apple's BannerViewController to Swift. Requires target of iOS 8.1 or higher.

####Installation

Add BannerViewController.swift to your project. Don't forget to set the target.

####How to use

BannerViewController wraps around your rootViewController, shows iAd banner and resizes rootViewController with animation.

```swift
let bannerVC = BannerViewController(contentController: window.rootViewController)
window.rootViewController = bannerVC
```

####Controlling the banner:

You can turn on or off the banner when needed.

```swift
bannerVC.enabled(false) //Removes ad banner from the view hierarchy 
```

```swift
Also when banner state changes these notifications are posted:
BannerViewActionWillBegin // User clicked on banner
BannerViewActionDidFinish //User dismissed the full screen experience
BannerViewDidFailToReceiveAdWithError //Banner didn't load. Get description from userinfo["error"] (String)
BannerViewDidLoadAd //Ad banner successfully loaded
```

Watch "Optimize Your Earning Power With iAd" from WWDC 2014 to for more details.
