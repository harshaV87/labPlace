//
//  feedCreationViewController.swift
//  labPlace
//
//  Created by Venkata harsha Balla on 5/9/20.
//  Copyright © 2020 BVH. All rights reserved.
//


import UIKit
import Firebase


class feedCreationViewController: UIViewController, UITextViewDelegate {
    
    //MARK: IBO outlets
    
    @IBOutlet weak var selectedImageForPost: UIImageView!
    
    
    @IBOutlet weak var textForPost: UITextView!
    
    
    @IBOutlet weak var navBar: UINavigationBar!
    
    
    //MARK: Variables and constants
    
    var userF : String = ""
    
    var picker = UIImagePickerController()
    
    var newFormatter = DateFormatter()
    
    var timer = Timer()
    
    var dateAndTimeForServer : String = ""
    
    var postCreationProfileImage : String!
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        picker.delegate = self
        
        //implementing the custom texholder in the uiview - Start
        
        textForPost.text = "Enter your text for the post here"
        
        textForPost.font = UIFont(name: "verdana", size: 13.0)
        
        textForPost.textColor = UIColor.lightGray
        
        textForPost.delegate = self
        
        textForPost.returnKeyType = .done
        
        
        //implementing the custom texholder in the uiview - End
        
        NavBarCustomisation()
        
       accesingImage()
        
       
        

        
        
        
               
    }
    
    //MARK: TEXTVIEW DELEGATES FOR THE TEXTVIEW PLACEHOLDER - START
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.text == "Enter your text for the post here" {
            
            textView.text = ""
            textView.textColor = UIColor.black
            textView.font = UIFont(name: "verdana", size: 18.0)
            
            
            
        }
        
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            textView.resignFirstResponder()
        }
        
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text == "" {
            
            textForPost.text = "Enter your text for the post here"
            
            textForPost.font = UIFont(name: "verdana", size: 13.0)
            
            textForPost.textColor = UIColor.lightGray
            
        }
        
    }
    
    
    
    
    
    
    
   
    
    
    
    
    
    //MARK: DATE CREATION START
    
    
    func dateUpdationOnNavbar() {
          
          
          var formatter = DateFormatter()
        
//        newFormatter = formatter
        
        formatter = newFormatter
          
          formatter.dateFormat = "E, MMM d, YYYY"
        
        formatter.timeZone = .autoupdatingCurrent
        
        formatter.timeStyle = .short
          
        formatter.dateStyle = .long
    
    
        timer = Timer.scheduledTimer(timeInterval: 0, target: self, selector: #selector(updateLabel), userInfo: nil, repeats:true)
                 
        
          
      }
    
    
    @objc func updateLabel() -> Void {
               
               navBar.topItem?.title = newFormatter.string(from: Date())
        
        var dateAndTimeString = newFormatter.string(from: Date())
        
        
        dateAndTimeForServer = dateAndTimeString
        
               
           }
    
    
    
    
    
    func NavBarCustomisation() {
          
        navBar.barTintColor = .white
          
          navBar.tintColor = .white
          
          navBar.isTranslucent = false
        
        navBar.titleTextAttributes = [NSAttributedString.Key.font : UIFont(name: "AvenirNext-Regular", size: 14)]
          

          
      }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
           
           //Showing default date on the nav bar
           
           dateUpdationOnNavbar()
           
       }
    
    
    
    
    
    
    //MARK: DATE CREATION END
    
    
    //MARK: Accesing profileImageForPost - Start
    
    
    func accesingImage() {
        
        let databaseRef = Database.database().reference()
        
        databaseRef.child("users").queryOrderedByKey().observeSingleEvent(of: .value) { (snapshot) in
            
            let usersFromDat = snapshot.value as! [String : AnyObject]
            
            for (_, value) in usersFromDat {
                
                if let uid = value["uid"] as? String {
                    
                    if uid == Auth.auth().currentUser?.uid {
                        
                        let profileImageURL = value["profileImageURL"] as? String
                            
                            
                        self.postCreationProfileImage = profileImageURL
                        
                        
                       
                    }
                }
            }
              
          
        }
        
       
        
        
        
    }
    
    
    
