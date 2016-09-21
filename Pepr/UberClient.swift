//
//  UberClient.swift
//  Pepr
//
//  Created by Kyle Boss on 9/11/16.
//  Copyright © 2016 Kyle Boss. All rights reserved.
//

import Foundation
import UberRides
import CoreLocation

class UberClient: NSObject {
    let ridesClient = RidesClient()
    let button = RideRequestButton()
    
    func setButton(pickupLat: Double, pickupLong: Double, dropoffLat: Double, dropoffLong: Double, viewContainer: UIView) {
        viewContainer.subviews.forEach { $0.removeFromSuperview() }
        viewContainer.clipsToBounds = true
        button.frame = viewContainer.bounds
        let pickupLocation = CLLocation(latitude: pickupLat, longitude: pickupLong)
        let dropoffLocation = CLLocation(latitude: dropoffLat, longitude: dropoffLong)
        var builder = RideParametersBuilder().setPickupLocation(pickupLocation).setDropoffLocation(dropoffLocation)
        ridesClient.fetchCheapestProduct(pickupLocation: pickupLocation, completion: {
            product, response in
            if let productID = product?.productID {
                builder = builder.setProductID(productID)
                self.button.rideParameters = builder.build()
                self.button.loadRideInformation()
            }
        })
        
        viewContainer.addSubview(button)
    }
}
