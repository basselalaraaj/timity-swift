//
//  ViewController.swift
//  Timity
//
//  Created by Bassel Al Araaj on 08/11/2019.
//  Copyright © 2019 Webicom B.V. All rights reserved.
//

import Cocoa

struct Task {
    var id: String
    var project: String
    var type: String
    var description: String
    var duration: Int
    var color: String
}

protocol AddTaskDelegate {
    func addTask(task: Task)
}

var list: [Task?] = []
var userId = 1
let apiUrl = URL(string: "https://api.timity.nl/")!

class HomeViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {
    @IBOutlet weak var taskTable: NSTableView!
    @IBOutlet weak var addTaskButton: NSButton!
    let addTaskPopoverView = NSPopover()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let query = #"{ "query": "{ tasks(userId:\#(userId)){ uuid description duration taskType { title } project {title color}}}" }"#
        var request = URLRequest(url: apiUrl)
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
                    list = []
                    for case let result in deserializedTasks! {
                        let item = result as! [String: Any]
                        let project = item["project"]! as! [String: Any]
                        let taskType = item["taskType"]! as! [String: Any]
                        
                        list.append(Task(id: item["uuid"]! as! String, project: project["title"]! as! String, type: taskType["title"]! as! String, description: item["description"]! as! String, duration: item["duration"]! as! Int, color: project["color"]! as! String))
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
            cell.taskProject.stringValue = list[row]!.project
            cell.taskType.stringValue = list[row]!.type
            cell.taskDescription.stringValue = list[row]!.description
            cell.taskColor.fillColor = hexColor(hexColor: list[row]!.color)
            cell.taskDuration.stringValue = (timerModel?.getTime(time:list[row]!.duration))!
            cell.taskBgColor.fillColor = .clear
            cell.startStopButton.image = NSImage(named: "NSTouchBarPlayTemplate")
            cell.id = row
            
            if(timerModel?.isTimerOn == true && timerModel?.timerId == list[row]!.id) {
                timerModel?.updateTimerCallback(callBack: cell.updateTimeLabel)
                cell.taskBgColor.fillColor = hexColor(hexColor: list[row]!.color, alpha: 0.5)
                cell.taskDuration.stringValue = (timerModel?.getTime())!
                cell.startStopButton.image = NSImage(named: "NSTouchBarRecordStopTemplate")
            }
            
            print(cell.taskDescription.stringValue, cell.taskBgColor.fillColor)
        }
        
        return cell
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

extension HomeViewController: AddTaskDelegate{
    func addTask(task: Task) {
        let query = #"{"query": "mutation{createTask(description:\"\#(task.description)\", duration:\"\#(task.duration)\", userId: \#(userId), projectId: \#(task.project), taskTypeId:\#(task.type)){task{ uuid }}}"}"#
        var request = URLRequest(url: apiUrl)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        request.httpBody = query.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                self.loadView()
                self.addTaskPopoverView.close()
            }
        }
        task.resume()
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
