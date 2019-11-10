//
//  ViewController.swift
//  Timity
//
//  Created by Bassel Al Araaj on 08/11/2019.
//  Copyright © 2019 Webicom B.V. All rights reserved.
//

import Cocoa

class TaskTableViewCell: NSTableCellView {
    var taskId: Int? = nil
    @IBOutlet weak var taskTitle: NSTextField!
    @IBOutlet weak var startPauseButton: NSButton!
    
    @IBAction func stopTimer(_ sender: Any) {
        taskTitle.textColor = .none
        startPauseButton.image = NSImage(named: "NSTouchBarPlayTemplate")
        timerModel?.stopTimer()
    }
    @IBAction func toggleTimer(_ sender: Any) {
        if(timerModel?.isTimerOn == false || (timerModel?.isTimerOnPause == true && timerModel?.timerId == taskId)) {
            timerModel?.startTimer(id: taskId)
            taskTitle.textColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            startPauseButton.image = NSImage(named: "NSTouchBarPauseTemplate")
        } else {
            if(timerModel?.timerId == taskId) {
                timerModel?.pauseTimer()
                taskTitle.textColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
                startPauseButton.image = NSImage(named: "NSTouchBarPlayTemplate")
            }
        }
    }
}

class ViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {
    @IBOutlet weak var taskTable: NSTableView!
    
    let list = ["Taak 1", "Taak 2", "Taak 3", "Taak 4", "Taak 5"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timerModel?.continueTimer()
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "TaskCell"), owner: self) as? TaskTableViewCell else { return nil }
        
        if (tableColumn?.identifier)!.rawValue == "task" {
            cell.taskTitle.stringValue = list[row]
            cell.taskId = row
        }
        
        return cell
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

