# Banner-View-Controller

A port of Apple's BannerViewController to Swift. Required target of iOS 8.1 or higher.

Install:
Add BannerViewController.swift to your project. Don't forget to set the target.

How to use:

        if let window = self.window {
            if let rootVC = window.rootViewController {

                if IAPShare.sharedHelper().iap.isPurchasedProductsIdentifier(Constants.InAppPurchases.RemoveAds) {
                    if let bannerVC = rootVC as? BannerViewController {
                        bannerVC.enabled(false)
                    }
                }
                else{
                    if !rootVC.isKindOfClass(BannerViewController) {
                        let bannerVC = BannerViewController(contentController: rootVC)
                        window.rootViewController = bannerVC
                    }
                }
            }
        }
        
Controlling the banner:

        bannerViewController.enabled(false) //Removes ad banner from the view hierarchy 


Watch "Optimize Your Earning Power With iAd" from WWDC 2014 to for more details.
