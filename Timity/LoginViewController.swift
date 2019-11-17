//
//  Timity
//
//  Created by Bassel Al Araaj on 08/11/2019.
//  Copyright © 2019 Webicom B.V. All rights reserved.
//

import Cocoa

class LoginViewController: NSViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signup(_ sender: Any) {
        let signUpViewController = storyboard?.instantiateController(withIdentifier: "SignUpViewController") as? SignUpViewController
        NSApp.keyWindow?.contentViewController = signUpViewController
        NSApp.keyWindow?.makeKeyAndOrderFront(signUpViewController)
    }
    
    @IBAction func login(_ sender: Any) {
        let homeViewController = storyboard?.instantiateController(withIdentifier: "HomeViewController") as? HomeViewController
        NSApp.keyWindow?.contentViewController = homeViewController
        NSApp.keyWindow?.makeKeyAndOrderFront(homeViewController)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}
