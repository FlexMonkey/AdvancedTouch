//
//  ViewController.swift
//  AdvancedTouch
//
//  Created by Simon Gladman on 17/09/2015.
//  Copyright © 2015 Simon Gladman. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let mainDrawLayer = CAShapeLayer()
    let mainDrawPath = UIBezierPath()
    
    let coalescedDrawLayer = CAShapeLayer()
    let coalescedDrawPath = UIBezierPath()

    let predictedDrawLayer = CAShapeLayer()
    let predictedDrawPath = UIBezierPath()
    
    let layers: [CAShapeLayer]
    let paths: [UIBezierPath]

    required init?(coder aDecoder: NSCoder)
    {
        layers = [coalescedDrawLayer, mainDrawLayer, predictedDrawLayer]
        paths = [mainDrawPath, coalescedDrawPath, predictedDrawPath]
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = UIColor.blackColor()
        
        // mainDrawLayer
        
        mainDrawLayer.strokeColor = UIColor(red: 0.5, green: 0.5, blue: 1, alpha: 1).CGColor
        mainDrawLayer.lineWidth = 2
        mainDrawLayer.lineCap = kCALineCapRound
        mainDrawLayer.fillColor = nil
        
        view.layer.addSublayer(mainDrawLayer)
        
        // coalescedDrawLayer
        
        coalescedDrawLayer.strokeColor = UIColor.yellowColor().CGColor
        coalescedDrawLayer.lineWidth = 2
        coalescedDrawLayer.lineCap = kCALineCapRound
        coalescedDrawLayer.fillColor = nil
        
        view.layer.addSublayer(coalescedDrawLayer)
        
        // predictedDrawLayer
        
        predictedDrawLayer.strokeColor = UIColor(white: 1, alpha: 0.95).CGColor
        predictedDrawLayer.lineWidth = 1
        predictedDrawLayer.lineCap = kCALineCapRound
        predictedDrawLayer.fillColor = UIColor(white: 1, alpha: 0.75).CGColor
        
        view.layer.addSublayer(predictedDrawLayer)
    }


    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        super.touchesBegan(touches, withEvent: event)
        
        guard let touch = touches.first else
        {
            return
        }
        
        let locationInView = touch.locationInView(view)
        
        for path in paths
        {
            path.moveToPoint(locationInView)
        }
        
        for layer in layers
        {
            layer.hidden = false
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        super.touchesMoved(touches, withEvent: event)
        
        guard let touch = touches.first, event = event else
        {
            return
        }
        
        let locationInView = touch.locationInView(view)
        
        mainDrawPath.addLineToPoint(locationInView)
        mainDrawPath.appendPath(ViewController.createCircleAtPoint(locationInView, radius: 4))
        mainDrawPath.moveToPoint(locationInView)
        
        mainDrawLayer.path = mainDrawPath.CGPath
        
        // draw coalescedTouches
        
        if let coalescedTouches = event.coalescedTouchesForTouch(touch)
        {
            print("coalescedTouches:", coalescedTouches.count)
            
            for coalescedTouch in coalescedTouches
            {
                let locationInView = coalescedTouch.locationInView(view)
                
                coalescedDrawPath.addLineToPoint(locationInView)
                coalescedDrawPath.appendPath(ViewController.createCircleAtPoint(locationInView, radius: 2))
                coalescedDrawPath.moveToPoint(locationInView)
            }
            
            coalescedDrawLayer.path = coalescedDrawPath.CGPath
        }
        
        // draw predictedTouches
        
        if let predictedTouches = event.predictedTouchesForTouch(touch)
        {
            print("predictedTouches:", predictedTouches.count)
            
            for predictedTouch in predictedTouches
            {
                let locationInView =  predictedTouch.locationInView(view)
                
                predictedDrawPath.appendPath(ViewController.createCircleAtPoint(locationInView, radius: 4))
            }
            
            predictedDrawLayer.path = predictedDrawPath.CGPath
        }
        
        // stupid synchronous calculation
        
        var foo = Double(1)
        
        for bar in 0 ... 20_000_000
        {
            foo += sqrt(Double(bar))
        }
    }
    
    static func createCircleAtPoint(origin: CGPoint, radius: CGFloat) -> UIBezierPath
    {
        let boundingRect = CGRect(x: origin.x - radius,
            y: origin.y - radius,
            width: radius * 2,
            height: radius * 2)
        
        let circle = UIBezierPath(ovalInRect: boundingRect)
        
        return circle
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        super.touchesEnded(touches, withEvent: event)
        
        for (path, layer) in zip(paths, layers)
        {
            path.removeAllPoints()
            
            layer.path = path.CGPath
            layer.hidden = false
        }
    }


}

