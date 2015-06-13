//
//  InterfaceController.swift
//  GentleTouch WatchKit Extension
//
//  Created by NIX on 15/6/13.
//  Copyright © 2015年 nixWork. All rights reserved.
//

import WatchKit
import WatchConnectivity

class InterfaceController: WKInterfaceController {

    @IBOutlet var touchCountLabel: WKInterfaceLabel!

    lazy var session: WCSession = {
        let session = WCSession.defaultSession()
        session.delegate = self
        return session
        }()

    var sessionEnabled: Bool {
        return session.reachable
    }

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.

        session.activateSession()
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}

extension InterfaceController: WCSessionDelegate {
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject]) {

        print("receive message: \(message)")

        if let
            touchCountMessage = message as? [String: Int],
            touchCount = touchCountMessage["touchCount"] {
                touchCountLabel.setText("\(touchCount)")

                if let type = WKHapticType(rawValue: touchCount % 9) {
                    WKInterfaceDevice.currentDevice().playHaptic(type)
                }
        }
    }
}