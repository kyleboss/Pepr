//
//  PhoneModel.swift
//  Pepr
//
//  Created by Kyle Boss on 9/10/16.
//  Copyright © 2016 Kyle Boss. All rights reserved.
//

import Foundation

class PhoneModel: NSObject {
    var number: String
    
    init(number: String) {
        self.number = PhoneModel.unformatPhoneNumber(number)
    }
    
    class func unformatPhoneNumber(formattedPhoneNumber: String) -> String {
        let options = NSStringCompareOptions.RegularExpressionSearch
        return formattedPhoneNumber.stringByReplacingOccurrencesOfString("[^0-9]", withString: "", options: options, range: nil)
    }
    
    class func isValid(stringFragment: String) -> Bool {
        let numericFragment = self.unformatPhoneNumber(stringFragment)
        let hasTenDigits = numericFragment.characters.count == 10
        return hasTenDigits
    }
}
