//
//  MapEventControllerHelper.swift
//  Pepr
//
//  Created by Kyle Boss on 9/11/16.
//  Copyright © 2016 Kyle Boss. All rights reserved.
//

import Foundation
import UIKit
import ArcGIS
import SwiftSpinner

class MapEventControllerHelper: NSObject {
    var mapEventController: MapEventController
    
    init(mapEventController: MapEventController) {
        self.mapEventController = mapEventController
    }
    
    func setupUIElements() {
        self.mapEventController.eventsTableView.dataSource = self.mapEventController
        self.mapEventController.eventsTableView.delegate = self.mapEventController
        self.mapEventController.eventsTableView.estimatedRowHeight = 100.0;
        self.mapEventController.eventsTableView.rowHeight = UITableViewAutomaticDimension;
        self.mapEventController.eventsTableView.separatorStyle = UITableViewCellSeparatorStyle.None
    }
    
    func populateMap(subjects: [MapEventSubjectModel]) {
        self.mapEventController.map.graphicLayer.removeAllGraphics()
        self.mapEventController.mapView.callout.hidden = true
        let spatialReference = AGSSpatialReference(WKID: 4326)
        var graphics = [AnyObject]()
        for subject in subjects {
            let location = subject.location
            if (location.longitude == nil || location.latitude == nil) { continue }
            let locationPoint = AGSPoint(x: location.longitude!, y: location.latitude!, spatialReference: spatialReference)
            let graphic = AGSGraphic(geometry: AGSGeometryGeographicToWebMercator(locationPoint), symbol: AGSPictureMarkerSymbol(image: UIImage(named: "map-annotation")), attributes: ["title": subject.name, "description": subject.location.streetAddress])
            graphics.append(graphic!)
        }
        self.mapEventController.map.graphicLayer.addGraphics(graphics as [AnyObject])
        self.mapEventController.mapView.zoomToGeometry(self.mapEventController.map.graphicLayer.fullEnvelope, withPadding: 100, animated: true)
        let rowToSelect:NSIndexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.mapEventController.eventsTableView.selectRowAtIndexPath(rowToSelect, animated: true, scrollPosition: UITableViewScrollPosition.None)
        
    }
    
    func populateEvents(subjects: [MapEventSubjectModel]) {
        self.mapEventController.events = []
        for subject in subjects {
            let location = subject.location
            if (location.longitude == nil || location.latitude == nil) { continue }
            let subjectListing = EventModel(title: subject.name, type: subject.type, subject: subject)
            subjectListing.description = subject.generalInfo.joinWithSeparator("\r\n")
            self.mapEventController.events.append(subjectListing)
        }
        self.mapEventController.eventsTableView.reloadData()
        let rowToSelect:NSIndexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.mapEventController.eventsTableView.selectRowAtIndexPath(rowToSelect, animated: true, scrollPosition: UITableViewScrollPosition.None)
        self.mapEventController.loadingView?.removeFromSuperview()
        SwiftSpinner.hide()
    }
}
