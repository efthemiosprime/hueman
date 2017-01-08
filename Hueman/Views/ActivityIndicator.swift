//
//  ActivityIndicator.swift
//  Hueman
//
//  Created by Efthemios Prime on 1/1/17.
//  Copyright © 2017 Efthemios Prime. All rights reserved.
//

import UIKit

@IBDesignable public class ActivityIndicator: UIView {
    
    var masterSlider: CGFloat = 0
    
    var timer: NSTimer!
    var timerOn: Bool = false
    var current: CGFloat = 0
    var limit: CGFloat = 1
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clearColor()
        self.hidden = true

    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.hidden = true

    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.hidden = true

    }
    
    override public func drawRect(rect: CGRect) {
        CircleHues.Draw(masterSlider)
    }
    
    
    func startTimer() {
        if !timerOn {
            timerOn = true
            timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(startAnimation), userInfo: nil, repeats: true)
        } else { print("Animation Already running") }
    }
    
    
    func show() {
        startTimer()
        self.hidden = false
    }
    
    func hide() {
        stopTimer()
        self.hidden = true
    }
    
    func startAnimation() {
        self.masterSlider = current
        self.setNeedsDisplay()
        current -= 0.1
        
        
    }
    
    func stopTimer() {
        
        timer.invalidate()
        timerOn = false
        current = 0
        self.masterSlider = 1
        self.setNeedsDisplay()
        
    }
    
}
