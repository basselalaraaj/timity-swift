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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.timerLabel.title = String(timerModel!.duration)
        continueTimer()
    }
    
    @IBAction func startTimer(_ sender: Any) {
        if(timerModel?.isTimerOn == false) {
            timerModel?.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: updateTimer(timer:))
            timerModel?.isTimerOn = true
            self.startPauzeButton.title = "Pauze"
        } else {
            pauzeTimer()
            self.startPauzeButton.title = "Start"
        }
    }
    
    @IBAction func stopTimer(_ sender: Any) {
        pauzeTimer()
        timerModel?.duration = 0
        self.timerLabel.title = String(timerModel!.duration)
    }
    
    func pauzeTimer() {
        timerModel?.timer.invalidate()
        timerModel?.isTimerOn = false
    }
    
    func continueTimer() {
        if(timerModel?.isTimerOn == true) {
            timerModel?.timer.invalidate()
            timerModel?.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: updateTimer(timer:))
            self.startPauzeButton.title = "Pauze"
        }
    }
    
    func updateTimer(timer: Timer) {
        timerModel?.duration += 1
        self.timerLabel.title = String(timerModel!.duration)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

