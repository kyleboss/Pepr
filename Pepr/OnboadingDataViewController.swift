//
//  OnboardingDataViewController.swift
//  Pepr
//
//  Created by Kyle Boss on 8/30/16.
//  Copyright © 2016 Kyle Boss. All rights reserved.
//

import UIKit

class OnboardingDataViewController: UIViewController {

    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var descriptionLabel: UITextView!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var getStartedButton: UIButton!
    @IBAction func getStartedPressed(sender: AnyObject) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nextViewController = mainStoryboard.instantiateViewControllerWithIdentifier("MapView") as! MapEventController
        self.presentViewController(nextViewController, animated:true, completion:nil)
    }
    var onboardingModel: OnboardingViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.descriptionLabel!.text = onboardingModel?.featureDescription
        self.icon.image = onboardingModel?.featureIcon
        self.view.backgroundColor = onboardingModel?.backgroundColor
        self.pageControl.numberOfPages = OnboardingViewModel.numOnboardingViews
        self.pageControl.currentPage = (onboardingModel?.position)!
        self.getStartedButton.contentEdgeInsets = UIEdgeInsetsMake(20, 20, 20, 20);
        if (self.pageControl.numberOfPages-1 == self.pageControl.currentPage) {
            self.pageControl.hidden = true
            self.getStartedButton.hidden = false
        } else {
            self.pageControl.hidden = false
            self.getStartedButton.hidden = true
        }
    }


}

