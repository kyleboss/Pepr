//
//  OnboardingView.swift
//  Pepr
//
//  Created by Kyle Boss on 8/31/16.
//  Copyright © 2016 Kyle Boss. All rights reserved.
//

import Foundation
import UIKit

class OnboardingViewModel {
    
    var backgroundColor: UIColor
    var featureDescription: String = ""
    var featureIcon: UIImage?
    var position: Int
    static var numOnboardingViews: Int = 0

    init(backgroundColor: UIColor, featureIconName:String, featureDescription: String) {
        self.backgroundColor = backgroundColor
        self.featureDescription = featureDescription
        self.featureIcon = UIImage(named: featureIconName)
        position = OnboardingViewModel.numOnboardingViews
        OnboardingViewModel.numOnboardingViews += 1
    }
}
