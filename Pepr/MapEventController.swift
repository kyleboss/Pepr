//
//  MapEventController.swift
//  Mega
//
//  Created by Tope Abayomi on 08/12/2014.
//  Copyright (c) 2014 App Design Vault. All rights reserved.
//

import Foundation
import UIKit
import ArcGIS
import CoreLocation
import UberRides
import SwiftSpinner
import Darwin
import SCLAlertView
import DGRunkeeperSwitch
import MessageUI

class MapEventController: UIViewController, UITableViewDelegate, UITableViewDataSource, AGSMapViewLayerDelegate, AGSCalloutDelegate, AGSMapViewTouchDelegate {
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var uberButtonContainer: UIView!
    @IBOutlet weak var rideButton: UIButton!
    @IBAction func rideButtonPressed(sender: AnyObject) {
        let appearance = SCLAlertView.SCLAppearance(showCloseButton: false, hideWhenBackgroundViewIsTapped: true)
        let alertView = SCLAlertView(appearance: appearance)
        let address = alertView.addTextField("Pick-up Address")
        let phone = alertView.addTextField("Phone")
        alertView.addButton("Request Ride!"){
            if (address.text != "" && phone.text != "") {
                var body = "PEPr Request:\r\nPhone: \(phone.text!)\r\nPick-up: \(address.text!)\r\nDrop-off: \((self.currentlySelectedSubject?.location.streetAddress)!)"
                body = body.substringToIndex(body.startIndex.advancedBy(min(body.characters.count, 159)))
                print(body)
                let URL: NSURL = NSURL(string: "https://pepr-server.herokuapp.com/message")!
                let request:NSMutableURLRequest = NSMutableURLRequest(URL:URL)
                request.HTTPMethod = "POST"
                let bodyData = "body=\(body)&to=+19316241119"
                request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding)
                    NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue())
                    {
                        (response, data, error) in
                        let appearance = SCLAlertView.SCLAppearance(hideWhenBackgroundViewIsTapped: true)
                        let alertView = SCLAlertView(appearance: appearance)
                        alertView.showSuccess("Be Right There!", subTitle: "Your ride will contact you soon!", duration: 3)
                }
            } else {
                let appearance = SCLAlertView.SCLAppearance(hideWhenBackgroundViewIsTapped: true)
                let alertView = SCLAlertView(appearance: appearance)
                alertView.showError("Uh oh...", subTitle: "We had trouble sending your ride request. Make sure all information is entered.", duration: 3)
            }
        }

        alertView.showEdit("We'll take you!", subTitle: "Homobiles is a queer-friendly, donation-based organization.")
    }
    @IBAction func callButtonPressed(sender: AnyObject) {
        checkIfHasDrugs = true
        //let url:NSURL = NSURL(string: "tel://\(currentlySelectedSubject!.phone.number)")!
        let url:NSURL = NSURL(string: "tel://9316241119")!
        UIApplication.sharedApplication().openURL(url)
    }
    @IBOutlet weak var mapView: AGSMapView!
    @IBOutlet var eventsTableView : UITableView!
    @IBOutlet weak var uberBtnContainer: UIView!
    
    var events : [EventModel]!
    var locationManager: LocationManager?
    var map: MapModel!
    var doctors: [DoctorModel] = []
    var pharmacies: [PharmacyModel] = []
    var hasPharmacies = false
    var mapEventControllerHelper: MapEventControllerHelper?
    var uberClient = UberClient()
    var loadingView: UIView?
    var currentlySelectedSubject: MapEventSubjectModel?
    var checkIfHasDrugs = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSegmentedControl()
        self.loadingView = UIView(frame: view.bounds)
        loadingView!.contentMode = .ScaleAspectFill
        loadingView!.clipsToBounds = true
        loadingView!.center = view.center
        loadingView!.backgroundColor = UIColor(red: 0, green: 204/255, blue: 1, alpha: 1)
        view.addSubview(loadingView!)
        SwiftSpinner.useContainerView(loadingView)
        SwiftSpinner.setTitleFont(UIFont(name: "Futura", size: 30.0))
        SwiftSpinner.show("Loading...")
        self.mapView.layerDelegate = self
        self.mapView.touchDelegate = self
        self.mapView.callout.delegate = self
        
        mapEventControllerHelper = MapEventControllerHelper(mapEventController: self)
        map = MapModel(mapView: mapView)
        map.initMap()
        map.setClient()
        hasPharmacies = false
        locationManager = LocationManager(mapEventController: self)
        locationManager!.setupLocationTracking()
        mapEventControllerHelper!.setupUIElements()
        mapView.callout.accessoryButtonHidden = true
        events = []
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(willEnterForeground), name: UIApplicationDidBecomeActiveNotification, object: nil)
    }
    
    func setupSegmentedControl() {
        let runkeeperSwitch = DGRunkeeperSwitch(titles: ["Doctors", "Pharmacies"])
        runkeeperSwitch.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 128/255.0, alpha: 1.0)
        runkeeperSwitch.selectedBackgroundColor = .whiteColor()
        runkeeperSwitch.titleColor = .whiteColor()
        runkeeperSwitch.selectedTitleColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 129/255.0, alpha: 1.0)
        runkeeperSwitch.titleFont = UIFont(name: "HelveticaNeue-Medium", size: 16.0)
        runkeeperSwitch.frame = CGRect(x: 50.0, y: 20.0, width: view.bounds.width - 100.0, height: 50.0)
        runkeeperSwitch.autoresizingMask = [.FlexibleWidth]
        runkeeperSwitch.addTarget(self, action: #selector(self.subjectSwitched(_:)), forControlEvents: .ValueChanged)
        view.addSubview(runkeeperSwitch)
    }
    
    func willEnterForeground() {
        if (checkIfHasDrugs) {
            if (currentlySelectedSubject == nil || currentlySelectedSubject!.type == "Doctor") { return
            }
            let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
            let alertView = SCLAlertView(appearance: appearance)
            alertView.addButton("They had it!"){
                print("They had it!")
            }
            alertView.addButton("Nope") {
                print("Nope :(")
            }
            alertView.showInfo("Just checking", subTitle: "Did \(currentlySelectedSubject!.name) have the medications you needed?")
            checkIfHasDrugs = false
        }
    }
    
    override func viewDidLayoutSubviews() {
    }
        
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("EventCell") as! EventCell
        // cell.selectedBackgroundView = cell.backgroundView
        // cell.selectedBackgroundView!.backgroundColor = .greenColor()

        let subject = events[indexPath.row]
        cell.titleLabel.text = subject.title
        cell.descriptionLabel.text = subject.description
        cell.typeImageView.image = subject.type == "Doctor" ? UIImage(named: "doctor-icon") : UIImage(named: "pharmacy-icon")
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell: EventCell? = tableView.cellForRowAtIndexPath(indexPath) as? EventCell
        if (cell != nil) {
            cell!.descriptionLabel.textColor = UIColor.blackColor()
        }
        let subject = events[indexPath.row].subject
        let spatialReference = AGSSpatialReference(WKID: 4326)
        let point = AGSPoint(x: subject.location.latitude!, y: subject.location.longitude!, spatialReference: spatialReference)
        let graphic = self.map.graphicLayer.graphics[indexPath.row] as! AGSFeature
        currentlySelectedSubject = subject
        self.mapView.callout.showCalloutAtPoint(point, forFeature: graphic, layer: self.map.graphicLayer, animated: true)
        //let currentLoc = locationManager?.location?.coordinate
        //uberClient.setButton((currentLoc?.latitude)!, pickupLong: (currentLoc?.longitude)!, dropoffLat: (currentlySelectedSubject?.location.latitude)!, dropoffLong: (currentlySelectedSubject?.location.longitude)!, viewContainer: uberButtonContainer)
        self.mapView.zoomToGeometry(point, withPadding: 100, animated: true)
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let cell: EventCell? = tableView.cellForRowAtIndexPath(indexPath) as? EventCell
        if (cell != nil) {
            cell!.descriptionLabel.textColor = UIColor(white: 0.70, alpha: 1.0)
        }
    }
    
    func callout(callout: AGSCallout!, willShowForFeature feature: AGSFeature!, layer: AGSLayer!, mapPoint: AGSPoint!) -> Bool {
        mapView.callout.title = feature.attributeAsStringForKey("title")
        mapView.callout.detail = feature.attributeAsStringForKey("description")
        var subjects: [MapEventSubjectModel]
        if (currentlySelectedSubject?.type == "Pharmacy") {
            subjects = pharmacies
        } else {
            subjects = doctors
        }
        var index = 0
        let expectedName = feature.attributeAsStringForKey("title")
        for (i, subject) in subjects.enumerate() {
            if (subject.name == expectedName) {
                index = i
                break
            }
        }
        let rowToSelect:NSIndexPath = NSIndexPath(forRow: index, inSection: 0)
        self.eventsTableView.selectRowAtIndexPath(rowToSelect, animated: true, scrollPosition: UITableViewScrollPosition.None)
        return true
    }
    
    func subjectSwitched(sender: DGRunkeeperSwitch) {
        switch sender.selectedIndex {
        case 0:
            mapEventControllerHelper!.populateMap(doctors)
            mapEventControllerHelper!.populateEvents(doctors)
        case 1:
            mapEventControllerHelper!.populateMap(pharmacies)
            mapEventControllerHelper!.populateEvents(pharmacies)
        default:
            break;
        }
    }
}
