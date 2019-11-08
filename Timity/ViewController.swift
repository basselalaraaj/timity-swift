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
    
    var duration = 0
    var timer = Timer()
    var isTimerOn = false
    
    @IBAction func startTimer(_ sender: Any) {
        if(self.isTimerOn == false) {
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {[weak self] (_) in
                guard let strongSelf = self else {return}
                strongSelf.duration += 1
                strongSelf.timerLabel.title = String(strongSelf.duration)
            })
            self.isTimerOn = true
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

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

