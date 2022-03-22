//
//  ViewController.swift
//  ResinReminder
//
//  Created by Andrew Saeyang on 3/20/22.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {
    // MARK: - Properties
    let shapeLayer = CAShapeLayer()

    
    // MARK: - Outlets
    
    
    
    // MARK: - Life Cycles
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
    
    // MARK: - Actions
    
    /*These are test functions below
     *
     */
    @IBAction func buttonTapped(_ sender: Any) {
        fireNotificationNow(1)
    }
    
    @IBAction func fiveSeconds(_ sender: Any) {
        fireNotificationNow(5)

    }
    

}// End of class


extension ViewController {
    
    /*These are Test functions below
     *
     */
    func fireNotificationNow(_ seconds: Double) {
        let content = UNMutableNotificationContent()
        content.title = "Test Notification"
        content.body = "A button has been tapped"
        content.sound = .default
        content.userInfo = [ "Tapped" : "identifier" ]
        content.categoryIdentifier = "ButtonReminderCategoryIdentifier"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: false)
        
        let request = UNNotificationRequest(identifier: "identifier", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error{
                print("Unable to add notification request, \(error.localizedDescription)")
            }
        }
    }
}
