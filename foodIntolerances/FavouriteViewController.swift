//
//  FavouriteViewController.swift
//  foodIntolerances
//
//  Created by Zachary Yu on 18/10/2019.
//  Copyright © 2019 Zachary Yu. All rights reserved.
//

import UIKit

class FavouriteViewController: UIViewController {

    
    @IBOutlet weak var myTable: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTable.dataSource = self
        myTable.delegate = self
        myTable.estimatedRowHeight = 44.0
        
        print("favelist == \(Constants.favRests)")
        
        DispatchQueue.main.async {
            self.myTable.reloadData()
        }
    }

}
extension FavouriteViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.favRests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell")
        print("favRests == \(Constants.favRests)")
        if let lbl = cell?.contentView.viewWithTag(110) as? UILabel{
            let restaurant = Constants.favRests[indexPath.row]
            
            let rating = restaurant.rating
            let name = restaurant.name
            lbl.text = name + ". Rating: " + "\(rating)"
            
            print("Table Ran")
            
            
        }
        
        return cell!
    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if(segue.identifier == "goToMap2"){
//            if let destination = segue.destination as? MapViewController{
//
//            }
//        }
//    }
    
}
extension FavouriteViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let restaurant = Constants.favRests[indexPath.row]
    
        let name = restaurant.name
        

        Constants.locLat = restaurant.lat
        Constants.locLong = restaurant.lon
        Constants.addressFinal = restaurant.address
        Constants.nameFinal = name
        
    }
}
