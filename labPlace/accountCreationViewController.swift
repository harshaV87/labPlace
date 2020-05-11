//
//  accountCreationViewController.swift
//  labPlace
//
//  Created by Venkata harsha Balla on 5/9/20.
//  Copyright © 2020 BVH. All rights reserved.
//

import UIKit
import Firebase

class accountCreationViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    //MARK: Varibales and constants
    
     var imageToBeUploadedOnFirebase: UIImage? = nil
    
    var userImageStorage: StorageReference!
    
    var databaseRef: DatabaseReference!
 
    
    
    //MARK: IBO outlets
    
    
    @IBOutlet weak var profileImage: UIImageView!
    
    
    @IBOutlet weak var fullNameTextField: UITextField!
    
    
    @IBOutlet weak var userNameTextField: UITextField!
    
    
    @IBOutlet weak var emailTextField: UITextField!
    

    @IBOutlet weak var passwordTextField: UITextField!
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //ImagePicker Function
        addingGestureOnImage()
        
        
        let storage = Storage.storage().reference(forURL: "gs://labplace-10a7a.appspot.com")
        
        userImageStorage = storage.child("users")
        
        
        databaseRef = Database.database().reference()
        
        
       
    }
    
    //MARK: IBO Actions
    
    
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
        
    }
    

    @IBAction func createButtonPressed(_ sender: Any) {
        
        
        //MARK: MAKING SURE THAT NONE OF THE FIELDS ARE EMPTY
        
        guard let imageSelected = self.imageToBeUploadedOnFirebase else {
                   
                   let alertController = UIAlertController(title: "All fields are mandatory", message: "Please tap on the image to add a profile picture", preferredStyle: .alert)

                           alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                           
                          
                   present(alertController, animated: true, completion: nil)
                   
                   return
                   
               }
        
        
        
        
        if fullNameTextField.text != "", userNameTextField.text != "", emailTextField.text != "", passwordTextField.text != "" {
            
            //Signing up
            
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (result, error) in
                

                
                
                if error != nil {

                    let alertController = UIAlertController(title: "Something went wrong", message: "\(error?.localizedDescription ?? "Please try again")", preferredStyle: .alert)

                            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))


                    self.present(alertController, animated: true, completion: nil)

                } else {

                    
                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                    
                    changeRequest?.displayName = self.userNameTextField.text
                    
                    changeRequest?.commitChanges(completion: nil)
                        
                    let imageRef = self.userImageStorage.child("\(result?.user.uid ?? "default").jpg")
                        
                    let data = imageSelected.jpegData(compressionQuality: 0.6)

                    _ = imageRef.putData(data!, metadata: nil) { (metadata, err) in
                        
                        
                        if err != nil {
                            
                            let alertController = UIAlertController(title: "Something went wrong", message: "\(err?.localizedDescription ?? "Error")", preferredStyle: .alert)

                                    alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))


                            self.present(alertController, animated: true, completion: nil)
                        
                            
                        } else {
                            
                            imageRef.downloadURL { (url, er) in
                                
                                if er != nil {
                                    
                                    
                                    let alertController = UIAlertController(title: "Something went wrong", message: "\(er?.localizedDescription ?? "Error")", preferredStyle: .alert)

                                                                     alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))


                                                             self.present(alertController, animated: true, completion: nil)
                                    
                                    
                                    
                                } else {
                                    
                                    
                                    if let url = url {
                                        
                                        //MARK: DICTIONARY CREATION TO UPLOAD THE USER DETAILS
                                        
                                        
                    let userInfo: [String : Any] = ["uid" : result?.user.uid as Any,
                                            "FullName" : self.fullNameTextField.text as Any,
                                            "userName" : self.userNameTextField.text as Any,
                                            "profileImageURL" : url.absoluteString as Any]
                                        
                                       //Writing to the database
                                        self.databaseRef.child("users").child((result?.user.uid)!).setValue(userInfo)
                                        
                                        
                                    
//Navigationcode to a different view controller is not needed because we have been listening to the auth change states in the scenedelegate in the function scene. So logout button doesnt need the navigation or dismiss as we are listening to the auth state anyway

//The autologin is working as we have implemented the code in the scene delegate so that the user does not have to login constantly.
                                        
                                        
                                    }
                                    
                                    
                                    
                                }
                                
                            }
                            
                            
                        }
                        
                    }



                }
                
            }
            
            
            
            
            
            
            
            
        } else {
            
            let alertController = UIAlertController(title: "All fields are mandatory", message: "Please make sure you have entered all the fields", preferredStyle: .alert)

                    alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    
                   
            present(alertController, animated: true, completion: nil)
            
        }
        
        
    }
    
    
    
    //MARK: ADDING TAP GESTURE ON THE IMAGE.........................StartImagePickAspects
        
    func addingGestureOnImage() {
        
        profileImage.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectAnImage))
        
        profileImage.addGestureRecognizer(tapGesture)
        
        profileImage.clipsToBounds = true
        
    }
    
    //MARK: Selecting the image source and picker
    
    @objc func selectAnImage() {
           
           let imagePicker = UIImagePickerController()
           
        imagePicker.sourceType = .photoLibrary
           
           present(imagePicker, animated: true, completion: nil)
           
           imagePicker.allowsEditing = true
           
           imagePicker.delegate = self
           
       }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        
        if let imageSelected = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            self.profileImage.image = imageSelected
            
            imageToBeUploadedOnFirebase = imageSelected
            
        }
        
        self.dismiss(animated: true, completion: nil)
        
    }
    //MARK: ADDING IMAGE.............................EndImagePickAspects
    
}

