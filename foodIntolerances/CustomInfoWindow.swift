//
//  CustomInfoWindow.swift
//  foodIntolerances
//
//  Created by Zachary Yu on 17/10/2019.
//  Copyright © 2019 Zachary Yu. All rights reserved.
//

import UIKit

class CustomInfoWindow: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadView() -> CustomInfoWindow{
        let customInfoWindow = Bundle.main.loadNibNamed("CustomInfoWindow", owner: self, options: nil)? [0] as! CustomInfoWindow
        return customInfoWindow
    }
}
