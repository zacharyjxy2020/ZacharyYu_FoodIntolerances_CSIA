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


class ResultViewController: UIViewController{
    
    var searchQuery: String = ""
    var locationManager = CLLocationManager()
    
    var addressFinal:String = ""
    var nameFinal:String = ""
    
    var userLat: Double = 0.0
    var userLong: Double = 0.0
    
    
    @IBOutlet weak var placeTable: UITableView!
    
    @IBOutlet weak var labelText: UILabel!
    
    var resultsArray: [Dictionary<String, AnyObject>] = Array()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        placeTable.dataSource = self
        placeTable.delegate = self
        placeTable.estimatedRowHeight = 44.0
        
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
            locationManager.startUpdatingLocation()
            let coordinates = locationManager.location?.coordinate
            userLat = coordinates!.latitude
            userLong = coordinates!.longitude
        } else{
            locationManager.requestAlwaysAuthorization()
            userLat = 0
            userLong = 0
        }
        
        
        
        
        
        searchLocation()
    }
    
    func setupPermissions() {
        
    }
    
    func searchLocation(){
        
        var searchString = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=\(searchQuery)&inputtype=textquery&fields=formatted_address,name,opening_hours,rating&locationbias=circle:10000@\(userLat),\(userLong)&key=AIzaSyBnwkbhnLSt-IakK2mEyMA5lJnbsIBscGM"
        
        searchString = searchString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        var urlRequest = URLRequest(url: URL(string: searchString)!)
        
        urlRequest.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if error == nil{
                let responseData = data
                if data != nil{
                    let jsonDict = try? JSONSerialization.jsonObject(with: responseData!, options: .mutableContainers)
                    
                    if let dict = jsonDict as? Dictionary<String, AnyObject>{
                        if let results = dict["candidates"] as? [Dictionary<String, AnyObject>]{
                            print("json == \(results)")
                            self.resultsArray.removeAll()
                            for dct in results{
                                self.resultsArray.append(dct)
                            }
                            DispatchQueue.main.async {
                                self.placeTable.reloadData()
                            }
                            
                        }
                    }
                }else{
                    print("error")
                }
                
            }else{
                print("error is: " + error.debugDescription)
            }
        }
        task.resume()
    }
}

extension ResultViewController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        userLat = locValue.latitude
        userLong = locValue.longitude
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
            let name:String = place["name"] as! String
            let address:String = place["formatted_address"] as! String
            addressFinal = address
            nameFinal = name
            let rating:Double = place["rating"] as! Double
            
            lblPlaceName.text = name + ". " + address + ". " + ". The rating is " + "\(rating)"
            
        }
        
        return cell!
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mapSegue"{
            if let destination = segue.destination as? MapViewController{
                destination.address = addressFinal
                destination.name = nameFinal  
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
