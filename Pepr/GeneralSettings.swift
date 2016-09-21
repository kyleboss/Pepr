//
//  GeneralSettings.swift
//  Pepr
//
//  Created by Kyle Boss on 8/31/16.
//  Copyright © 2016 Kyle Boss. All rights reserved.
//

import Foundation

class GeneralSettings: NSObject {
    class func isOnboardingFinished() -> Bool {
        return NSUserDefaults.standardUserDefaults().boolForKey("hasOnboarder")
    }
}
