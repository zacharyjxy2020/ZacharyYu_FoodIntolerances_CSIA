//
//  ResultViewController.swift
//  foodIntolerances
//
//  Created by Zachary Yu on 28/7/2019.
//  Copyright © 2019 Zachary Yu. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CDYelpFusionKit
import AlamofireObjectMapper


class ResultViewController: UIViewController{
    
    var searchQuery: String = ""
    var locationManager = CLLocationManager()
    
    
    var addressFinal:String = ""
    var nameFinal:String = ""
    
    var locLat:Double = 0.0
    var locLong:Double = 0.0
    
    
    var userLat: Double = 0.0
    var userLong: Double = 0.0
    
    
    @IBOutlet weak var placeTable: UITableView!
    
    @IBOutlet weak var labelText: UILabel!
    
    var resultsArray: [Dictionary<String,Any>] = []
//    var resultsArray: [CDYelpBusiness] = []
    
    let placeclient = GMSPlacesClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        placeTable.dataSource = self
        placeTable.delegate = self
        placeTable.estimatedRowHeight = 44.0
        
        
        
        
        getlocation()
        searchRestaurants()
//          findYelpLocations()
//        searchLocation()
    }
    
    func getlocation(){
        
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
            locationManager.startUpdatingLocation()
        } else{
            locationManager.requestAlwaysAuthorization()
            userLat = 0
            userLong = 0
        }
    }
    
    func searchRestaurants() {
        let apikey = "NpE-HLs5nHXft6q067v6wt1fOUUGkxfcwELz1yXVcwNuESEvANjrIrXdtCEQsSyl_B4xnKaBe6W21NkdRrd7xUkQU9EuK-aXSY6JWhs11cxOGPSS2ZOaHyHqex2EXXYx"
        let urL = URL(string: "https://api.yelp.com/v3/businesses/search?categories=restaurants%2Cbars%2Ccafes&latitude=\(userLat)&limit=20&longitude=\(userLong)&open_now=1&radius=5000&sort_by=best_match&term=\(searchQuery)")
        var request = URLRequest(url: urL!)
        request.setValue("Bearer \(apikey)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            if error == nil{
//                print("no error")
                let responseData = data
                if data != nil{
                    let jsonDict = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
//                    print(jsonDict)
                    
                    if let results = jsonDict as? [String: Any] {
//                        print("json == \(results)")
                        self.resultsArray.removeAll()
                        
                        self.resultsArray.append(results)
//                        print("resultsarray == \(self.resultsArray)")
                        
                        DispatchQueue.main.async {
                            self.placeTable.reloadData()
                        }
                    } else{
//                        print("Translation failed")
                    }
                } else{
//                    print("no data")
                }
            } else{
//                print("error")
            }
//            print("This ran")
        }
        
        task.resume()
    }
}
extension ResultViewController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last
        {
            if((location.horizontalAccuracy) < CLLocationAccuracy(0)){
                return
            }
            let locValue:CLLocationCoordinate2D = manager.location!.coordinate
            userLat = locValue.latitude
            userLong = locValue.longitude
        }
        
        self.getlocation()
    }
}

extension ResultViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "placeCell")
        if let lblPlaceName = cell?.contentView.viewWithTag(102) as? UILabel{
            let place = self.resultsArray[indexPath.row]
            let business = place["businesses"]
            let businesses = business as! Array<[String:AnyObject]>
            let businessFinal = businesses[indexPath.row]
            
            
            let name:String = businessFinal["name"] as! String
            print("name == \(name)")
            let location = businessFinal["location"] as! Dictionary<String,AnyObject>
            let addressTemp = location["display_address"] as! Array<String>
            let address1 = addressTemp[0]
            let address2 = addressTemp[1]
            let address = address1 + " " + address2
            addressFinal = address
            nameFinal = name
            let rating = businessFinal["rating"] as! Double
            
            let coordinates = businessFinal["coordinates"] as! Dictionary<String, Double>
            locLat = coordinates["latitude"]!
            locLong = coordinates["longitude"]!
            
            
            lblPlaceName.text = name + ". The rating is " + "\(rating)"
            
        }
        
        return cell!
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mapSegue"{
            if let destination = segue.destination as? MapViewController{
                destination.address = addressFinal
                destination.name = nameFinal
                destination.lat = locLat
                destination.lon = locLong
            }
        }
    }
}

extension ResultViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

