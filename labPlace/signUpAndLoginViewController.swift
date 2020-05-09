//
//  signUpAndLoginViewController.swift
//  labPlace
//
//  Created by Venkata harsha Balla on 5/9/20.
//  Copyright © 2020 BVH. All rights reserved.
//

import UIKit

class signUpAndLoginViewController: UIViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
//MARK: IBO ACTIONS
    
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        
        let navVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "goToLogIn")
               
               present(navVc, animated: true, completion: nil)
        
        
    }
    
    
    @IBAction func createAnAccountButtonPressed(_ sender: Any) {
        
        
        let navVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "goToCreateUser")
               
               present(navVc, animated: true, completion: nil)
        
        
    }
    
    
    
    @IBAction func TCPPressed(_ sender: Any) {
        
        let navVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "gotToTCP")
               
               present(navVc, animated: true, completion: nil)
        
        
    }
    
    
    
    
}
