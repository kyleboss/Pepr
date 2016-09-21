//
//  Map.swift
//  Pepr
//
//  Created by Kyle Boss on 9/4/16.
//  Copyright © 2016 Kyle Boss. All rights reserved.
//

import Foundation
import ArcGIS

class MapModel: NSObject, AGSMapViewLayerDelegate, AGSLocatorDelegate, AGSFeatureLayerQueryDelegate {
    
    var mapView: AGSMapView!
    var graphicLayer: AGSGraphicsLayer!
    var locator: AGSLocator!
    var graphics = Array<AGSGraphic>()
    let pictureMarkerSymbol: AGSPictureMarkerSymbol = AGSPictureMarkerSymbol(image: UIImage(named: "map-annotation"))
    let tileUrl = NSURL(string: "http://services.arcgisonline.com/ArcGIS/rest/services/Canvas/World_Light_Gray_Base/MapServer")
    
    init(mapView: AGSMapView!) {
        self.mapView = mapView
    }
    
    func initMap()->Void {
        setMapBase()
        self.mapView.layerDelegate = self
        setLocator()
        setGraphicLayer()
    }
    
    func setMapBase()->Void {
        let tiledLayer = AGSTiledMapServiceLayer(URL: self.tileUrl as NSURL!)
        self.mapView.addMapLayer(tiledLayer, withName: "Basemap Tiled Layer")
    }
    
    func setLocator()->Void {
        self.locator = AGSLocator()
        self.locator.delegate = self
    }
    
    func setGraphicLayer()->Void {
        let symbol = placeIcon()
        self.graphicLayer = AGSGraphicsLayer()
        self.graphicLayer.renderer = AGSSimpleRenderer(symbol: symbol)
        self.mapView.addMapLayer(self.graphicLayer, withName:"Results")
    }
    
    func placeIcon()->AGSSimpleMarkerSymbol {
        let symbol = AGSSimpleMarkerSymbol(color: UIColor(red: 0, green: 0.46, blue: 0.68, alpha: 1))
        symbol?.size = CGSize(width: 7, height: 7)
        symbol?.style = .Circle
        symbol?.outline = nil
        return symbol!
    }
    
    func mapViewDidLoad(mapView: AGSMapView!) {
        mapView.locationDisplay.startDataSource()
    }
    
    func setClient() {
        do {
            let clientID = "2FNaC2g3BsxsX30b"
            try AGSRuntimeEnvironment.setClientID(clientID)
        } catch {
            print("There was an error in MapEventController.viewDidLoad setting the AGS Client ID")
        }
    }
    
    func locator(locator: AGSLocator!, operation op: NSOperation!, didFailLocationsForAddress error: NSError!) {
        print(error)
    }
}
