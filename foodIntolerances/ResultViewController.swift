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
    
    
    
    var cllocation = CLLocation()
    
    
    var restaurantArray: Array<Restaurant>!
    
    @IBOutlet weak var star: UIButton!
    
    @IBOutlet weak var placeTable: UITableView!
    
    @IBOutlet weak var labelText: UILabel!
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    @IBOutlet weak var favouriteButton: UIBarButtonItem!
    
    var resultsArray: [Dictionary<String,Any>] = []
//    var resultsArray: [CDYelpBusiness] = []
    
    let placeclient = GMSPlacesClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        placeTable.dataSource = self
        placeTable.delegate = self
        placeTable.estimatedRowHeight = 44.0
        
        restaurantArray = []
        

        
        
        getlocation()
        
        
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
        }
    }
    
    func searchRestaurants() {
        let apikey = "NpE-HLs5nHXft6q067v6wt1fOUUGkxfcwELz1yXVcwNuESEvANjrIrXdtCEQsSyl_B4xnKaBe6W21NkdRrd7xUkQU9EuK-aXSY6JWhs11cxOGPSS2ZOaHyHqex2EXXYx"
        let urL = URL(string: "https://api.yelp.com/v3/businesses/search?categories=restaurants%2Cbars%2Ccafes&latitude=\(cllocation.coordinate.latitude as! Double)&limit=20&longitude=\(cllocation.coordinate.longitude as! Double)&open_now=1&radius=5000&sort_by=best_match&term=\(searchQuery)")
        
        print("User lat == \(cllocation.coordinate.latitude)")
        print("user long == \(cllocation.coordinate.longitude)")
        var request = URLRequest(url: urL!)
        request.setValue("Bearer \(apikey)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            if error == nil{
                print("no error")
                let responseData = data
                if data != nil{
                    let jsonDict = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                    print(jsonDict)
                    
                    if let results = jsonDict as? [String: Any] {
                        print("json == \(results)")
                        
                        
                        let results2 = results["businesses"] as! Array<[String:AnyObject]>
                        print("results2 == \(results2)")
                        
                        
                        for dct in results2{
                            let location = dct["location"] as! [String:AnyObject]
                            let addressArray = location["display_address"] as! Array<String>
                            let address1 = addressArray[0]
                            let address2 = addressArray[1]
                            let address = address1 + ", " + address2
                            
                            let coordinates = dct["coordinates"] as! [String:Double]
                            let lat = coordinates["latitude"]
                            let lon = coordinates["longitude"]

                            
                            let tempRest = Restaurant(name: dct["name"] as! String, address: address, lat: lat!, lon: lon!, rating: dct["rating"] as! Double)
                            
                            self.restaurantArray.append(tempRest)
                        }
                        

                        
                        DispatchQueue.main.async {
                            self.placeTable.reloadData()
                        }
                    } else{
                        print("Translation failed")
                    }
                } else{
                    print("no data")
                }
            } else{
                print("error")
            }
//            print("This ran")
        }
        
        task.resume()
    }
    
    
    @IBAction func goBack(_ sender: Any) {
        performSegue(withIdentifier: "goBackSegue", sender: self)
    }
    
    
    
    @IBAction func goToFavourites(_ sender: Any) {
        performSegue(withIdentifier: "favouriteSegue", sender: self)
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
            cllocation = manager.location!
        }
        
        self.searchRestaurants()
    }
}

extension ResultViewController: UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurantArray.count
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "placeCell") as! customCell
        
        if let lblPlaceName = cell.contentView.viewWithTag(102) as? UILabel{
            let restaurant = restaurantArray[indexPath.row]
            
            cell.insertInfo(restaurant: restaurant)
            
            let name = restaurant.name
            
            let rating = restaurant.rating
            
//            self.locLat = lat
//            self.locLong = lon
//
//            self.addressFinal = address
//            self.nameFinal = name
            
            lblPlaceName.text = name + ". The rating is " + "\(rating)"
            
        }
        
        return cell
    }
    
    
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "mapSegue"{
//            if let destination = segue.destination as? MapViewController{
//                destination.address = Constants.addressFinal
//                destination.name = Constants.nameFinal
//                destination.lat = Constants.locLat
//                destination.lon = Constants.locLong
//            }
//        }
//    }
}

extension ResultViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let restaurant = restaurantArray[indexPath.row]
        
        let address = restaurant.address
        let name = restaurant.name
        let lat = restaurant.lat
        let lon = restaurant.lon
        
        Constants.addressFinal = address
        Constants.nameFinal = name
        Constants.locLong = lon
        Constants.locLat = lat
        
        print("Constant lat == \(lat)")
        print("Constant lon == \(lon)")
    }
}

