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

    
    
    
    var mapView = GMSMapView()
    
    
    var coordinates:CLLocationCoordinate2D!
    
    let geocoder =  CLGeocoder()
    let zoomLevel:Float = 6.0
    

    


    override func loadView() {
        let camera = GMSCameraPosition.camera(withLatitude: Constants.locLat, longitude: Constants.locLong, zoom: zoomLevel)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        self.view = mapView

        addMarker()
        
//        print("map lat == \(Constants.locLat)")
//        print("map lon == \(Constants.locLong)")

    }
    
    

    
    func addMarker(){
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: Constants.locLat, longitude: Constants.locLong)
        marker.title = Constants.nameFinal
        marker.snippet = Constants.addressFinal
        marker.map = mapView
    }
    
    @IBAction func onClick(_ sender: Any) {
        performSegue(withIdentifier: "favourite2Segue", sender: self)
    }
    
}
