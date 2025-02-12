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
    
    var timerId: String? = nil
    var duration = 0
    var timerCallback : (() -> Void)?
    
    var isTimerOn = false
    
    
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
    
    func startTimer(id: String, duration: Int, callBack: (() -> Void)?) {
        if(isTimerOn == false){
            timerId = id
            self.duration = duration
            timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true, block: updateTimer(timer:))
            isTimerOn = true
            updateTimerCallback(callBack: callBack)
            appDelegate.statusItem.button?.title = self.getTime()
            appDelegate.statusItem.button?.contentTintColor = hexColor(hexColor: "3EB650")
        }
    }
    
    func stopTimer() {
        if(isTimerOn == true){
            timer.invalidate()
            isTimerOn = false
            duration = 0
            appDelegate.statusItem.button?.title = getTime()
            appDelegate.statusItem.button?.contentTintColor = .none
        }
    }
    
    func updateTimer(timer: Timer) {
        self.duration += 60
        appDelegate.statusItem.button?.title = self.getTime()
        timerCallback?()
    }
    
    func updateTimerCallback(callBack: (() -> Void)?) {
        timerCallback = callBack
    }

}

var timerModel = TimerModel()
