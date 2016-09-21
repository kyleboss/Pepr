//
//  EventModel.swift
//  Pepr
//
//  Created by Kyle Boss on 9/4/16.
//  Copyright © 2016 Kyle Boss. All rights reserved.
//

import Foundation
import UIKit

class EventModel {
    
    var title : String
    var type : String
    var description : String?
    var subject: MapEventSubjectModel
    
    init(title: String, type: String, subject: MapEventSubjectModel){
        self.title = title
        self.type = type
        self.subject = subject
    }
}
