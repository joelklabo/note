//
//  Photo.swift
//  Note
//
//  Created by Joel Klabo on 8/12/14.
//  Copyright (c) 2014 Joel Klabo. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class Photo: NSObject, MKAnnotation {
    
    var photo:UIImage
    var location:CLLocation
    var coordinate:CLLocationCoordinate2D
    var title:NSString!
    
    init(photo:UIImage, location:CLLocation) {
        self.photo = photo
        self.location = location
        self.coordinate = location.coordinate
        self.title = nil
    }
    
}