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
    
    @IBOutlet weak var taskProject: NSTextField!
    @IBOutlet weak var taskDescription: NSTextField!
    
    @IBAction func addNewTask(_ sender: Any) {
        handleDone()
    }
    
    @objc func handleDone(){
        let task = Task(project: taskProject.stringValue,description: taskDescription.stringValue, duration: 0, color: "FF0000")
        delegate?.addTask(task: task)
    }


}
