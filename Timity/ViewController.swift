//
//  ViewController.swift
//  Timity
//
//  Created by Bassel Al Araaj on 08/11/2019.
//  Copyright © 2019 Webicom B.V. All rights reserved.
//

import Cocoa

var list = [[
    "title" : "Task 1",
    "description" : "A nice task",
    "project" : "Project 1",
    "duration": 2300,
],[
    "title" : "Task 2",
    "description" : "Oke task",
    "project" : "Project 2",
    "duration": 1200,
],[
    "title" : "Task 3",
    "description" : "A very good task",
    "project" : "Project 3",
    "duration": 4500,
]]

class TaskTableViewCell: NSTableCellView {
    var id: Int? = nil
    @IBOutlet weak var taskProject: NSTextField!
    @IBOutlet weak var taskTitle: NSTextField!
    @IBOutlet weak var taskDescription: NSTextField!
    @IBOutlet weak var taskDuration: NSTextField!
    @IBOutlet weak var startPauseButton: NSButton!
    
    func updateTimeLabel(){
        taskDuration.stringValue = (timerModel?.getTime())!
        list[id!]["duration"] = timerModel?.duration
    }
    
    @IBAction func stopTimer(_ sender: Any) {
        taskTitle.textColor = .none
        startPauseButton.image = NSImage(named: "NSTouchBarPlayTemplate")
        timerModel?.stopTimer()
    }
    @IBAction func toggleTimer(_ sender: Any) {
        if(timerModel?.isTimerOn == false || (timerModel?.isTimerOnPause == true && timerModel?.timerId == id)) {
            timerModel?.startTimer(id: id!, duration: list[id!]["duration"] as! Int, callBack: updateTimeLabel)
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

struct Task {
    var title: String
    var project: String
    var description: String
}

protocol AddTaskDelegate {
    func addTask(task: Task)
}

class AddTaskViewController: NSViewController {
    var delegate: AddTaskDelegate?
    
    @IBOutlet weak var taskProject: NSTextField!
    @IBOutlet weak var taskTitle: NSTextField!
    @IBOutlet weak var taskDescription: NSTextField!
    
    @IBAction func addNewTask(_ sender: Any) {
        handleDone()
    }
    
    @objc func handleDone(){
        let task = Task(title: taskTitle.stringValue, project: taskProject.stringValue,description: taskDescription.stringValue)
        delegate?.addTask(task: task)
    }


}

class ViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {
    @IBOutlet weak var taskTable: NSTableView!
    @IBOutlet weak var addTaskButton: NSButton!
    let addTaskPopoverView = NSPopover()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func handleAddTask(_ sender: Any) {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateController(withIdentifier: "AddTask") as! AddTaskViewController
        vc.delegate = self
        addTaskPopoverView.contentViewController = vc
        addTaskPopoverView.behavior = .transient
        addTaskPopoverView.show(relativeTo: addTaskButton.bounds, of: addTaskButton, preferredEdge: .minX)
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
            
            if(timerModel?.isTimerOn == true && timerModel?.timerId == row) {
                timerModel?.updateTimerCallback(callBack: cell.updateTimeLabel)
                if(timerModel?.isTimerOnPause == false) {
                    cell.taskTitle.textColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
                    cell.startPauseButton.image = NSImage(named: "NSTouchBarPauseTemplate")
                } else {
                    cell.taskTitle.textColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
                    cell.startPauseButton.image = NSImage(named: "NSTouchBarPlayTemplate")
                }
            }
        }
        
        return cell
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

extension ViewController: AddTaskDelegate{
    func addTask(task: Task) {
        let task = [
            "title" : task.title,
            "description" : task.description,
            "project" : task.project,
            "duration": 0,
            ] as [String : Any]
        list.append(task)
        self.taskTable.reloadData()
        self.addTaskPopoverView.close()
    }
}
