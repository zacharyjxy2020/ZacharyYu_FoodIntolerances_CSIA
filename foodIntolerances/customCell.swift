//
//  customCell.swift
//  foodIntolerances
//
//  Created by Zachary Yu on 18/10/2019.
//  Copyright © 2019 Zachary Yu. All rights reserved.
//

import UIKit

class customCell: UITableViewCell {

    var favRest:Restaurant = Restaurant(name: "", address: "", lat: 0, lon: 0, rating: 0)
    var currRest:Restaurant = Restaurant(name: "", address: "", lat: 0, lon: 0, rating: 0)
    
    @IBOutlet weak var star: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func insertInfo(restaurant:Restaurant) {
        self.currRest = restaurant
    }

    @IBAction func onClick(_ sender: Any) {
        let goldStar:UIImage = UIImage(named: "goldStar.png")!
        let whiteStar:UIImage = UIImage(named: "whiteStar.png")!
        if(star.image(for: .normal) == goldStar){
            star.setImage(whiteStar, for: .normal)
            Constants.favRests.remove(at: Constants.favRests.firstIndex(of: currRest)!)
            
        } else{
            star.setImage(goldStar, for: .normal)
            Constants.favRests.append(currRest)
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
