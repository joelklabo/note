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
        self.view.addSubview(self.imageView)
        self.imageView.frame = CGRectMake(0, 0, self.imageView.image.size.width, self.imageView.image.size.height)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("imageViewTapped"))
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func imageViewTapped () {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}