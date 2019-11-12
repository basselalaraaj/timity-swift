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
    @IBOutlet weak var startStopButton: NSButton!
    
    
    func updateTimeLabel(){
        taskDuration.stringValue = (timerModel?.getTime())!
        if list[id!] != nil {
            list[id!]?.duration = timerModel!.duration
        }
    }

    @IBAction func toggleTimer(_ sender: Any) {
        if(timerModel?.isTimerOn == false && list[id!] != nil) {
            timerModel?.startTimer(id: id!, duration: list[id!]!.duration, callBack: updateTimeLabel)
            taskBgColor.fillColor = hexColor(hexColor: "3EB650", alpha: 0.2)
            startStopButton.image = NSImage(named: "NSTouchBarRecordStopTemplate")
        } else {
            if(timerModel?.timerId == id) {
                timerModel?.stopTimer()
                taskBgColor.fillColor = hexColor(hexColor: "292930")
                startStopButton.image = NSImage(named: "NSTouchBarPlayTemplate")
            }
        }
    }
}
