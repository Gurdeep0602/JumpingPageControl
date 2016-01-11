//
//  IndicatorLayer.swift
//  JumpingPageControl
//
//  Created by Gurdeep Singh on 10/01/16.
//  Copyright © 2016 Gurdeep Singh. All rights reserved.
//

import UIKit

class IndicatorLayer: CALayer {

    var indicatorTintColor : CGColorRef = UIColor(red: 248.0/255.0, green: 162.0/255.0, blue: 30.0/255.0, alpha: 1.0).CGColor
    
    var indicatorRadius : CGFloat = 0.0
}

class PageIndicatorLayer: IndicatorLayer {

    override func layoutSublayers() {
    
        super.layoutSublayers()

        self.backgroundColor = UIColor.clearColor().CGColor

        self.masksToBounds = false

        self.borderWidth = 1.5
        self.borderColor = indicatorTintColor
        
        self.cornerRadius = indicatorRadius
        self.bounds.size = CGSizeMake(indicatorRadius*2, indicatorRadius*2)

        self.transform = CATransform3DMakeScale(0.85, 0.85, 1.0)
    
    }
    
}

class CurrentPageIndicatorLayer : IndicatorLayer {
    
    override func layoutSublayers() {
        
        super.layoutSublayers()
        
        self.backgroundColor = indicatorTintColor
        
        self.masksToBounds = false
       
        self.cornerRadius = indicatorRadius
        self.bounds.size = CGSizeMake(indicatorRadius*2, indicatorRadius*2)
    }
}

