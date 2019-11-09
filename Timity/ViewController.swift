//
//  ViewController.swift
//  Timity
//
//  Created by Bassel Al Araaj on 08/11/2019.
//  Copyright © 2019 Webicom B.V. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {
    @IBOutlet weak var taskTable: NSTableView!
    
    let list = ["Taak 1", "Taak 2", "Taak 3", "Taak 4", "Taak 5"]
//    var startName: String = "Start"
//    var pauseName: String = "Pause"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timerModel?.continueTimer()
//        if(timerModel?.isTimerOn == true) {
//            self.startPauseButton?.title = pauseName
//        } else {
//            self.startPauseButton?.title = startName
//        }
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        debugPrint(tableColumn!.identifier.rawValue)
        if tableColumn!.identifier.rawValue == "task"{
            return list[row]
        }
        if tableColumn!.identifier.rawValue == "action"{
            return "Start"
        }
        return ""
    }
    
    
    @objc func startTimer() {
        if(timerModel?.isTimerOn == false) {
            timerModel?.startTimer()
//            self.startPauseButton?.title = pauseName
        } else {
            timerModel?.pauseTimer()
//            self.startPauseButton?.title = startName
        }
    }

    @objc func stopTimer() {
        timerModel?.stopTimer()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

