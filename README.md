# Banner-View-Controller

A port of Apple's BannerViewController to Swift. Required target of iOS 8.1 or higher.

Install:
Add BannerViewController.swift to your project. Don't forget to set the target.

How to use:

```swift
let bannerVC = BannerViewController(contentController: window.rootViewController)
 window.rootViewController = bannerVC
```

Controlling the banner:

```swift
bannerVC.enabled(false) //Removes ad banner from the view hierarchy 
```


Watch "Optimize Your Earning Power With iAd" from WWDC 2014 to for more details.
