//
//  postShowTableViewController.swift
//  labPlace
//
//  Created by Venkata harsha Balla on 5/9/20.
//  Copyright © 2020 BVH. All rights reserved.
//

import UIKit
import Firebase
import LocalAuthentication

class postShowTableViewController: UITableViewController {
    
    
    //MARK: Variables and contants
    
    var following = [String]()
    
    

    
    var postsInN = [postContentN]()
    
    var refresh: UIRefreshControl!
    
    
    var fetchingMore = false
    
    var endReached = false
    
    var leadingScreensForBatching : CGFloat = 1.0
    
    

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.separatorColor = .black
        tableView.backgroundView?.backgroundColor = .black
        
        //Navigation bar title
        
        navigationController?.navigationBar.topItem?.title = "List of available labs"
        
       
        
    }
    


    
    // MARK: - Table view data source

   

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
//
//        print("the count is \(postsInN.count)")
        
        return postsInN.count
    }

    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 320
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postIn", for: indexPath) as! postShow
        
      
    
        cell.set(post: postsInN[indexPath.row])
      
        
 

        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let listHere = postsInN[indexPath.row]
        
        
        //creating an alert controller
        
        
        
        let alertCont = UIAlertController(title: listHere.postText, message: "Update the text field or delete the listing", preferredStyle: .alert)
        
        //Creating an Update Actions
        
        
        let updateAction = UIAlertAction(title: "Update", style: .default) { (_) in
            
            
            let postID = listHere.postID
            
            let updatedText = alertCont.textFields?[0].text
            
            let date = listHere.Date
            
            let author = listHere.author
            
            let pathToImage = listHere.pathToImage
            
            let userImage = listHere.userProfileImageUrl
            
            let postDateAndTime = listHere.postTimeAndDate
            
            let userID = listHere.userID
            
            
            
            let feed = ["userID" : userID,
                        "pathToImage" : pathToImage,
                        
                        "author" : author,
                        "postID" : postID,
                        "postText" : updatedText ?? "not updated",
                        "postTimeAndDate" : postDateAndTime,
                        "userProfileImageUrl" : userImage,
                        "Date": date
                            
            ] as [String : Any]
            
            //Now updating the new values here , as follows, accesing the database
            
            
            Database.database().reference().child("posts").child(postID).updateChildValues(feed) { (err, _) in
                
                
                if err == nil {
                    
                    
                    
                    let navVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tabBarVC") as! UITabBarController
                    
                    self.definesPresentationContext = true
                    
                    navVc.modalPresentationStyle = .fullScreen
                    
                        self.present(navVc, animated: true, completion: nil)
                    
                    
                    
                    
                }
                
            }
            
            
        }
        
        //delete action
        
        let deleteAction = UIAlertAction(title: "Delete", style: .default) { (_) in
            
           let postID = listHere.postID
            
            //we are deleting the node after retirving
            
            
            
            
            Database.database().reference().child("posts").child(postID).removeValue { (err, _) in
                
                if err == nil {
                    
                    let navVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tabBarVC") as! UITabBarController
                    
                    self.definesPresentationContext = true
                    
                    navVc.modalPresentationStyle = .fullScreen
                    
                        self.present(navVc, animated: true, completion: nil)
                    
                    
                }
                
            }
            
            
            
            
            
        }
        
        //Detail controller where we can see the details of the lab in a new VC
        
        let seeDetails = UIAlertAction(title: "See Details", style: .default) { (_) in
            
            let navVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "details") as! detailViewController
            
