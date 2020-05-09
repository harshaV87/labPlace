//
//  logInViewController.swift
//  labPlace
//
//  Created by Venkata harsha Balla on 5/9/20.
//  Copyright © 2020 BVH. All rights reserved.
//

import UIKit
import FirebaseAuth


class logInViewController: UIViewController {
    
    
    
    //MARK: IBO outlets
    
    
    @IBOutlet weak var emailTextField: UITextField!
    
    
    @IBOutlet weak var passwordTextField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        
        
    }
    
//MARK: IBO buttons
    
    
    @IBAction func loginButtonPressed(_ sender: Any) {
//
        //making sure that the textfield and password field are not empty and navigating to the proper view controller

        if !emailTextField.text!.isEmpty && !passwordTextField.text!.isEmpty {

            //Signing up and navigation to tab bar.

            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (result, error) in

                if error == nil {

                    //Navigation to the tab controller

            //Navigationcode to a different view controller is not needed because we have been listening to the auth change states in the scenedelegate in the function scene. So logout button doesnt need the navigation or dismiss as we are listening to the auth state anyway

                    //The autologin is working as we have implemented the code in the scene delegate so that the user does not have to login constantly.
//
//
//
                } else {

                    //Showing alert if there is a problem with the login

                    let alertController = UIAlertController(title: "All fields are mandatory", message: "\(error?.localizedDescription ?? "something went wrong, please try again")", preferredStyle: .alert)

                            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))


                    self.present(alertController, animated: true, completion: nil)

                }

            }


        } else {

    let alertController = UIAlertController(title: "All fields are mandatory", message: "Please make sure you have entered all the fields", preferredStyle: .alert)

            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))


    present(alertController, animated: true, completion: nil)

        }

//
    }
    
    
    @IBAction func forgotPasswordPressed(_ sender: Any) {
        
        
        let navVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "gotToReset")
               
               present(navVc, animated: true, completion: nil)
        
        
    }
    
    
    
    
    @IBAction func cancelBarButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
}
