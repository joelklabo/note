//
//  SignUpViewController.swift
//  Note
//
//  Created by Joel Klabo on 8/20/14.
//  Copyright (c) 2014 Joel Klabo. All rights reserved.
//

import Foundation
import UIKit

class SignUpViewController: UIViewController {
    
    let signUpView = SignUpView()
    
    required init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
    
    override init (nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func loadView() {
        signUpView.startButton.addTarget(self, action: "startTapped", forControlEvents: .TouchUpInside)
        self.view = signUpView
    }
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.redColor()
        self.view.frame = UIScreen.mainScreen().bounds
    }
    
    func startTapped () {
        println("start button tapped")
        // Check that a name is present
        let name = signUpView.nameField.text
        
        if (name != "") {
            // There is something in the text field create the user
            println("some thing is in there! \(name)")
        } else {
            // Alert that they need to pick a name
            var alert = UIAlertController(title: "Alert", message: "You gotta pick a name", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    
}