//            navVc.modalPresentationStyle = .fullScreen
            
            
            navVc.labDetails = listHere
          
            let navigationController = UINavigationController(rootViewController: navVc)
            
            
            
            
                self.present(navigationController, animated: true, completion: nil)
            
            
            
        }
        
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .default) { (_) in
            
            
            self.dismiss(animated: true, completion: nil)
            
            
        }
        
        
        
        alertCont.addTextField { (textIn) in
            
            textIn.text = listHere.postText
            
        }
        
        
        
        alertCont.addAction(updateAction)
          alertCont.addAction(deleteAction)
        alertCont.addAction(seeDetails)
        alertCont.addAction(cancelButton)
        
        present(alertCont, animated: true, completion: nil)
        
        
        
        
        
        
    }
    
    
    
    
    //MARK: Bar button aspects
    
    
    
    @IBAction func logOutPressed(_ sender: Any) {
        
        do {
                          
                          try Auth.auth().signOut()
                  
               //Navigationcode to a different view controller is not needed because we have been listening to the auth change states in the scenedelegate in the function scene. So logout button doesnt need the navigation or dismiss as we are listening to the auth state anyway
               
               //The autologin is working as we have implemented the code in the scene delegate so that the user does not have to login constantly.
                      
                     
                      
                  } catch {
                  
    let alertController = UIAlertController(title: "Did not work", message: "\(error.localizedDescription )", preferredStyle: .alert)

        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                                                 
                                                
        self.present(alertController, animated: true, completion: nil)
                  
                     
                      
                      
                      
                  }
        
        
        
    }
    
    
 
    
    
    @IBAction func addButtonpressed(_ sender: Any) {
        
        
        let navVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "feedCreation")
        
        navVc.modalPresentationStyle = .fullScreen
        
        present(navVc, animated: true, completion: nil)
        
    }
    
    
    
    //MARK: ALERT CONTROLLER
    
    func showAlertController(_ message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
//        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    
    //MARK: Start of the pagination scroll view
    
    //this is where we start the variables to define the first and last posts for pagination
    
    var postRef: DatabaseReference {
        
        return Database.database().reference().child("posts")
    }
    
    //old post ref is for retrieving and loading posts 5 at a time - start
    var oldPostRef: DatabaseQuery {
        
        let lastPost = self.postsInN.last
        
        var queryRef: DatabaseQuery
        
        if lastPost == nil {
        
            queryRef = postRef.queryOrdered(byChild: "Date")
        
        } else {
            
            let lastTimeStamp = lastPost?.Date
            
            queryRef = postRef.queryOrdered(byChild: "Date").queryEnding(atValue: lastTimeStamp)
            
        }
        
        return queryRef
        
    }
    
    
     
    
    //MARK: PAGINATION FUNCTION TO SCROLL VIEW
        
        
        func newFetchN(completion: @escaping (_ posts: [postContentN]) -> ()) {
            
         
            
          

            
            
            oldPostRef.queryLimited(toLast: 5).observeSingleEvent(of: .value) { (snapshot) in
                
                
    //            print("the snap previous is as follows \(snapshot)")
            
                var temPostsN = [postContentN]()
                
                let lastPost = self.postsInN.last
                
                for child in snapshot.children {
                    
                    
                    
                    
                    if let childSnapshot = child as? DataSnapshot,
                    let dict = childSnapshot.value as? [String:Any],
                        let _ = dict["userID"] as? String,
                        let userProfile = postContentN.parse(childSnapshot.key, dict),
                        childSnapshot.key != lastPost?.keyID {
                                            
     temPostsN.insert(userProfile, at: 0)
                

                                            
                                        }
                        
                    
                }
                
                return completion(temPostsN)
                
            }
            
        }
        
        

    
    
    //MARK: SCROLL START
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
          
          
          let offsetY = scrollView.contentOffset.y
          
          let contentHeight = scrollView.contentSize.height
          
          if offsetY > contentHeight - scrollView.frame.size.height * leadingScreensForBatching {
              
              
              if !fetchingMore && !endReached {
                  
                //This function fetches the posts during the start and then shows it
                            
                             beginBatchFetch()
                            
                      
                
              }
              
              
          }
          
      
      }
    
   
    
    //MARK: BATCH FETCH START
    
    func beginBatchFetch() {
        
        fetchingMore = true
        
        
        newFetchN { (postBatchN) in
            

            //appending the contents as the function newfetch gets called as we scroll and the list is added to the array until we hit the last post
            
            self.postsInN.append(contentsOf: postBatchN)
            self.tableView.reloadData()
            
            
            
            self.endReached = postBatchN.count == 0
            
            self.fetchingMore = false
            
        }
        

        
    }
    


}


//MARK: CELL ASPECTS - START

class postShow: UITableViewCell {
    
    //MARK: IBO OUTLETS
    
    
    
    override class func awakeFromNib() {
        
        super.awakeFromNib()
        
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        
        //aspects of the main image in the app
               postImage.contentMode = .scaleAspectFill
               postImage.clipsToBounds = true
               postImage.backgroundColor = .red
        
        //This is to prevent image flickering
        
        postedUserImage.image = nil
        postImage.image = nil
        
        
    }
    
    
  

    
    
    
    @IBOutlet weak var userName: UILabel!
    
    
    @IBOutlet weak var timeStamp: UILabel!
    
    
    @IBOutlet weak var postText: UITextView!
    
    
    @IBOutlet weak var postImage: UIImageView!
    
    @IBOutlet weak var postedUserImage: UIImageView!
    
    @IBOutlet weak var noOfLikes: UILabel!
    
    
   
    
    
    
    
    
    weak var post : postContentN?
    
    
    func set(post: postContentN) {
        
        //MARK: HANDLING POST IMAGE - preventing the flickering of the random images because we are asynchronosly downloading images. We only want to set the image only if it is the right one. The two below funtions will handle that problem and also cache the image after its downloaded so we dont use up a lot of data trying to donwload the images everytime
        self.post = post
        
        imageService.getImage(from: post.pathToImage) { (imageOut, imageString) in
            
            
            guard let _post = self.post else {return}
            
            if _post.pathToImage == imageString {
                
                self.postImage.image = imageOut
                
            } else {
//                print("not the rightone")
            }
            
        }
        
        //  MARK: HANDLING user profileimage
        imageService.getImage(from: post.userProfileImageUrl) { (imageOut, imageString) in
            
            
            guard let _post = self.post else {return}
            
            if _post.userProfileImageUrl == imageString {
                
                self.postedUserImage.image = imageOut
                
            } else {
//                print("not the rightone")
            }
            
        }
        
        
        userName.text = "\(post.author) - Post contributor"
        
        postText.text = post.postText

        timeStamp.text = "Posted on \(post.postTimeAndDate)"
        
    
        
        
        
    }
    
    
    
}

//MARK: CELL ASPECST - END

