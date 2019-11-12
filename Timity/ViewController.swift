//
//  ViewController.swift
//  Timity
//
//  Created by Bassel Al Araaj on 08/11/2019.
//  Copyright © 2019 Webicom B.V. All rights reserved.
//

import Cocoa

struct Task {
    var client: String
    var title: String
    var project: String
    var description: String
    var duration: Int
    var color: String
}

protocol AddTaskDelegate {
    func addTask(task: Task)
}

var list: [Task?] = []

class ViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {
    @IBOutlet weak var taskTable: NSTableView!
    @IBOutlet weak var addTaskButton: NSButton!
    let addTaskPopoverView = NSPopover()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(list.count > 0) {
            return
        }
        
        let query = #"{ "query": "{tasks{client,title,description,project,duration,color}}" }"#
        let url = URL(string: "https://api.timity.nl/")!
        var request = URLRequest(url: url)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        request.httpBody = query.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("error: \(error)")
            } else {
                if let data = data, let _ = String(data: data, encoding: .utf8) {
                    let deserialized = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: [String: [Any]]]
                    let deserializedTasks = deserialized!["data"]?["tasks"]!
                    for case let result in deserializedTasks! {
                        let item = result as! [String: Any]
                        list.append(Task(client: item["client"]! as! String, title: item["title"]! as! String, project: item["project"]! as! String, description: item["description"]! as! String, duration: item["duration"]! as! Int, color: item["color"]! as! String))
                    }
                    DispatchQueue.main.async {
                        self.taskTable.reloadData()
                    }
                }
            }
        }
        task.resume()
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
        
        if (tableColumn?.identifier)!.rawValue == "task" && list[row] != nil {
//            cell.taskClient.stringValue = list[row]["client"]! as! String
            cell.taskProject.stringValue = list[row]!.project
            cell.taskTitle.stringValue = list[row]!.title
            cell.taskDescription.stringValue = list[row]!.description
            cell.taskColor.fillColor = hexColor(hexColor: list[row]!.color)
            cell.taskBgColor.fillColor = hexColor(hexColor: "292930")
            cell.taskDuration.stringValue = (timerModel?.getTime(time:list[row]!.duration))!
            cell.id = row
            
            if(timerModel?.isTimerOn == true && timerModel?.timerId == row) {
                timerModel?.updateTimerCallback(callBack: cell.updateTimeLabel)
                cell.taskBgColor.fillColor = hexColor(hexColor: "3EB650", alpha: 0.2)
                cell.startStopButton.image = NSImage(named: "NSTouchBarRecordStopTemplate")
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
        list.append(task)
        self.taskTable.reloadData()
        self.addTaskPopoverView.close()
    }
}

func hexColor (hexColor: String, alpha: Float = 1) -> NSColor {
    let scannHex = Scanner(string: hexColor)
    var rgbValue: UInt64 = 0
    scannHex.scanLocation = 0
    scannHex.scanHexInt64(&rgbValue)
    let r = (rgbValue & 0xff0000) >> 16
    let g = (rgbValue & 0xff00) >> 8
    let b = rgbValue & 0xff
    return #colorLiteral(red: Float(CGFloat(r) / 0xff), green: Float(CGFloat(g) / 0xff), blue: Float(CGFloat(b) / 0xff), alpha: alpha)
}
