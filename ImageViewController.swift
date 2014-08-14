//
//  ImageViewController.swift
//  Note
//
//  Created by Joel Klabo on 8/13/14.
//  Copyright (c) 2014 Joel Klabo. All rights reserved.
//

import Foundation
import UIKit

class ImageViewController: UIViewController {
    
    var imageView = UIImageView()
    
    convenience init(image: UIImage) {
        self.init(nibName: nil, bundle: nil)
        self.imageView.image = image
    }
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.view.addSubview(self.imageView)

        let imageSize:CGFloat = 320
        
        let imageRect = CGRectMake(0, 0, imageSize, imageSize)
        self.imageView.frame = imageRect
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("imageViewTapped"))
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func imageViewTapped () {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}