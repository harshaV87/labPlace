//
//  detailViewController.swift
//  labPlace
//
//  Created by Venkata harsha Balla on 5/10/20.
//  Copyright © 2020 BVH. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class detailViewController: UIViewController {
    
    
    var labDetails : postContentN?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        let textSplit = labDetails?.postText
    
        guard let splitStringArray = textSplit?.split(separator: "@", maxSplits: 1).map(String.init) else {return}
        
        labeName.text = splitStringArray[0]
        
        Address.text = splitStringArray[1]
        
        postedDate.text = labDetails?.postTimeAndDate
        
    
        showAddressOnMap()
        
        
    }
    
    //MARK: IBO OUTLETS
    
    
    @IBOutlet weak var labeName: UILabel!
    
    
  
    @IBOutlet weak var postedDate: UITextField!
    
    
    @IBOutlet weak var Address: UITextView!
    
    
    
    @IBOutlet weak var mapViewMark: MKMapView!
    
    
//MARK: Bar Button Items
    
    
    @IBAction func cancelClicked(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
    
    //LOCATION
    
    func showAddressOnMap() {
        
        let geoCod = CLGeocoder()
        
        geoCod.geocodeAddressString(Address.text) { (placemark, err) in
            
            
            if err == nil {
                
                
                
                guard let labCoordlat = placemark?.first?.location?.coordinate.latitude else {return}
                
                guard let labCoordlon = placemark?.first?.location?.coordinate.longitude else {return}
                
                
                let annotation = MKPointAnnotation()
                
                annotation.title = self.labeName.text
                
                annotation.subtitle = self.Address.text
                
                annotation.coordinate = CLLocationCoordinate2D(latitude: labCoordlat, longitude: labCoordlon)
                
                
                
                self.mapViewMark.addAnnotation(annotation)
                
              
            }
            
            
        }
        
    }
    
    
    
}
