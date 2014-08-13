//
//  Photo.swift
//  Note
//
//  Created by Joel Klabo on 8/12/14.
//  Copyright (c) 2014 Joel Klabo. All rights reserved.
//

import UIKit
import CoreLocation

class Photo {
    
    var photo:UIImage
    var location:CLLocation
    
    init(photo:UIImage, location:CLLocation) {
        self.photo = photo
        self.location = location
    }
    
}