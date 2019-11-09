//
//  ViewController.swift
//  Timity
//
//  Created by Bassel Al Araaj on 08/11/2019.
//  Copyright © 2019 Webicom B.V. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    @IBOutlet weak var startPauzeButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timerModel?.continueTimer()
        if(timerModel?.isTimerOn == true) {
            self.startPauzeButton.title = "Pauze"
        } else {
            self.startPauzeButton.title = "Start"
        }
    }
    
    @IBAction func startTimer(_ sender: Any) {
        if(timerModel?.isTimerOn == false) {
            timerModel?.startTimer()
            self.startPauzeButton.title = "Pauze"
        } else {
            timerModel?.pauzeTimer()
            self.startPauzeButton.title = "Start"
        }
    }
    
    @IBAction func stopTimer(_ sender: Any) {
        timerModel?.stopTimer()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

