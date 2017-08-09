//
//  UINavigationBar+Transparent.swift
//  FirebaseDemo
//
//  Created by Simon Ng on 5/1/2017.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        // Make the navigation bar transparent
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true
        self.navigationBar.tintColor = UIColor.white//blue.withAlphaComponent(0.5)
        //self.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Rubik-Medium", size: 20)!,
        //                                         NSForegroundColorAttributeName: UIColor.white]
        
    }
}
extension UIImagePickerController {
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.isTranslucent = false
        self.navigationBar.tintColor = UIColor.white//White.withAlphaComponent(0.5) //Text Color
        self.navigationBar.barTintColor = UIColor(hue: 0.675, saturation: 0.58, brightness: 0.68,  alpha: 0.75)
        self.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName : UIColor.white
        ] // Title color
        
    }
}
