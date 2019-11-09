//
//  TimerModel.swift
//  Timity
//
//  Created by Bassel Al Araaj on 08/11/2019.
//  Copyright © 2019 Webicom B.V. All rights reserved.
//

import Cocoa

class TimerModel {
    var duration = 0
    var timer = Timer()
    var isTimerOn = false
    let appDelegate = NSApp.delegate as! AppDelegate
    
    public init?(){
        
    }
    
    func getTime()-> String {
        let (h, m, s) = secondsToHoursMinutesSeconds(seconds:duration)
        return String(format: "%02d:%02d:%02d", h, m, s)
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
      return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    func startTimer() {
        if(isTimerOn == false) {
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: updateTimer(timer:))
            isTimerOn = true
            appDelegate.statusItem.button?.contentTintColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        } else {
            pauzeTimer()
        }
    }
    
    func stopTimer() {
        pauseTimer()
        duration = 0
        appDelegate.statusItem.button?.title = getTime()
        appDelegate.statusItem.button?.contentTintColor = .none
    }
    
    func pauseTimer() {
        timer.invalidate()
        isTimerOn = false
        appDelegate.statusItem.button?.contentTintColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
    }
    
    func continueTimer() {
        if(isTimerOn == true) {
            timer.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: updateTimer(timer:))
        }
    }
    
    func updateTimer(timer: Timer) {
        timerModel?.duration += 1
        appDelegate.statusItem.button?.title = timerModel!.getTime()
    }

}

var timerModel = TimerModel()
