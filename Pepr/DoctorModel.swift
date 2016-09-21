//
//  DoctorModel.swift
//  Pepr
//
//  Created by Kyle Boss on 9/4/16.
//  Copyright © 2016 Kyle Boss. All rights reserved.
//

import Foundation
import UIKit
import Kanna

class DoctorModel: MapEventSubjectModel {
    
    init(name: String, location: LocationModel, phone: PhoneModel, generalInfo: [String]) {
        super.init(name: name, location: location, phone: phone, generalInfo: generalInfo, type: "Doctor")
    }
    
    class func createFromHTML(doctorHTML: XMLElement) -> DoctorModel? {
        let doctorName = doctorHTML.at_xpath("./td/b")
        if (doctorName == nil) { return nil }
        let name: String? = doctorName!.text!
        if (name == nil) { return nil }
        var location: LocationModel = LocationModel(city: "", state: "", streetAddress: "", zip: "", latitude: nil, longitude: nil)
        var phone: PhoneModel?
        var startedAddress = false
        var finishedAddress = false
        let doctorInfo = doctorHTML.at_xpath("./td[./b]")?.innerHTML!
        let doctorComponents = (doctorInfo!.componentsSeparatedByString("<br>"))
        for doctorComponent in doctorComponents {
            if (LocationModel.isStreetAddress(doctorComponent, startedAddress: startedAddress)) {
                location.streetAddress = doctorComponent
                startedAddress = true
            } else if (LocationModel.isLocation(doctorComponent, startedAddress: startedAddress,
                finishedAddress: finishedAddress)) {
                location = getCityStateZipFromDocFragment(doctorComponent, location: location)
                finishedAddress = true
            } else if (PhoneModel.isValid(doctorComponent) && finishedAddress) {
                phone = PhoneModel(number: doctorComponent)
                break
            }
        }
        if (!finishedAddress) { return nil }
        var generalInfo = doctorComponents
        generalInfo.removeFirst()
        generalInfo.removeLast()
        return DoctorModel(name: name!, location: location, phone: phone!, generalInfo: generalInfo)
    }
    
    class func getCityStateZipFromDocFragment(doctorComponent: String, location: LocationModel) -> LocationModel {
        location.zip = doctorComponent.substringFromIndex(doctorComponent.endIndex.advancedBy(-5))
        var locationComponents = doctorComponent.componentsSeparatedByString(", ")
        location.city = locationComponents.first!
        let stateSection = locationComponents[1]
        location.state = stateSection.substringToIndex(stateSection.startIndex.advancedBy(2))
        return location
    }
    
    class func lookupLocations(locations: [LocationModel], mapEventController: MapEventController) {
        var records = "{\"records\":["
        for (i, location) in locations[0...14].enumerate() {
            let address = removeSpecialCharsFromString(location.streetAddress)
            records = "\(records){\"attributes\":{\"OBJECTID\":\(i),\"Address\":\(address),\"City\":\(location.city),\"Region\":\(location.state),\"Postal\":\(location.zip)}},"
            if i == locations.count-1 {
                records = records.substringToIndex(records.endIndex.predecessor())
            }
        }
        records = "\(records)]}"
        let token = "AajDof5hArh8cDHmDWa7mMEOTxSi2L2fL7J8hMgNMjebdtwNqWZLLKSkwVLETC5gpkjWzJa0hmI17aV5PfeJ8X28YLXR9UY4LbmtmaoJVs6novSmQzWS1l9vPBCB3a1WLy1R1Hp5onF_tj2bRw7hCA.."
        let url : NSString = "http://geocode.arcgis.com/arcgis/rest/services/World/GeocodeServer/geocodeAddresses?addresses=\(records)&sourceCountry=USA&token=\(token)&f=pjson"
        let urlStr : NSString = url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        let searchURL : NSURL = NSURL(string: urlStr as String)!
        DoctorModel.updateLocations(searchURL, mapEventController: mapEventController)
    }
    
    class func updateLocations(searchURL: NSURL, mapEventController: MapEventController) {
        let task = NSURLSession.sharedSession().dataTaskWithURL(searchURL) {(data, response, error) in
            do {
                let locationData = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
                for (i, location) in (locationData.objectForKey("locations") as! [NSDictionary]).enumerate() {
                    let x = (location.objectForKey("location"))!.objectForKey("x") as! Double
                    let y = (location.objectForKey("location"))!.objectForKey("y") as! Double
                    mapEventController.doctors[i].location.longitude = x
                    mapEventController.doctors[i].location.latitude = y
                }
            } catch {
                print("SOMETHING WENT WRONG IN MapModel.addPlacesToMap")
            }
            dispatch_async(dispatch_get_main_queue(), {
                mapEventController.mapEventControllerHelper!.populateMap(mapEventController.doctors)
                mapEventController.mapEventControllerHelper!.populateEvents(mapEventController.doctors)
            })
        }
        
        task.resume()
    }
    
    class func removeSpecialCharsFromString(text: String) -> String {
        let okayChars : Set<Character> =
            Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890".characters)
        return String(text.characters.filter {okayChars.contains($0) })
    }
}
