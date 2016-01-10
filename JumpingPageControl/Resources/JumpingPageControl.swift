//
//  JumpingPageControl.swift
//  JumpingPageControl
//
//  Created by Gurdeep Singh on 10/01/16.
//  Copyright © 2016 Gurdeep Singh. All rights reserved.
//

import UIKit

@objc protocol JumpingPageControlDelegate {

   optional func jumpingPageControl(jumpingPageControl : JumpingPageControl, manuallyUpdatedToCurrentPage currentPage : Int)
}

@IBDesignable
class JumpingPageControl: UIControl {
    
    @IBInspectable var animationEnabled : Bool = true
    
    @IBInspectable var numberOfPages : UInt = 3 {
        
        didSet {
            
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
    
    @IBInspectable var currentPage : UInt = 1 {
        
        didSet {
    
            if currentPage > numberOfPages {
                currentPage = numberOfPages
            
            } else if currentPage < 1 {
                currentPage = 1
            }
            
            let yPosition : CGFloat = self.layer.bounds.height/2
            
            let oldPosition = pageIndicators[Int(oldValue-1)].position
            let newPosition = pageIndicators[Int(currentPage-1)].position
            
            let p = CGPointMake((oldPosition.x+newPosition.x)/2, yPosition-40)
        
            currentPageIndicator.position = newPosition

            if !animationEnabled {
                
                currentPageIndicator.removeAllAnimations()
            
            } else {
                
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
    
    var delegate : JumpingPageControlDelegate?
    
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
            currentPageIndicator.position = pageIndicators[Int(currentPage-1)].position
        }
        
        currentPageIndicator.setNeedsLayout()
    }
    
    override func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?) {
        
        super.endTrackingWithTouch(touch, withEvent: event)
        
        guard let touchPoint = touch?.locationInView(self) else {   return  }
        
        if touchPoint.x > currentPageIndicator.position.x + gap + indicatorRadius {
        
            currentPage++
        }
        
        if touchPoint.x < currentPageIndicator.position.x - gap - indicatorRadius {
        
            currentPage--
        }
        
        delegate?.jumpingPageControl?(self, manuallyUpdatedToCurrentPage: Int(currentPage))
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
