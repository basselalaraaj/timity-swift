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
