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
    var safeArea: UILayoutGuide {
        return self.view.safeAreaLayoutGuide
    }
    
    let shapeLayer = CAShapeLayer()
    
    var currentResin = 0
    var resinCap = 0
    var resinPerTick = 1
    
    
    var timerCounting: Bool = false
    var startTime: Date?
    var stopTime: Date?
    var endTime: Date?
    
    // MARK: - Outlets
    
    @IBOutlet weak var notifyNowButton: UIButton!
    @IBOutlet weak var startStopButton: UIButton!
    
    // MARK: - User Defaults
    let userDefaults = UserDefaults.standard
    let START_TIME_KEY = "startTime"
    let STOP_TIME_KEY = "stopTime"
    let COUNTING_KEY = "countingKey"
    let END_TIME_KEY = "endTime"
    let CURRENT_RESIN_KEY = "currentResinKey"
    
    var scheduledTimer: Timer!
    
    func setStartTime(date: Date?){
        startTime = date
        userDefaults.set(startTime, forKey: START_TIME_KEY)
    }
    
    func setStopTime(date: Date?){
        stopTime = date
        userDefaults.set(stopTime, forKey: STOP_TIME_KEY)
    }
    
    func setTimerCounting(_ val: Bool){
        timerCounting = val
        userDefaults.set(timerCounting, forKey: COUNTING_KEY)
    }
    
    func setEndTime(date: Date?){
        endTime = date
        userDefaults.set(endTime, forKey: END_TIME_KEY)
    }
    
    func setCurrentResin(resin: Int){
        userDefaults.set(resin, forKey: CURRENT_RESIN_KEY)
    }
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        resinCap = TaskController.shared.task.resinCap
        resinPerTick = TaskController.shared.task.refreshRate
        
        addAllSubViews()
        setupCurrentResinLabel()
        setupResinCapLabel()
        setupTimerLabel()
        setupCurrentResinTextField()
        
        setupProgressBar()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        
        setTimeLabel((resinCap - currentResin))
        
        
        
        // MARK: - User Defaults
        startTime = userDefaults.object(forKey: START_TIME_KEY) as? Date
        stopTime = userDefaults.object(forKey: STOP_TIME_KEY) as? Date
        endTime = userDefaults.object(forKey: END_TIME_KEY) as? Date
        timerCounting = userDefaults.bool(forKey: COUNTING_KEY)
        
        currentResin = userDefaults.object(forKey: CURRENT_RESIN_KEY) as? Int ?? 0
        currentResinLabel.text = "Current Resin: \(currentResin)"
        
        if timerCounting {
            startTimer()
        } else {
            stopTimer()
            if let start = startTime {
                if let stop = stopTime {
                    let time = calcRestartTime(end: start, stop: stop)
                    let diff = Date().timeIntervalSince(time)
                    setTimeLabel(Int(diff) )
                }
            }
        }
        
    }
    
    @objc private func handleTap(){
        print("Attempting to animate stroke")
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        basicAnimation.toValue = 1
        basicAnimation.duration = CFTimeInterval((resinCap - currentResin) * resinPerTick)
        
        print("\(basicAnimation.duration/60)minutes and \(basicAnimation.duration.truncatingRemainder(dividingBy: 60)) until full")
        
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = true
        
        shapeLayer.add(basicAnimation, forKey: "urSoBasic")
        
    }
    
    // MARK: - Helper Methods
    func addAllSubViews(){
        self.view.addSubview(currentResinLabel)
        self.view.addSubview(resinCapLabel)
        self.view.addSubview(timerLabel)
        self.view.addSubview(currentResinTextField)
    }
    
    
    func setupTextLayer1(){
        
        let width = self.view.frame.width
        let height = self.view.frame.height
        
        let fontSize = min(width, height) / 10 - 5
        let offset = min(width, height) * 0.1
        
        textLayer1.frame = CGRect(x: 0, y: (height - fontSize - offset) / 2, width: width, height: height)
        
        textLayer1.alignmentMode = .center
    }
    
    func setupCurrentResinLabel() {
        currentResinLabel.anchor(top: self.safeArea.topAnchor, bottom: nil, leading: self.safeArea.leadingAnchor, trailing: nil, paddingTop: 16, paddingBottom: 0, paddingLeft: 16, paddingRight: 0)
    }
    
    func setupResinCapLabel() {
        resinCapLabel.anchor(top: self.safeArea.topAnchor, bottom: nil, leading: nil, trailing: self.safeArea.trailingAnchor, paddingTop: 16, paddingBottom: 0, paddingLeft: 0, paddingRight: 32)
    }
    func setupTimerLabel() {
        timerLabel.anchor(top: self.safeArea.topAnchor, bottom: nil, leading: nil, trailing: nil, paddingTop: 16, paddingBottom: 0, paddingLeft: 0, paddingRight: 0)
        timerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func setupCurrentResinTextField() {
        currentResinTextField.anchor(top: currentResinLabel.bottomAnchor, bottom: nil, leading: self.safeArea.leadingAnchor, trailing: nil, paddingTop: 0, paddingBottom: 0, paddingLeft: 16, paddingRight: 0)
        
    }
    
    func setResinFromText(){
        let resin: Int = value(forKey: currentResinTextField.text!) as! Int
        currentResin = resin
    }
    
    // MARK: - Views
    let textLayer1: CATextLayer = {
        let textLayer = CATextLayer()
        textLayer.string = "Progress"
        textLayer.backgroundColor = UIColor.clear.cgColor
        textLayer.foregroundColor = UIColor.black.cgColor
        textLayer.fontSize = 40
        
        return textLayer
    }()
    
    let currentResinLabel: UILabel = {
        let resin = UILabel()
        return resin
    }()
    
    let resinCapLabel: UILabel = {
        let resin = UILabel()
        resin.text = String(TaskController.shared.task.resinCap)
        return resin
    }()
    
    let timerLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00:00"
        return label
    }()
    
    let currentResinTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "0"
        return textfield
    }()
    
    // MARK: - Progress Bar
    
    func setupProgressBar() {
        //Draw circle
        let center = view.center
        
        //create track layer
        let trackLayer = CAShapeLayer()
        
        let circularPath = UIBezierPath(arcCenter: center, radius: 100, startAngle: -CGFloat.pi / 2, endAngle: 3 * CGFloat.pi / 2, clockwise: true)
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
        
        shapeLayer.strokeEnd = CGFloat(currentResin) / CGFloat(resinCap)
        //print("CGFloat start value is \(shapeLayer.strokeEnd)")
        
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
        
    }
    
    /*These are Test functions below
     *
     */
    
    // MARK: - Actions
    @IBAction func resetButtonTapped(_ sender: Any) {
        //fireNotificationNow(1)
        setStopTime(date: nil)
        setStartTime(date: nil)
        setEndTime(date: nil)
        
        
        timerLabel.text = makeTimeString(hour:0, min: 0, sec: 0)
        stopTimer()
    }
    
    @IBAction func startStopAction(_ sender: Any) {
        if timerCounting {
            setStopTime(date: Date())
            stopTimer()
        } else {
            currentResin = Int(currentResinTextField.text!) ?? -1
            if isResinInRange(){
                setStartTime(date: Date())
                calcResinTime()
                startTimer()
                
                
                currentResinLabel.text = "Current Resin: \(currentResin)"
                
                let diff = endTime!.timeIntervalSince(Date())
                setTimeLabel(Int(diff))
            } else {
                print("🛑 Resin is out of range")
            }
        }
    }
    
    // TODO: This check isnt set to source of truth
    func isResinInRange() -> Bool{
        if TaskController.shared.task.currentResin >= 0 && TaskController.shared.task.currentResin <= 160 {
            return true
        } else {
            return false
        }
    }
    
    func calcResinTime() {
        guard let currentResin = currentResinTextField.text else { return }
        
        let now = Date()
        let resinFromText = (Int(currentResin) ?? 22)
        let timeToFullResin = resinCap - resinFromText
        
        TaskController.shared.task.currentResin = resinFromText
        
        
        
        print("Right now it is: \(now)")
        let endTime = Calendar.current.date(byAdding: .second, value: timeToFullResin, to: now)
        print("Resin full at: \(endTime!)")
        
        setEndTime(date: endTime)
    }
    
    func calcRestartTime(end: Date, stop: Date) -> Date {
        let diff = end.timeIntervalSince(stop)
        print(diff)
        return endTime!.addingTimeInterval(diff)
        
    }
    func startTimer() {
        scheduledTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(refreshValue), userInfo: nil, repeats: true)
        setTimerCounting(true)
        startStopButton.setTitle("STOP", for: .normal)
        startStopButton.setTitleColor(UIColor.red, for: .normal )
        
    }
    func stopTimer() {
        if scheduledTimer != nil {
            scheduledTimer.invalidate()
        }
        setTimerCounting(false)
        startStopButton.setTitle("START", for: .normal)
    }
    
    @objc func refreshValue(){
        if let end = endTime{
            
            // let diff = Date().timeIntervalSince(end)
            let diff = end.timeIntervalSince(Date())
            setTimeLabel(Int(diff))
            
            TaskController.shared.task.currentResin += 1
            currentResinTextField.text = "\(TaskController.shared.task.currentResin)"
            
            if Int(diff) == 0 {
                fireNotificationNow(1)
                setStopTime(date: Date())
                stopTimer()
            }
            
        } else {
            
            stopTimer()
            setTimeLabel(0)
        }
    }
    
    func setTimeLabel(_ val: Int){
        let time = secondsToHoursMinuitesSeconds(val)
        let timeString = makeTimeString(hour: time.0, min: time.1, sec: time.2)
        timerLabel.text = timeString
    }
    func secondsToHoursMinuitesSeconds(_ ms: Int) -> (Int, Int, Int){
        let hour = ms / 3600
        let min = (ms % 3600) / 60
        let sec = (ms % 3600) % 60
        return (hour, min, sec)
        
    }
    func makeTimeString(hour: Int, min: Int, sec: Int) -> String {
        var timeString = ""
        timeString += String(format: "%02d", hour)
        timeString += ":"
        timeString += String(format: "%02d", min)
        timeString += ":"
        timeString += String(format: "%02d", sec)
        return timeString
    }
    
    //notifications
    func fireNotificationNow(_ seconds: Double) {
        let content = UNMutableNotificationContent()
        content.title = "TIME TO GRIND BETCH"
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
    
}// End of class


extension ViewController {
    
}
