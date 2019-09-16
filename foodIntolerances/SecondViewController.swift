//
//  SecondViewController.swift
//  foodIntolerances
//
//  Created by Zachary Yu on 25/7/2019.
//  Copyright © 2019 Zachary Yu. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var glutenButton: UIButton!
    @IBOutlet weak var vegetarianButton: UIButton!
    
    var searchQuery: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }
    

    /*
     MARK: - Navigation

     In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         Get the new view controller using segue.destination.
         Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func setGluten(_ sender: Any) {
        searchQuery = "gluten%20free%20restaurant"
        performSegue(withIdentifier: "resultSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "resultSegue"{
            if let nextViewController = segue.destination as? ResultViewController{
            nextViewController.searchQuery = searchQuery
            }
        }
    }

    @IBAction func setVeg(_ sender: Any) {
        searchQuery = "Vegetarian%20restaurant"
        performSegue(withIdentifier: "resultSegue", sender: self)
    }
    
    
    @IBAction func setVegan(_ sender: Any) {
        searchQuery = "vegan%20restaurant"
        performSegue(withIdentifier: "resultSegue", sender: self)
    }
    
}
