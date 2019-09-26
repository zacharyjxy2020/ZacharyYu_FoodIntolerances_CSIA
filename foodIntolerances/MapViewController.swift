//
//  MapViewController.swift
//  foodIntolerances
//
//  Created by Zachary Yu on 2/9/2019.
//  Copyright © 2019 Zachary Yu. All rights reserved.
//

import UIKit
import GoogleMaps


class MapViewController: UIViewController {

    var address:String = ""
    var name: String = ""
    
    var mapView = GMSMapView()
    
    
    var coordinates:CLLocationCoordinate2D!
    
    let geocoder =  CLGeocoder()
    var lat: Double = 0.0
    var lon: Double = 0.0
    let zoomLevel:Float = 6.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    


    override func loadView() {
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lon, zoom: zoomLevel)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        self.view = mapView
        
        addMarker()
    }
    
    func addMarker(){
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        marker.title = name
        marker.snippet = address
        marker.map = mapView
    }
    
}
