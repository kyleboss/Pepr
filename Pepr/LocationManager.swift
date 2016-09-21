//
//  LocationManager.swift
//  Pepr
//
//  Created by Kyle Boss on 9/11/16.
//  Copyright © 2016 Kyle Boss. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager: CLLocationManager, CLLocationManagerDelegate {
    var mapEventController: MapEventController
    
    init(mapEventController: MapEventController) {
        self.mapEventController = mapEventController
    }
    
    func setupLocationTracking() {
        self.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            self.delegate = self
            self.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.startUpdatingLocation()
            
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if mapEventController.hasPharmacies { return }
        mapEventController.hasPharmacies = true
        
        CLGeocoder().reverseGeocodeLocation(location!, completionHandler: {(placemarks, error) -> Void in
            
            if error != nil {
                print("Reverse geocoder failed with error" + error!.localizedDescription)
                return
            }
            
            if placemarks!.count > 0 {
                let pm = placemarks![0]
                
                print(pm.postalCode!) //prints zip code
                let webScraper = WebScraper(zipCode: pm.postalCode!)
                webScraper.startScrape(self.mapEventController.map, mapEventController: self.mapEventController)
            }
            else {
                print("Problem with the data received from geocoder")
            }
        })
        
        PharmacyModel.searchWithTerm(self.location!.coordinate.latitude, longitude: self.location!.coordinate.longitude, map: mapEventController.map, mapEventController: mapEventController) {_,_ in
            return true
        }
        mapEventController.hasPharmacies = true
        self.stopUpdatingLocation()
    }
}
