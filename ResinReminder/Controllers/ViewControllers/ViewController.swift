//
//  ViewController.swift
//  ResinReminder
//
//  Created by Andrew Saeyang on 3/20/22.
//

import UIKit

class ViewController: UIViewController {
    let shapeLayer = CAShapeLayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Draw circle
        let center = view.center
        
        //create track layer
        let trackLayer = CAShapeLayer()
        
        let circularPath = UIBezierPath(arcCenter: center, radius: 100, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        trackLayer.path = circularPath.cgPath
        
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        trackLayer.lineWidth = 10
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = CAShapeLayerLineCap.round
        view.layer.addSublayer(trackLayer)
        
        
        shapeLayer.path = circularPath.cgPath
        
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.lineWidth = 10
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        
        shapeLayer.strokeEnd = 0
    
        view.layer.addSublayer(shapeLayer)
        
        
        //Text layer
        
        let textLayer = CATextLayer()
        
        let width = self.view.frame.width
        let height = self.view.frame.height
        
        let fontSize = min(width, height) / 10 - 5
        let offset = min(width, height) * 0.1
        
        textLayer.string = "Progress"
        textLayer.backgroundColor = UIColor.clear.cgColor
        textLayer.foregroundColor = UIColor.black.cgColor
        textLayer.fontSize = fontSize
        //textLayer.frame = CGRect(x: 0, y: (height - fontSize - offset) / 2, width: width, height: height)
        
        textLayer.frame = CGRect(x: 0, y: (height - fontSize - offset) / 2, width: width, height: height)

        textLayer.alignmentMode = .center
        
        
        view.layer.addSublayer(textLayer)
        
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        
    }
    @objc private func handleTap(){
        print("Attempting to animate stroke")
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        basicAnimation.toValue = 1
        basicAnimation.duration = 2
        
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        
        shapeLayer.add(basicAnimation, forKey: "urSoBasic")
        
    }
    

}// End of class
