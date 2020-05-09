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
        
        navigationController?.navigationBar.topItem?.title = "Your Feed"
        
       
    
        
        
    }
    
    
    
    

    
    

    //Test Pagination
    
    var currentDate : Double!
    
    var currentRelatedKey: String!
    
    
    
    //start of a newnew fetch
    
    
    func newFetchN(completion: @escaping (_ posts: [postContentN]) -> ()) {
        
     
        
      

        
        
        oldPostRef.queryLimited(toLast: 5).observeSingleEvent(of: .value) { (snapshot) in
            
            
//            print("the snap previous is as follows \(snapshot)")
        
            var temPostsN = [postContentN]()
            
            let lastPost = self.postsInN.last
            
            for child in snapshot.children {
                
                
                
                
                if let childSnapshot = child as? DataSnapshot,
                let dict = childSnapshot.value as? [String:Any],
                    let userIDD = dict["userID"] as? String,
                    let userProfile = postContentN.parse(childSnapshot.key, dict),
                    childSnapshot.key != lastPost?.keyID {
                                        
 temPostsN.insert(userProfile, at: 0)
            

                                        
                                    }
                    
                
            }
            
            return completion(temPostsN)
            
        }
        
    }
    
    
    //end of a newnewfecth
    
    
    
    
    
    // MARK: - Table view data source

   

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
//
//        print("the count is \(postsInN.count)")
        
        return postsInN.count
    }

    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 400
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postIn", for: indexPath) as! postShow
        
      

        cell.postID = postsInN[indexPath.row].keyID
        
        
    //MARK: UNCOMMENT THIS TO MAKE IT WORK - CELL.SET(post: newSort[indexPath.row])
        cell.set(post: postsInN[indexPath.row])
       //MARK: UNCOMMENT THIS TO MAKE IT WORK - CELL.SET(post: newSort[indexPath.row])
        
 

        return cell
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
    
    
    
    
    
    
    
    
    //MARK:........Start of the pagination, refresh button and more posts button
    
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
     //old post ref is for retrieving and loading posts 5 at a time - end
    
     
    
    

    
    
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
    
    //MARK: SCROLL END
    
    //MARK: BATCH FETCH START
    
    func beginBatchFetch() {
        
        fetchingMore = true
        
        
        newFetchN { (postBatchN) in
            
//            print("the newfectchN is as follows \(postBatchN)")
            
            
            self.postsInN.append(contentsOf: postBatchN)
            self.tableView.reloadData()
            
            
            
            self.endReached = postBatchN.count == 0
            
            self.fetchingMore = false
            
        }
        

        
    }
    
    //MARK: BATCH FETCH END
    
        //MARK: ........end of the pagination, refresh button and more posts button
    
    
    
    
   //MARK: ...........................................................................................
    
    
    
    
    
    
    

}

//MARK:........................................................CELL ASPECTS...............................................................
//MARK: CELL ASPECST - START

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
        
        
        userName.text = post.author
        
        postText.text = post.postText

        timeStamp.text = post.postTimeAndDate
        
    
        
        
        
    }
    
    
    
    //MARK: IBO ACTIONS
    
    
    
    var postID: String!
    
    
  
   
    
}

//MARK: CELL ASPECST - END

