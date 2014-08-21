//
//  SignUpView.swift
//  Note
//
//  Created by Joel Klabo on 8/20/14.
//  Copyright (c) 2014 Joel Klabo. All rights reserved.
//

import Foundation
import UIKit

class SignUpView: UIView {
    
    let nameField = UITextField()
    let startButton = UIButton()
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        nameField.frame = CGRectMake(0, 40, self.frame.width, 40)
        nameField.backgroundColor = UIColor.whiteColor()
        nameField.placeholder = "What do you want to be called?"
        self.addSubview(nameField)
        
        startButton.frame = CGRectMake(0, 340, self.frame.width, 40)
        startButton.titleLabel.text = "Start"
        startButton.backgroundColor = UIColor.whiteColor()
        self.addSubview(startButton)
        
    }
    
}
