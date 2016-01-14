//
//  JumpingPageControl.swift
//  JumpingPageControl
//
//  Created by Gurdeep Singh on 10/01/16.
//  Copyright © 2016 Gurdeep Singh. All rights reserved.
//

import UIKit

@IBDesignable
class JumpingPageControl: UIControl {
    
    @IBInspectable var animationEnabled : Bool = true
    
    @IBInspectable var numberOfPages : Int = 3 {
        
        didSet {
            
            if numberOfPages < 0 {
                numberOfPages = 0
            }
            
            for pageIndicator in pageIndicators {
                pageIndicator.removeFromSuperlayer()
            }
            
            pageIndicators.removeAll(keepCapacity: false)
            
            if numberOfPages < 1 {
                numberOfPages = 1
            }
            
            for _ in 0..<numberOfPages {
                
                let pageIndicator = PageIndicatorLayer()
                pageIndicators.append(pageIndicator)
                pageIndicator.frame = CGRectZero
                
                self.layer.addSublayer(pageIndicator)
            }
            
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable var currentPage : Int = 1 {
        
        didSet {
    
            if currentPage > numberOfPages-1 {
                currentPage = numberOfPages-1
            
            } else if currentPage < 0 {
                currentPage = 0
            }
            
            let yPosition : CGFloat = self.layer.bounds.height/2
            
            let oldPosition = pageIndicators[oldValue].position
            let newPosition = pageIndicators[currentPage].position
            
            let p = CGPointMake((oldPosition.x+newPosition.x)/2, yPosition-40)
        
            currentPageIndicator.position = newPosition

            if !animationEnabled {
                
                currentPageIndicator.removeAllAnimations()
            
            } else if oldPosition.x > 0 {
                
                let path = UIBezierPath()
                path.moveToPoint(oldPosition)
                path.addQuadCurveToPoint(newPosition, controlPoint: p)
                
                let animation = CAKeyframeAnimation(keyPath: "position")
                animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
                animation.duration = 0.2
                animation.path = path.CGPath
                
                currentPageIndicator.addAnimation(animation, forKey: nil)
            }

            self.sendActionsForControlEvents(UIControlEvents.ValueChanged)
        
        }
    
    }
    
    @IBInspectable var color : UIColor = UIColor(red: 248.0/255.0, green: 162.0/255.0, blue: 30.0/255.0, alpha: 1.0) {
    
        didSet {
            
            for pageIndicator in pageIndicators {
                pageIndicator.indicatorTintColor = color.CGColor
            }
            
            currentPageIndicator.indicatorTintColor = color.CGColor

            self.setNeedsLayout()
        }
    }
    
    @IBInspectable var indicatorRadius : CGFloat = 8.0 {

        didSet {
            
            if indicatorRadius.isSignMinus {
                indicatorRadius = 0
            }
            
            for pageIndicator in pageIndicators {
                pageIndicator.indicatorRadius = indicatorRadius
            }
            
            currentPageIndicator.indicatorRadius = indicatorRadius
            
            self.setNeedsLayout()
        }
    
    }
    
    @IBInspectable var gap : CGFloat = 6 {
        
        didSet {
            
            if gap.isSignMinus {
                gap = 0
            }
            
            self.setNeedsLayout()
        }
    }
    
    private var pageIndicators = [PageIndicatorLayer]()
    private var currentPageIndicator = CurrentPageIndicatorLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupSubviews()
    }
    
    private func setupSubviews() {
        
        currentPageIndicator.frame = CGRectZero
        self.layer.addSublayer(currentPageIndicator)
        self.clipsToBounds = false
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
    
        self.clipsToBounds = false

        self.backgroundColor = UIColor.clearColor()

        let positionY : CGFloat = self.layer.bounds.height/2

        let indicatorDiameter = indicatorRadius*2
        
        let totalWidth = (indicatorDiameter * pageIndicators.count.toCGFloat) + (gap * (pageIndicators.count-1).toCGFloat)
        let startX = (self.bounds.width - totalWidth)/2 + indicatorRadius
        
        for i in 0..<pageIndicators.count {

            let pageIndicator = pageIndicators[i]
            
            let positionX = startX + i.toCGFloat*(indicatorDiameter+gap)
            
            pageIndicator.position = CGPointMake(positionX, positionY)

            pageIndicator.setNeedsLayout()
        }
        
        if pageIndicators.count > 0 {
            currentPageIndicator.position = pageIndicators[currentPage].position
        }
        
        currentPageIndicator.setNeedsLayout()
    }
    
    override func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?) {
        
        super.endTrackingWithTouch(touch, withEvent: event)
        
        guard let touchPoint = touch?.locationInView(self) else {   return  }
        
        if touchPoint.x > currentPageIndicator.position.x + gap + indicatorRadius || (currentPage == numberOfPages-1 && touchPoint.x > currentPageIndicator.position.x) {
        
            currentPage = currentPage == numberOfPages-1 ? numberOfPages-1 : (currentPage+1)
        
        } else if touchPoint.x < currentPageIndicator.position.x - gap - indicatorRadius || (currentPage == 0 && touchPoint.x < currentPageIndicator.position.x) {
        
            currentPage = currentPage == 0 ? 0 : (currentPage-1)
        }
    }
    
}

extension Int {

    var toCGFloat : CGFloat {
        return CGFloat(self)
    }
}

extension UInt {

    var toCGFloat : CGFloat {
        return Int(self).toCGFloat
    }
}
