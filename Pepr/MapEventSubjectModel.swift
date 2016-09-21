//
//  MapEventSubjectModel.swift
//  Pepr
//
//  Created by Kyle Boss on 9/11/16.
//  Copyright © 2016 Kyle Boss. All rights reserved.
//

import Foundation

class MapEventSubjectModel: NSObject {
    var name: String
    var location: LocationModel
    var phone: PhoneModel
    var generalInfo: [String]
    var type: String
    
    init(name: String, location: LocationModel, phone: PhoneModel, generalInfo: [String], type: String) {
        self.name = name
        self.location = location
        self.phone = phone
        self.generalInfo = generalInfo
        self.type = type
    }
}
