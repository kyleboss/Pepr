//
//  LocationModel.swift
//  Pepr
//
//  Created by Kyle Boss on 9/5/16.
//  Copyright © 2016 Kyle Boss. All rights reserved.
//

import Foundation

class LocationModel: NSObject {
    var city: String
    var state: String
    var streetAddress: String
    var zip: String
    var latitude: Double?
    var longitude: Double?
    
    init(city: String, state: String, streetAddress: String, zip: String, latitude: Double?, longitude: Double?) {
        self.city = city
        self.state = state
        self.streetAddress = streetAddress
        self.zip = zip
        self.latitude = latitude
        self.longitude = longitude
    }
    
    class func isLocation(doctorComponent: String, startedAddress: Bool, finishedAddress: Bool) -> Bool {
        if doctorComponent.characters.count <= 4 { return false }
        let lastFiveChars = doctorComponent.substringFromIndex(doctorComponent.endIndex.advancedBy(-5))
        let hasZipCode = self.stringIsNumeric(lastFiveChars)
        return startedAddress && !finishedAddress && hasZipCode
    }
    
    class func isStreetAddress(doctorComponent: String, startedAddress: Bool) -> Bool {
        let firstCharIsDigit = doctorComponent.characters.first >= "0" && doctorComponent.characters.first <= "9"
        return !startedAddress && firstCharIsDigit
    }
    
    class func stringIsNumeric(string: String) -> Bool
    {
        let badCharacters = NSCharacterSet.decimalDigitCharacterSet().invertedSet
        return string.rangeOfCharacterFromSet(badCharacters) == nil
    }
}