//MARK: IBO actions
    
    //MARK: CANCEL BUTTON PRESSED
    
    
    
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        
        
        
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
    
    
    
    
    @IBAction func selectPictureForPost(_ sender: Any) {
        
        
        picker.allowsEditing = true
        
        picker.sourceType = .photoLibrary
        
        present(picker, animated: true, completion: nil)
        
        
        
    }
    

    @IBAction func postThePost(_ sender: Any) {
        
        
        
        
        if textForPost.text != "Enter your text for the post here" {
        
           
        let uid = Auth.auth().currentUser?.uid
        
        let databaseRef = Database.database().reference()
        
        let storageRef = Storage.storage().reference(forURL: "gs://labplace-10a7a.appspot.com/users")
        
        //Creating posts and a key for every post in database and storage
        
        let key = databaseRef.child("posts").childByAutoId().key
        
        let imageRefStorage = storageRef.child("posts").child(uid!).child("\(key).jpg")
        
        
        //now we are converting the selected image from the picker to the data and will be upoading that into the storage and databse and checking that the text field is not empty
        
        
        if let data = selectedImageForPost.image?.jpegData(compressionQuality: 0.7) {
        
            let uploadTask = imageRefStorage.putData(data, metadata: nil) { (metadata, error) in
                
                if error != nil {
                    
let alertController = UIAlertController(title: "Something went wrong", message: "\(error?.localizedDescription ?? "Please try again")", preferredStyle: .alert)

alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    

self.present(alertController, animated: true, completion: nil)
                    
                    
                    
                    return
                    
                }
            
                imageRefStorage.downloadURL { (url, err) in
                    
                    if err != nil {
                        
                        //error is not nil
                        
    let alertController = UIAlertController(title: "Something went wrong", message: "\(err?.localizedDescription ?? "Please try again")", preferredStyle: .alert)

    alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))

    self.present(alertController, animated: true, completion: nil)
                        

                        
                    } else {
                        
                      //error is nil
                        
                        if let url = url {
                            
                            
                          
                            
                            let feed = ["userID" : uid!,
                                        "pathToImage" : url.absoluteString,
                                        
                                        "author" : Auth.auth().currentUser?.displayName!,
                                        "postID" : key!,
                                        "postText" : self.textForPost.text,
                                        "postTimeAndDate" : self.dateAndTimeForServer,
                                        "userProfileImageUrl" : self.postCreationProfileImage,
                                        "Date":
                                            [".sv":"timestamp"]
                            ] as [String : Any]
                            
                            let postFeed = ["\(key ?? "error")" : feed]
                            
                            
                            databaseRef.child("posts").updateChildValues(postFeed)
                            
                            
                            let navVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tabBarVC")
                            
                            navVc.modalPresentationStyle = .fullScreen
                            
                            navVc.hidesBottomBarWhenPushed = false
                            
                            self.present(navVc, animated: true, completion: nil)
                            
                        }
                        
                        
                    }
                    
                    
                }
                
                
                
            }
        
        
        
        } else {
            
          
            
            let feed = ["userID" : uid!,
                        "pathToImage" : "no image",
                        
                        "author" : Auth.auth().currentUser?.displayName!,
                        "postID" : key!,
                        "postText" : self.textForPost.text!,
                        "postTimeAndDate" : self.dateAndTimeForServer,
                        "userProfileImageUrl" : self.postCreationProfileImage
            ] as [String : Any]
            
            let postFeed = ["\(key ?? "error")" : feed]
            
            
            
           
            
            databaseRef.child("posts").updateChildValues(postFeed)
            
            
            self.dismiss(animated: true, completion: nil)
            
            
        }
    
        
        } else {
            
            let alertController = UIAlertController(title: "Textfield is empty", message: "Please enter your text to post", preferredStyle: .alert)

            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))

            self.present(alertController, animated: true, completion: nil)
            
            
        }
        
        
    }
    
    
    
}



//MARK: ImagePickingForPost

extension feedCreationViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let imageSelectedForPost = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            self.selectedImageForPost.image = imageSelectedForPost
            
            self.dismiss(animated: true, completion: nil)
            
        }
        
    }
    
    

    
    
}

