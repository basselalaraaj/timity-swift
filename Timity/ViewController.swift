//
//  ViewController.swift
//  Timity
//
//  Created by Bassel Al Araaj on 08/11/2019.
//  Copyright © 2019 Webicom B.V. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    @IBOutlet weak var timerLabel: NSTextFieldCell!
    @IBOutlet weak var startPauzeButton: NSButton!
    
    var duration = 0
    var timer = Timer()
    var isTimerOn = false
    
    @IBAction func startTimer(_ sender: Any) {
        if(self.isTimerOn == false) {
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: updateTimer(timer:))
            self.isTimerOn = true
            self.startPauzeButton.title = "Pauze"
        } else {
            self.timer.invalidate()
            self.isTimerOn = false
            self.startPauzeButton.title = "Start"
        }
    }
    
    @IBAction func stopTimer(_ sender: Any) {
        self.timer.invalidate()
        self.duration = 0
        self.isTimerOn = false
        self.timerLabel.title = String(self.duration)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.timerLabel.title = String(self.duration)
    }
    
    func updateTimer(timer: Timer) {
        self.duration += 1
        self.timerLabel.title = String(self.duration)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

