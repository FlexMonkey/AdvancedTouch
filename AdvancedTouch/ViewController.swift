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
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = UIColor.blackColor()
        
        // mainDrawLayer
        
        mainDrawLayer.strokeColor = UIColor(red: 0.5, green: 0.5, blue: 1, alpha: 1).CGColor
        mainDrawLayer.lineWidth = 20
        mainDrawLayer.lineCap = kCALineCapRound
        mainDrawLayer.fillColor = nil
        
        view.layer.addSublayer(mainDrawLayer)
        
        // coalescedDrawLayer
        
        coalescedDrawLayer.strokeColor = UIColor.yellowColor().CGColor
        coalescedDrawLayer.lineWidth = 10
        coalescedDrawLayer.lineCap = kCALineCapRound
        coalescedDrawLayer.fillColor = nil
        
        view.layer.addSublayer(coalescedDrawLayer)
        
        // predictedDrawLayer
        
        predictedDrawLayer.strokeColor = UIColor(white: 1, alpha: 0.95).CGColor
        predictedDrawLayer.lineWidth = 2
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
        
        mainDrawPath.moveToPoint(touch.locationInView(view))
        coalescedDrawPath.moveToPoint(touch.locationInView(view))
        predictedDrawPath.moveToPoint(touch.locationInView(view))
        
        coalescedDrawLayer.hidden = false
        mainDrawLayer.hidden = false
        predictedDrawLayer.hidden = false
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        super.touchesMoved(touches, withEvent: event)
        
        guard let touch = touches.first, event = event else
        {
            return
        }
        
        mainDrawPath.addLineToPoint(touch.locationInView(view))
        mainDrawLayer.path = mainDrawPath.CGPath
        
        // draw coalescedTouches
        
        if let coalescedTouches = event.coalescedTouchesForTouch(touch)
        {
            print("coalescedTouches:", coalescedTouches.count)
            
            for coalescedTouch in coalescedTouches
            {
                coalescedDrawPath.addLineToPoint(coalescedTouch.locationInView(view))
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
                
                let circle = UIBezierPath(ovalInRect: CGRect(x: locationInView.x - 4, y: locationInView.y - 4, width: 8, height: 8))
                
                predictedDrawPath.appendPath(circle)
            }
            
            predictedDrawLayer.path = predictedDrawPath.CGPath
        }
        
        // stupid synchronous calculation
        
        var foo = Double(1)
        
        for bar in 0 ... 2_000_000
        {
            foo += sqrt(Double(bar))
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        super.touchesEnded(touches, withEvent: event)
        
        mainDrawPath.removeAllPoints()
        coalescedDrawPath.removeAllPoints()
        predictedDrawPath.removeAllPoints()
        
        coalescedDrawLayer.path = coalescedDrawPath.CGPath
        mainDrawLayer.path = mainDrawPath.CGPath
        predictedDrawLayer.path = predictedDrawPath.CGPath
        
        coalescedDrawLayer.hidden = true
        mainDrawLayer.hidden = true
        predictedDrawLayer.hidden = true
    }


}

