//
//  OnboardingModelController.swift
//  Pepr
//
//  Created by Kyle Boss on 8/30/16.
//  Copyright © 2016 Kyle Boss. All rights reserved.
//

import UIKit

/*
 A controller object that manages a simple model -- a collection of month names.
 
 The controller serves as the data source for the page view controller; it therefore implements pageViewController:viewControllerBeforeViewController: and pageViewController:viewControllerAfterViewController:.
 It also implements a custom method, viewControllerAtIndex: which is useful in the implementation of the data source 
 methods, and in the initial configuration of the application.
 
 There is no need to actually create view controllers for each page in advance -- indeed doing so incurs unnecessary 
 overhead. Given the data model, these methods create, configure, and return a new view controller on demand.
 */


class OnboardingModelController: NSObject, UIPageViewControllerDataSource {
    
    var blue: UIColor = UIColor(red: 0/255.0, green: 153/255.0, blue: 204/255.0, alpha: 1.0)
    var red: UIColor = UIColor(red: 255/255.0, green: 0/255.0, blue: 102/255.0, alpha: 1.0)
    var green: UIColor = UIColor(red: 0/255.0, green: 204/255.0, blue: 102/255.0, alpha: 1.0)
    var onboardingViews: [OnboardingViewModel]

    override init() {
        let introView: OnboardingViewModel = OnboardingViewModel(backgroundColor: blue, featureIconName: "light-bulb", featureDescription: "Obtaining PEP is quicker & easier than ever before")
        let doctorView: OnboardingViewModel = OnboardingViewModel(backgroundColor: red, featureIconName: "placeholder", featureDescription: "Find an LGBT-friendly doctor nearby whom you can trust.")
        let deliveryView: OnboardingViewModel = OnboardingViewModel(backgroundColor: green, featureIconName: "house", featureDescription: "Once prescribed, we'll take you to a near-by pharmacy")
        onboardingViews = [introView, doctorView, deliveryView]
        super.init()
    }

    func viewControllerAtIndex(index: Int, storyboard: UIStoryboard) -> OnboardingDataViewController? {
        // Return the data view controller for the given index.
        if (OnboardingViewModel.numOnboardingViews == 0) || (index >= OnboardingViewModel.numOnboardingViews) {
            return nil
        }

        // Create a new view controller and pass suitable data.
        let dataViewController = storyboard.instantiateViewControllerWithIdentifier("OnboardingDataViewController") as! OnboardingDataViewController
        dataViewController.onboardingModel = self.onboardingViews[index]
        return dataViewController
    }

    func indexOfViewController(viewController: OnboardingDataViewController) -> Int {
        // Return the index of the given data view controller.
        // For simplicity, this implementation uses a static array of model objects and the view controller stores the 
        // model object; you can therefore use the model object to identify the index.
        return viewController.onboardingModel?.position ?? NSNotFound
    }

    // MARK: - Page View Controller Data Source

    func pageViewController(pageViewController: UIPageViewController,
                            viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var index = self.indexOfViewController(viewController as! OnboardingDataViewController)
        if (index == 0) || (index == NSNotFound) {
            return nil
        }
        
        index -= 1
        return self.viewControllerAtIndex(index, storyboard: viewController.storyboard!)
    }
    
    func pageViewController(pageViewController: UIPageViewController,
                            viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var index = self.indexOfViewController(viewController as! OnboardingDataViewController)
        if index == NSNotFound {
            return nil
        }
        
        index += 1
        if index == self.onboardingViews.count {
//            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//            mainStoryboard.instantiateViewControllerWithIdentifier("MapView")
            return nil
        }
        return self.viewControllerAtIndex(index, storyboard: viewController.storyboard!)
    }

}

