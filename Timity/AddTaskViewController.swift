//
//  AddTaskViewController.swift
//  Timity
//
//  Created by Bassel Al Araaj on 11/11/2019.
//  Copyright © 2019 Webicom B.V. All rights reserved.
//

import Cocoa

class AddTaskViewController: NSViewController {
    var delegate: AddTaskDelegate?
    
    @IBOutlet weak var taskProject: NSPopUpButton!
    @IBOutlet weak var taskType: NSPopUpButton!
    @IBOutlet weak var taskDescription: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let query = #"{ "query": "{ projects(userId:\#(userId)){ uuid title } taskTypes(userId:\#(userId)){ uuid title }}"}"#
        var request = URLRequest(url: apiUrl)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        request.httpBody = query.data(using: String.Encoding.utf8)
        
        let dropdown = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("error: \(error)")
            } else {
                if let data = data, let _ = String(data: data, encoding: .utf8) {
                    let deserialized = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: [String: [Any]]]
                    let deserializedProjectData = deserialized!["data"]?["projects"]!
                    let deserializedTypesData = deserialized!["data"]?["taskTypes"]!

                    DispatchQueue.main.async {
                        self.taskProject.menu?.removeAllItems()
                        for case let result in deserializedProjectData! {
                            let item = result as! [String: Any]
                            let menuItem = NSMenuItem(title: item["title"]! as! String, action: #selector(self.handleDropdownSelect), keyEquivalent: "")
                            menuItem.tag = Int((item["uuid"]! as! NSString).doubleValue)
                            self.taskProject.menu?.addItem(menuItem)
                        }

                        self.taskType.menu?.removeAllItems()
                        for case let result in deserializedTypesData! {
                            let item = result as! [String: Any]
                            let menuItem = NSMenuItem(title: item["title"]! as! String, action: #selector(self.handleDropdownSelect), keyEquivalent: "")
                            menuItem.tag = Int((item["uuid"]! as! NSString).doubleValue)
                            self.taskType.menu?.addItem(menuItem)
                        }
                    }
                }
            }
        }
        dropdown.resume()
    }
    
    @objc func handleDropdownSelect(_ sender: Any){
    }
    
    @IBAction func addNewTask(_ sender: Any) {
        handleDone()
    }
    
    @objc func handleDone(){
        let task = Task(id: "", project: (taskProject!.selectedItem!.tag as NSNumber).stringValue, type: (taskType!.selectedItem!.tag as NSNumber).stringValue, description: taskDescription.stringValue, duration: 0, color: "FF0000")
        delegate?.addTask(task: task)
    }


}
