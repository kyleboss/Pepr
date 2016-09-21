//
//  PharmacyModel.swift
//  Pepr
//
//  Created by Kyle Boss on 9/10/16.
//  Copyright © 2016 Kyle Boss. All rights reserved.
//

import Foundation
import YelpAPI

class PharmacyModel: MapEventSubjectModel {
    
    init(name: String, location: LocationModel, phone: PhoneModel, generalInfo: [String]) {
        super.init(name: name, location: location, phone: phone, generalInfo: generalInfo, type: "Pharmacy")
    }
    
    class func addPharmacies(pharmacyDics: [NSDictionary], map: MapModel, mapEventController: MapEventController) {
        var pharmacies: [PharmacyModel] = []
        for pharmacy in pharmacyDics {
            if (pharmacy.objectForKey("phone") == nil) { continue }
            let pharmaCity = (pharmacy.objectForKey("location"))!.objectForKey("city") as! String
            let pharmaAddress = ((pharmacy.objectForKey("location"))!.objectForKey("address") as! NSArray)[0] as! String
            let pharmaState = (pharmacy.objectForKey("location"))!.objectForKey("state_code") as! String
            let pharmaZip = (pharmacy.objectForKey("location"))!.objectForKey("postal_code") as! String
            let pharmaLat = ((pharmacy.objectForKey("location"))!.objectForKey("coordinate"))!.objectForKey("latitude") as! Double
            let pharmaLong = ((pharmacy.objectForKey("location"))!.objectForKey("coordinate"))!.objectForKey("longitude") as! Double
            let pharmaLoc = LocationModel(city: pharmaCity, state: pharmaState, streetAddress: pharmaAddress, zip: pharmaZip, latitude: pharmaLat, longitude: pharmaLong)
            let pharmaName = pharmacy.objectForKey("name") as! String
            let pharmaPhone = PhoneModel(number: pharmacy.objectForKey("phone") as! String)
            let pharmaInfo = [(((pharmacy.objectForKey("location"))!.objectForKey("display_address") as! NSArray)[0] as! String), (pharmacy.objectForKey("display_phone") as! String)]
            pharmacies.append(PharmacyModel(name: pharmaName, location: pharmaLoc, phone: pharmaPhone, generalInfo: pharmaInfo))
            mapEventController.pharmacies = pharmacies
        }
    }
    
    class func searchWithTerm(latitude: Double, longitude: Double, map: MapModel, mapEventController: MapEventController, completion: ([PharmacyModel]!, NSError!) -> Void) -> Void {
        YelpClient.sharedInstance.searchWithTerm(latitude, longitude: longitude, map: map, mapEventController: mapEventController, completion: completion)
    }
}
