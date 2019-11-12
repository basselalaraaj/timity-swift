//
//  TaskTableViewCell.swift
//  Timity
//
//  Created by Bassel Al Araaj on 11/11/2019.
//  Copyright © 2019 Webicom B.V. All rights reserved.
//

import Cocoa

class TaskTableViewCell: NSTableCellView {
    var id: Int? = nil
    @IBOutlet weak var taskProject: NSTextField!
    @IBOutlet weak var taskTitle: NSTextField!
    @IBOutlet weak var taskDescription: NSTextField!
    @IBOutlet weak var taskDuration: NSTextField!
    @IBOutlet weak var taskColor: NSBox!
    @IBOutlet weak var taskBgColor: NSBox!
    @IBOutlet weak var startPauseButton: NSButton!
    
    
    func updateTimeLabel(){
        taskDuration.stringValue = (timerModel?.getTime())!
        if list[id!] != nil {
            list[id!]?.duration = timerModel!.duration
        }
    }
    
    @IBAction func stopTimer(_ sender: Any) {
        taskBgColor.fillColor = hexColor(hexColor: "292930")
        startPauseButton.image = NSImage(named: "NSTouchBarPlayTemplate")
        timerModel?.stopTimer()
    }
    @IBAction func toggleTimer(_ sender: Any) {
        if(timerModel?.isTimerOn == false || (timerModel?.isTimerOnPause == true && timerModel?.timerId == id && list[id!] != nil)) {
            timerModel?.startTimer(id: id!, duration: list[id!]!.duration, callBack: updateTimeLabel)
            taskBgColor.fillColor = hexColor(hexColor: "3EB650")
            startPauseButton.image = NSImage(named: "NSTouchBarPauseTemplate")
        } else {
            if(timerModel?.timerId == id) {
                timerModel?.pauseTimer()
                taskBgColor.fillColor = hexColor(hexColor: "FCC133")
                startPauseButton.image = NSImage(named: "NSTouchBarPlayTemplate")
            }
        }
    }
}
