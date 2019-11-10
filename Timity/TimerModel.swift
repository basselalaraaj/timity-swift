//
//  TimerModel.swift
//  Timity
//
//  Created by Bassel Al Araaj on 08/11/2019.
//  Copyright © 2019 Webicom B.V. All rights reserved.
//

import Cocoa

class TimerModel {
    let appDelegate = NSApp.delegate as! AppDelegate
    
    var timer = Timer()
    
    var timerId: Int? = nil
    var duration = 0
    var updateTimerCallback : ((String) -> Void)?
    
    var isTimerOn = false
    var isTimerOnPause = false
    
    
    public init?(){
        
    }
    
    func getTime(time: Int = -1)-> String {
        let timeInit = time >= 0 ? time : duration
        let (h, m) = secondsToHoursMinutesSeconds(seconds:timeInit)
        return String(format: " %02d:%02d", h, m)
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int) {
      return (seconds / 3600, (seconds % 3600) / 60)
    }
    
    func startTimer(id: Int, duration: Int, callBack: ((String) -> Void)?) {
        if(isTimerOn == false || isTimerOnPause == true){
            timerId = id
            self.duration = duration
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: updateTimer(timer:))
            isTimerOn = true
            isTimerOnPause = false
            updateTimerCallback = callBack
            appDelegate.statusItem.button?.title = self.getTime()
            appDelegate.statusItem.button?.contentTintColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        }
    }
    
    func stopTimer() {
        if(isTimerOn == true){
            timer.invalidate()
            isTimerOnPause = false
            isTimerOn = false
            duration = 0
            appDelegate.statusItem.button?.title = getTime()
            appDelegate.statusItem.button?.contentTintColor = .none
        }
    }
    
    func pauseTimer() {
        if(isTimerOn == true){
            timer.invalidate()
            isTimerOnPause = true
            appDelegate.statusItem.button?.contentTintColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        }
    }
    
    func continueTimer() {
        if(isTimerOn == true) {
            timer.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: updateTimer(timer:))
        }
    }
    
    func updateTimer(timer: Timer) {
        self.duration += 1
        appDelegate.statusItem.button?.title = self.getTime()
        updateTimerCallback?(self.getTime())
    }

}

var timerModel = TimerModel()
