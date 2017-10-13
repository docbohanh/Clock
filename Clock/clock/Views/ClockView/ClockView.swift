//
//  ClockView.swift
//  clock
//
//  Created by Tuan LE on 9/16/17.
//  Copyright © 2017 Leo LE. All rights reserved.
//

import UIKit

class ClockView: UIView {

    @IBOutlet fileprivate weak var hourImageView: UIImageView?
    @IBOutlet fileprivate weak var minuteImageView: UIImageView?
    @IBOutlet fileprivate weak var secondImageView: UIImageView?
    
    @IBOutlet fileprivate weak var frameWidth: NSLayoutConstraint?
    @IBOutlet fileprivate weak var hourWidth: NSLayoutConstraint?
    @IBOutlet fileprivate weak var minuteWidth: NSLayoutConstraint?
    @IBOutlet fileprivate weak var secondWidth: NSLayoutConstraint?
    @IBOutlet fileprivate weak var centralWidth: NSLayoutConstraint?
    
    var scale: CGFloat = 1.0 {
        didSet {
            updateUIByScaleValue()
        }
    }
    
    fileprivate var timer: Timer?
    fileprivate let shadowColor = UIColor(red: 47.0/255, green: 7.0/255, blue: 82.0/255, alpha: 1.0)
    fileprivate let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
    fileprivate let units = [Calendar.Component.hour, Calendar.Component.minute, Calendar.Component.second, Calendar.Component.nanosecond]
    
    class func createFromNib() -> ClockView {
        return Bundle.main.loadNibNamed("ClockView", owner: nil, options: nil)![0] as! ClockView
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        configUI()
        print("Drawing...")
    }
    
    init() {
        super.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func configUI() {
        hourImageView?.layer.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        minuteImageView?.layer.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        secondImageView?.layer.anchorPoint = CGPoint(x: 0.5, y: 0.7)
    }
    
    private func updateUIByScaleValue() {
        frameWidth?.constant = (frameWidth?.constant ?? 0) * scale
        hourWidth?.constant = (hourWidth?.constant ?? 0) * scale
        minuteWidth?.constant = (minuteWidth?.constant ?? 0) * scale
        secondWidth?.constant = (secondWidth?.constant ?? 0) * scale
        centralWidth?.constant = (centralWidth?.constant ?? 0) * scale
    }
    
    deinit {
        stop()
        print("ClockView DEINIT!!!")
    }
}

//MARK: - Public methods
extension ClockView {
    func start() {
        tick()
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(tick),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil 
    }
}

//MARK: - Private methods
extension ClockView {
    @objc fileprivate func tick() {
        let components = calendar.dateComponents(Set<Calendar.Component>(units), from: Date())
        guard let hour = components.hour,
            let minute = components.minute,
            let second = components.second,
            let nanoSecond = components.nanosecond else {
                return
        }
        let realSecond = Double(second) + pow(Double(nanoSecond),Double(-9))
        let realMinute = Double(minute) + realSecond / 60.0
        let realHour = Double(hour) + realMinute / 60.0
        let secondAngle = realSecond / 60.0 * .pi * 2.0
        let minuteAngle = realMinute / 60.0 * .pi * 2.0
        let hourAngle = realHour / 12.0 * .pi * 2.0
        
        hourImageView?.transform = CGAffineTransform(rotationAngle: CGFloat(hourAngle))
        minuteImageView?.transform = CGAffineTransform(rotationAngle: CGFloat(minuteAngle))
        secondImageView?.transform = CGAffineTransform(rotationAngle: CGFloat(secondAngle))
    }
}
