//
//  WebScraper.swift
//  Pepr
//
//  Created by Kyle Boss on 9/4/16.
//  Copyright © 2016 Kyle Boss. All rights reserved.
//

import Foundation
import UIKit
import WebKit
import Kanna

class WebScraper : NSObject {
    
    private var webView = WKWebView()
    private var myURLString: String
    private var baseURL = "https://glmaimpak.networkats.com/members_online_new/members/"
    private var doctorXPath = "//tr[@valign='top']/td/table[2]/tr/td/table[@width='100%']/tr[./td[./b or ./img]]"
    
    init(zipCode: String) {
        let gender = ""
        let zipCode = zipCode
        let refcarriPriv = ""
        let refcarriPub = ""
        let refiplanPriv = ""
        let refiplanPub = ""
        self.myURLString = baseURL + "dir_provider.asp?action=search&affiliate=&location_type=Z" +
            "&address_zip=\(zipCode)&address_zip_radius=25&address_state_code=&address_city=&country_name=" +
            "&community_partner=&advanced_search=&ind_last_name=&ref_specialtytypes=&specialt_MEDICAL=" +
            "&specialt_BEHAVE=&specialt_DENTIST=&specialt_COMPLALT=&gender=\(gender)&clfc=&TG=&lang=&refcarri=" +
            "&refiplan_PRIV=\(refiplanPriv)&refiplan_PUB=\(refiplanPub)&refcarri_PRIV=\(refcarriPriv)" +
            "&refcarri_PUB=\(refcarriPub)"
    }
    
    func startScrape(map: MapModel, mapEventController: MapEventController) {
        WebScraper.getDataFromUrl(myURLString) { data in
            dispatch_async(dispatch_get_main_queue()) {
                if let doc = Kanna.HTML(html: data!, encoding: NSMacOSRomanStringEncoding) {
                    // Search for nodes by CSS
                    var doctors: [DoctorModel] = []
                    var locations: [LocationModel] = []
                    for doctorHTML in doc.xpath(self.doctorXPath) {
                        let newDoctor = DoctorModel.createFromHTML(doctorHTML)
                        if (newDoctor != nil) {
                            doctors.append(newDoctor!)
                            locations.append(newDoctor!.location)
                        }
                    }
                    mapEventController.doctors = doctors
                    DoctorModel.lookupLocations(locations, mapEventController: mapEventController)
                }
            }
        }
    }
    
    class func getDataFromUrl(url: String, completion: ((data: NSData?) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: url)!) { (data, response, error) in
            completion(data: NSData(data: data!))
            }.resume()
    }
}
