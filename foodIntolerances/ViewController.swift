//
//  ViewController.swift
//  foodIntolerances
//
//  Created by Zachary Yu on 23/7/2019.
//  Copyright © 2019 Zachary Yu. All rights reserved.
//

import UIKit
import FirebaseUI


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func signUpButton(_ sender: Any) {
        //retrieve default auth UI
        if let authUI = FUIAuth.defaultAuthUI(){
            authUI.delegate = self
            
            let providers = [FUIEmailAuth()]
            authUI.providers = providers
            
            let authViewController = authUI.authViewController()
            present(authViewController, animated: true, completion: nil)
            
            performSegue(withIdentifier: "signUpSegue", sender: self)
        }
    }
    
    
    @IBAction func skipButton(_ sender: Any) {
        performSegue(withIdentifier: "signUpSegue", sender: self)
    }
}
extension ViewController: FUIAuthDelegate{
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        if error != nil{
            print("no error")
            performSegue(withIdentifier: "signUpSegue", sender: self)
        } else{
            print("Error")
            return
        }
    }
}
