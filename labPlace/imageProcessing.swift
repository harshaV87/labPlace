//
//  imageProcessing.swift
//  labPlace
//
//  Created by Venkata harsha Balla on 5/9/20.
//  Copyright © 2020 BVH. All rights reserved.
//

import Foundation
import UIKit

class imageService {
    
    
    static let cache = NSCache<NSString, UIImage>()
    
    
    
    static func downloadImage (from imageUrl: String!, completion: @escaping (_ image: UIImage?, _ imageUrl: String?) -> ()) {
        
        let url = URLRequest(url: URL(string: imageUrl)!)
        
        let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            var downlaoadImage: UIImage?
            
            if let data = data {
                downlaoadImage = UIImage(data: data)
        
        }
            
            
            if downlaoadImage != nil {
                
                cache.setObject(downlaoadImage!, forKey: imageUrl! as NSString)
                
            }
            
            
            //since all of this is happening in the background thread so we have to move it to the new thread in the dispatch queue
            
            DispatchQueue.main.async {
                
                completion(downlaoadImage, imageUrl)
                
            }
            
            
            
        }
        
        
        dataTask.resume()
        
    }
 
    static func getImage(from imageUrl: String!, completion: @escaping (_ image: UIImage?, _ imageUrl: String?) -> ()) {
        
        
        
        if let imageC = cache.object(forKey: imageUrl! as NSString) {
            completion(imageC, imageUrl)
        } else {
            downloadImage(from: imageUrl, completion: completion)
        }
        
    }
    
}

