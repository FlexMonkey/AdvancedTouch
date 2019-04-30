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

    required init?(coder aDecoder: NSCoder) {
        layers = [mainDrawLayer, coalescedDrawLayer, predictedDrawLayer]
        paths = [mainDrawPath, coalescedDrawPath, predictedDrawPath]
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        
        // common
        
        for layer in layers {
            layer.lineCap = CAShapeLayerLineCap.round
            layer.lineWidth = 2
            layer.fillColor = nil
            
            view.layer.addSublayer(layer)
        }
        
        // mainDrawLayer
        mainDrawLayer.strokeColor = UIColor(red: 0.5, green: 0.5, blue: 1, alpha: 1).cgColor
        
        // coalescedDrawLayer
        coalescedDrawLayer.strokeColor = UIColor.yellow.cgColor

        // predictedDrawLayer
        predictedDrawLayer.strokeColor = UIColor.white.cgColor
        predictedDrawLayer.lineWidth = 1
        predictedDrawLayer.fillColor = UIColor.white.cgColor
    }


    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        for (path, layer) in zip(paths, layers)
        {
            path.removeAllPoints()
            
            layer.path = path.cgPath
            layer.isHidden = false
        }
        
        guard let touch = touches.first else
        {
            return
        }
        
        let locationInView = touch.location(in: view)
        
        for path in paths
        {
            path.move(to: locationInView)
        }
        
        for layer in layers
        {
            layer.isHidden = false
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        super.touchesMoved(touches, with: event)
        
        guard let touch = touches.first, let event = event else
        {
            return
        }
        
        let locationInView = touch.location(in: view)
        
        mainDrawPath.addLine(to: locationInView)
        mainDrawPath.append(UIBezierPath.createCircleAtPoint(origin: locationInView, radius: 4))
        mainDrawPath.move(to: locationInView)
        
        mainDrawLayer.path = mainDrawPath.cgPath
        
        // draw coalescedTouches
        if let coalescedTouches = event.coalescedTouches(for: touch) {
            print("coalescedTouches:", coalescedTouches.count)
            
            for coalescedTouch in coalescedTouches {
                let locationInView = coalescedTouch.location(in: view)
                
                coalescedDrawPath.addLine(to: locationInView)
                coalescedDrawPath.append(UIBezierPath.createCircleAtPoint(origin: locationInView, radius: 2))
                coalescedDrawPath.move(to: locationInView)
            }
            
            coalescedDrawLayer.path = coalescedDrawPath.cgPath
        }
        
        // draw predictedTouches
        if let predictedTouches = event.predictedTouches(for: touch) {
            print("predictedTouches:", predictedTouches.count)
            
            for predictedTouch in predictedTouches {
                let locationInView =  predictedTouch.location(in: view)
                
                predictedDrawPath.move(to: touch.location(in: view))
                predictedDrawPath.addLine(to: locationInView)
                
                predictedDrawPath.append(UIBezierPath.createCircleAtPoint(origin: locationInView, radius: 1))
            }
            
            predictedDrawLayer.path = predictedDrawPath.cgPath
        }
        
        // stupid synchronous calculation
        
        var foo = Double(1)
        
        for bar in 0 ... 4_000_000
        {
            foo += sqrt(Double(bar))
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        super.touchesEnded(touches, with: event)
        
      
    }
}

extension UIBezierPath
{
    static func createCircleAtPoint(origin: CGPoint, radius: CGFloat) -> UIBezierPath
    {
        let boundingRect = CGRect(x: origin.x - radius,
            y: origin.y - radius,
            width: radius * 2,
            height: radius * 2)
        
        let circle = UIBezierPath(ovalIn: boundingRect)
        
        return circle
    }
}

