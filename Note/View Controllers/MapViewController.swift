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

class MapViewController: UIViewController, CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MKMapViewDelegate {
    
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
        mapView.delegate = self
        
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
    
    func MKAnnotationViewFromPhoto(photo:Photo) -> MKAnnotationView {
        let annotationView = MKAnnotationView(annotation:photo, reuseIdentifier: nil)
        return annotationView
    }
    
    func queryPhotosNearLocation(location:CLLocation) {
        println("Got a location \(location)")
        
//        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(CLLocation *testLocation, NSDictionary *bindings) {
//            return ([testLocation distanceFromLocation:targetLocation] <= maxRadius);
//            }];
        
        let locationPredicate = NSPredicate(value: true)
        let photoQuery = CKQuery(recordType: "Photo", predicate: locationPredicate)
        
        let publicDatabase = CKContainer.defaultContainer().publicCloudDatabase
        
        
        // Use query operation in the background
        publicDatabase.performQuery(photoQuery, inZoneWithID: nil) { (records, error) -> Void in
            println("Photos \(records.count)")
            println(error)
            
            let recordArray = records as [CKRecord]
            
            var photoArray = recordArray.map {
                (var record) -> Photo in
                let imageAsset:CKAsset = record.valueForKey("photo") as CKAsset
                let location:CLLocation = record.valueForKey("location") as CLLocation
                let photo = Photo(photo: self.getUIImageFromCKAssetFileUrl(imageAsset), location: location)
                return photo
            }
            
            self.mapView.addAnnotations(photoArray)

        }
        
    }
    
    func getUIImageFromCKAssetFileUrl(asset:CKAsset) -> UIImage {
        let data = NSData.dataWithContentsOfURL(asset.fileURL, options: nil, error: nil)
        let image = UIImage(data: data)
        return image
    }
    
    func savePhotoToCloud(photo:Photo) {
        let photoRecord = CKRecord(recordType: "Photo")
        photoRecord.setValue(CKAssetFromUIImage(photo.photo), forKey: "photo")
        photoRecord.setValue(photo.location, forKey: "location")
        
        let publicDatabase = CKContainer.defaultContainer().publicCloudDatabase
        publicDatabase.saveRecord(photoRecord, completionHandler: { (record, error) -> Void in
            println(record)
            println(error)
        })
    }
    
    func CKAssetFromUIImage(image:UIImage) -> CKAsset {
        UIGraphicsBeginImageContext(image.size);
        image.drawInRect(CGRectMake(0, 0, image.size.width, image.size.height))
        let data = UIImageJPEGRepresentation(UIGraphicsGetImageFromCurrentImageContext(), 0.75);
        UIGraphicsEndImageContext();
        
        let cachesDirectoryURL = NSFileManager.defaultManager().URLForDirectory(.CachesDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true, error: nil)
        let temporaryName = NSUUID.UUID().UUIDString.stringByAppendingPathExtension("jpeg")
        let localURL = cachesDirectoryURL.URLByAppendingPathComponent(temporaryName)
        data.writeToURL(localURL, atomically: true)
        
        return CKAsset(fileURL: localURL)
    }
    
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        let photo = view.annotation as Photo
        self.presentViewController(ImageViewController(image: photo.photo), animated: true, completion: nil)
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
        
        // Got first location
        if (!currentLocation) {
            queryPhotosNearLocation(location)
        }
        
        currentLocation = location
    }
    
}
