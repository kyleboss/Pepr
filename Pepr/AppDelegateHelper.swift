//
//  AppDelegateHelper.swift
//  Pepr
//
//  Created by Kyle Boss on 8/31/16.
//  Copyright © 2016 Kyle Boss. All rights reserved.
//

import Foundation
import UIKit

class AppDelegateHelper: NSObject {
    
    class func setInitialViewController(window: UIWindow?) -> Void {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let onboardingStoryboard: UIStoryboard = UIStoryboard(name: "Onboarding", bundle: nil)
        var initialViewController: UIViewController
        if GeneralSettings.isOnboardingFinished() == false {
            initialViewController = onboardingStoryboard.instantiateViewControllerWithIdentifier("OnboardingRootViewController") as! OnboardingRootViewController
        } else {
            initialViewController = mainStoryboard.instantiateViewControllerWithIdentifier("MapView")
        }
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "hasOnboarder")
        window?.rootViewController = initialViewController
        window?.makeKeyAndVisible()
    }
}
