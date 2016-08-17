//
//  GHCircleLoader.swift
//  GHCircleLoader
//
//  Created by 刘高晖 on 16/5/6.
//  Copyright © 2016年 刘高晖. All rights reserved.
//

import UIKit


class GHCircleLoader: UIView {
    var animating = false
    let CC_ACTIVITY_INDICATOR_VIEW_NUMBEROFFRAMES: Int = 8
    let CC_ACTIVITY_INDICATOR_VIEW_WIDTH: CGFloat = 40
    let CC_ARC_DRAW_PADDING: CGFloat = 3.0
    let CC_ARC_DRAW_DEGREE: CGFloat = 39.0
    let CC_ARC_DRAW_WIDTH: CGFloat = 6.0
    let CC_ARC_DRAW_RADIUS: CGFloat = 10.0
    let CC_ARC_DRAW_COLORS = [UIColor(red: 242/255.0, green: 242/255.0, blue: 242/255.0, alpha: 1.0).CGColor, UIColor(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1.0).CGColor, UIColor(red: 179/255.0, green: 179/255.0, blue: 179/255.0, alpha: 1.0).CGColor, UIColor(red: 128/255.0, green: 128/255.0, blue: 128/255.0, alpha: 1.0).CGColor, UIColor(red: 128/255.0, green: 128/255.0, blue: 128/255.0, alpha: 1.0).CGColor, UIColor(red: 128/255.0, green: 128/255.0, blue: 128/255.0, alpha: 1.0).CGColor, UIColor(red: 128/255.0, green: 128/255.0, blue: 128/255.0, alpha: 1.0).CGColor, UIColor(red: 128/255.0, green: 128/255.0, blue: 128/255.0, alpha: 1.0).CGColor]
    func CCActivityIndicatorViewFrameImage(frame: Int, _ scale: CGFloat) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(CC_ACTIVITY_INDICATOR_VIEW_WIDTH, CC_ACTIVITY_INDICATOR_VIEW_WIDTH), false, scale)
        
        let context = UIGraphicsGetCurrentContext()
        
        var startDegree = CC_ARC_DRAW_PADDING
        for index in 1...8 {
            let arcPath = UIBezierPath()
            let center  = CGPointMake(CC_ACTIVITY_INDICATOR_VIEW_WIDTH / 2,CC_ACTIVITY_INDICATOR_VIEW_WIDTH / 2)
            let startAngle = CGFloat(DegreesToRadians(Double(startDegree)))
            let endAngle = CGFloat(DegreesToRadians(Double(startDegree + CC_ARC_DRAW_DEGREE)))
            arcPath.addArcWithCenter(center, radius: CC_ARC_DRAW_RADIUS, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            CGContextAddPath(context, arcPath.CGPath)
            startDegree += CC_ARC_DRAW_DEGREE + (CC_ARC_DRAW_PADDING * 2)
            CGContextSetLineWidth(context, CC_ARC_DRAW_WIDTH)
            let colorIndex = abs(index - frame)
            let strokeColor = CC_ARC_DRAW_COLORS[colorIndex]
            CGContextSetStrokeColorWithColor(context, strokeColor)
            CGContextStrokePath(context)
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    // MARK: Helpers
    
    func DegreesToRadians (value: Double) -> Double {
        return value * M_PI / 180.0
    }
    
    @IBInspectable var hidesWhenStopped : Bool = true {
        didSet {
            if self.hidesWhenStopped {
                self.hidden = !self.animating
            } else {
                self.hidden = false
            }
        }
    }
    
    func startAnimating () {
        
        func animate () {
            self.animating = true
            self.hidden = false
            let animationDuration: CFTimeInterval = 0.8
            var animationImages = [CGImageRef]()
            
            for frame in 1...CC_ACTIVITY_INDICATOR_VIEW_NUMBEROFFRAMES {
                if #available(iOS 8.0, *) {
                    
                    animationImages.append(CCActivityIndicatorViewFrameImage(frame, UIScreen.mainScreen().nativeScale).CGImage!)
                } else {
                    animationImages.append(CCActivityIndicatorViewFrameImage(frame, 2.0).CGImage!)
                 
                }
            }
            
            let animation = CAKeyframeAnimation(keyPath: "contents")
            animation.calculationMode = kCAAnimationDiscrete
            animation.duration = animationDuration
            animation.repeatCount = HUGE
            animation.values = animationImages
            animation.removedOnCompletion = false
            animation.fillMode = kCAFillModeBoth
            self.layer.addAnimation(animation, forKey: "contents")
        }
        
        if !self.animating {
            animate()
        }
    }
    
    func stopAnimating () {
        self.animating = false
        
        self.layer.removeAnimationForKey("contents")
        if #available(iOS 8.0, *) {
            self.layer.contents = CCActivityIndicatorViewFrameImage(0, UIScreen.mainScreen().nativeScale).CGImage
        } else {
            self.layer.contents = CCActivityIndicatorViewFrameImage(0, 2).CGImage
            // Fallback on earlier versions
        }
        
        if self.hidesWhenStopped {
            self.hidden = true
        }
    }
    
    func isAnimating () -> Bool {
        return self.animating
    }
    
    // MARK: Init & Deinit
    
    convenience init() {
        self.init(frame: CGRectZero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
        self.startAnimating()
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(GHCircleLoader.removew)))
    }
    func removew(){
        self.removeFromSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.startAnimating()
    }
    
    // MARK: Private
    
    
    
    override func intrinsicContentSize() -> CGSize {
        return CGSizeMake(CC_ACTIVITY_INDICATOR_VIEW_WIDTH, CC_ACTIVITY_INDICATOR_VIEW_WIDTH)
    }
    
    override func sizeThatFits(size: CGSize) -> CGSize {
        return CGSizeMake(CC_ACTIVITY_INDICATOR_VIEW_WIDTH, CC_ACTIVITY_INDICATOR_VIEW_WIDTH)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if self.layer.bounds.size.width != CC_ACTIVITY_INDICATOR_VIEW_WIDTH {
            self.layer.bounds = CGRectMake(0, 0, CC_ACTIVITY_INDICATOR_VIEW_WIDTH, CC_ACTIVITY_INDICATOR_VIEW_WIDTH)
        }
    }





    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
