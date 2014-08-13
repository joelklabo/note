//
//  MapViewController.swift
//  Note
//
//  Created by Joel Klabo on 6/28/14.
//  Copyright (c) 2014 Joel Klabo. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CloudKit

class MapViewController: UIViewController, CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let locationManager:CLLocationManager = CLLocationManager()
    let mapView:MKMapView = MKMapView()
    let cameraButton:UIButton = UIButton()
    
    var currentLocation:CLLocation!
    
    required init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
    
    override init (nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    override func viewDidLoad () {
        super.viewDidLoad()
        
        self.view.addSubview(mapView)
        mapView.frame = UIScreen.mainScreen().bounds
        
        mapView.addSubview(cameraButton)
        
        let cameraButtonHeight:CGFloat = 60.0
        cameraButton.frame = CGRectMake(0, mapView.frame.height - cameraButtonHeight, mapView.frame.width, cameraButtonHeight)
        cameraButton.backgroundColor = UIColor.greenColor()
        
        cameraButton.addTarget(self, action: "cameraButtonTapped", forControlEvents: .TouchUpInside)
        
        initializeLocationManager()
    }
    
    func initializeLocationManager () {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func savePhotoToCloud(photo:Photo) {
        let photoRecord = CKRecord(recordType: "Photo")
//        photoRecord.setValue(photo.photo, forKey: "photo")
        photoRecord.setValue(photo.location, forKey: "location")
        
        let publicDatabase = CKContainer.defaultContainer().publicCloudDatabase
        publicDatabase.saveRecord(photoRecord, completionHandler: { (record, error) -> Void in
            println(record)
            println(error)
        })
    }
    
    // Note Button Tapped callback
    
    func cameraButtonTapped () {
        if let imagePicker = imagePickerController() {
            self.presentViewController(imagePicker, animated: true, completion:nil)
        }
    }
    
    // Setup UIImagePickerController
    
    func imagePickerController() -> UIImagePickerController! {
        if (UIImagePickerController.isSourceTypeAvailable(.Camera)) {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .Camera
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            return imagePicker
        } else {
            return nil
        }
    }
    
    // UIImagePickerControllerDelegate methods
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController!) {
        self.presentedViewController.dismissViewControllerAnimated(false, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]!) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            let photo:Photo = Photo(photo: image as UIImage, location: currentLocation)
            savePhotoToCloud(photo)
            
        } else {
            // Something went wrong
        }
        
        self.presentedViewController.dismissViewControllerAnimated(false, completion: nil)
    }
    
    // CLLocationManagerDelegate methods
    
    func locationManager(manager:CLLocationManager, didUpdateLocations locations:[AnyObject]) {
        let location:CLLocation = locations[locations.count - 1] as CLLocation
        let region:MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 50, 50)
        mapView.setRegion(region, animated: true)
        
        // Keep track of the current location
        currentLocation = location
    }
    
}
