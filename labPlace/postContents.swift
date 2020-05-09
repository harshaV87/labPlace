//
//  postContents.swift
//  labPlace
//
//  Created by Venkata harsha Balla on 5/9/20.
//  Copyright © 2020 BVH. All rights reserved.
//

import Foundation


class postContentN: NSObject {
    
    var author: String
    
    var pathToImage: String
    var postID: String
    var postText: String
    var postTimeAndDate: String
    var userID: String
    var userProfileImageUrl: String
    var Date: Double
    var keyID : String
   
 
    init(author: String, pathToImage: String, postID: String, postText: String, postTimeAndDate: String, userID: String, userProfileImageUrl: String, Date: Double, keyID: String
       ) {
           
           self.author = author
          
           self.pathToImage = pathToImage
           self.postID = postID
           self.postText = postText
           self.postTimeAndDate = postTimeAndDate
           self.userID = userID
           self.userProfileImageUrl = userProfileImageUrl
           self.Date = Date
           self.keyID = keyID
       

        
    }
    
    
    
    
    
    static func parse(_ key: String, _ data:[String:Any]) -> postContentN?{
        
       
        
        if let authorD = data["author"] as? String,
                  
                   let pathToImageD = data["pathToImage"] as? String,
                   let postIDD = data["postID"] as? String,
                   let postTextD = data["postText"] as? String,
                   let postTimeAndDateD = data["postTimeAndDate"] as? String,
                   let userIDD = data["userID"] as? String,
                   let userProfileImageUrlD = data["userProfileImageUrl"] as? String,
                       let DateD = data["Date"] as? Double
        
            
            
        
        {
                       
            
            
          
                
            
            return postContentN(author: authorD, pathToImage: pathToImageD, postID: postIDD, postText: postTextD, postTimeAndDate: postTimeAndDateD, userID: userIDD, userProfileImageUrl: userProfileImageUrlD, Date: DateD, keyID: key)
                       
                       
                   }
        
        return nil
    }
    
    
    
}
