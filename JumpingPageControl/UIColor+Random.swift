//
//  UIColor+Random.swift
//  StickyNoteApp
//
//  Created by Gurdeep Singh on 29/12/15.
//  Copyright © 2015 AppInventiv. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {

        class func randomColor() -> UIColor {
        
            let randomRed:CGFloat = CGFloat(drand48())
        
            let randomGreen:CGFloat = CGFloat(drand48())
        
            let randomBlue:CGFloat = CGFloat(drand48())
        
            return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
        
        }
    
}