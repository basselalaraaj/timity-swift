//
//  ViewController.swift
//  Timity
//
//  Created by Bassel Al Araaj on 08/11/2019.
//  Copyright © 2019 Webicom B.V. All rights reserved.
//

import Cocoa

class TaskTableViewCell: NSTableCellView {
    var id: Int? = nil
    var duration: Int? = nil
    @IBOutlet weak var taskProject: NSTextField!
    @IBOutlet weak var taskTitle: NSTextField!
    @IBOutlet weak var taskDescription: NSTextField!
    @IBOutlet weak var taskDuration: NSTextField!
    @IBOutlet weak var startPauseButton: NSButton!
    
    func updateTimeLabel(label: String){
        taskDuration.stringValue = label
    }
    
    @IBAction func stopTimer(_ sender: Any) {
        taskTitle.textColor = .none
        startPauseButton.image = NSImage(named: "NSTouchBarPlayTemplate")
        timerModel?.stopTimer()
    }
    @IBAction func toggleTimer(_ sender: Any) {
        if(timerModel?.isTimerOn == false || (timerModel?.isTimerOnPause == true && timerModel?.timerId == id)) {
            timerModel?.startTimer(id: id!, duration: duration!, callBack: updateTimeLabel)
            taskTitle.textColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            startPauseButton.image = NSImage(named: "NSTouchBarPauseTemplate")
        } else {
            if(timerModel?.timerId == id) {
                timerModel?.pauseTimer()
                taskTitle.textColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
                startPauseButton.image = NSImage(named: "NSTouchBarPlayTemplate")
            }
        }
    }
}

class ViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {
    @IBOutlet weak var taskTable: NSTableView!
    
    let list = [[
        "title" : "Task 1",
        "description" : "A very good task",
        "project" : "Project 1",
        "duration": 100,
    ],[
        "title" : "Task 2",
        "description" : "A very good task",
        "project" : "Project 2",
        "duration": 1000,
    ],[
        "title" : "Task 3",
        "description" : "A very good task",
        "project" : "Project 3",
        "duration": 4000,
    ],[
        "title" : "Task 4",
        "description" : "A very good task",
        "project" : "Project 4",
        "duration": 8000,
    ]]
    
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
            cell.taskProject.stringValue = list[row]["project"]! as! String
            cell.taskTitle.stringValue = list[row]["title"]! as! String
            cell.taskDescription.stringValue = list[row]["description"]! as! String
            cell.taskDuration.stringValue = (timerModel?.getTime(time:list[row]["duration"]! as! Int))!
            cell.id = row
            cell.duration = list[row]["duration"]! as? Int
        }
        
        return cell
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

