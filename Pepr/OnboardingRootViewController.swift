//
//  OnboardingRootViewController.swift
//  Pepr
//
//  Created by Kyle Boss on 8/30/16.
//  Copyright © 2016 Kyle Boss. All rights reserved.
//

import UIKit

class OnboardingRootViewController: UIViewController, UIPageViewControllerDelegate {

    var pageViewController: UIPageViewController?


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Configure the page view controller and add it as a child view controller.
        self.pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal,
                                                       options: nil)
        self.pageViewController!.delegate = self

        let startingViewController: OnboardingDataViewController = self.modelController.viewControllerAtIndex(0, storyboard: self.storyboard!)!
        let viewControllers = [startingViewController]
        self.pageViewController!.setViewControllers(viewControllers, direction: .Forward, animated: false,
                                                    completion: {done in })

        self.pageViewController!.dataSource = self.modelController

        self.addChildViewController(self.pageViewController!)
        self.view.addSubview(self.pageViewController!.view)

        // Set the page view controller's bounds using an inset rect so that self's view is visible around the edges of 
        // the pages.
        var pageViewRect = self.view.bounds
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            pageViewRect = pageViewRect.insetBy(dx: 40.0, dy: 40.0)
        }
        self.pageViewController!.view.frame = pageViewRect
        self.pageViewController!.didMoveToParentViewController(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var modelController: OnboardingModelController {
        // Return the model controller object, creating it if necessary.
        // In more complex implementations, the model controller may be passed to the view controller.
        if _modelController == nil {
            _modelController = OnboardingModelController()
        }
        return _modelController!
    }

    var _modelController: OnboardingModelController? = nil

    // MARK: - UIPageViewController delegate methods

    func pageViewController(pageViewController: UIPageViewController,
                            spineLocationFor orientation: UIInterfaceOrientation) -> UIPageViewControllerSpineLocation {
        // In portrait orientation or on iPhone: Set the spine position to "min" and the page view controller's view 
        // controllers array to contain just one view controller. Setting the spine position to 
        // 'UIPageViewControllerSpineLocationMid' in landscape orientation sets the doubleSided property to true, so 
        // set it to false here.
        let currentViewController = self.pageViewController!.viewControllers![0]
        let viewControllers = [currentViewController]
        self.pageViewController!.setViewControllers(viewControllers, direction: .Forward, animated: true,
                                                    completion: {done in })
        
        self.pageViewController!.doubleSided = false
        return .Min
    }


}

