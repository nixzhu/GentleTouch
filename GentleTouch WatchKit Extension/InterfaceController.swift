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

    @IBOutlet var hapticTypeLabel: WKInterfaceLabel!

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

        session.activateSession()
    }

    // MARK: Actions

    @IBAction func requestSomeRandomTouch() {
        if sessionEnabled {
            session.sendMessage(["randomTouchTimes": 5], replyHandler: nil, errorHandler: { error in
                print(error)
            })
        }
    }

}

extension WKHapticType {
    var name: String {
        switch self {
        case .Notification:
            return "Notification"
        case .DirectionUp:
            return "DirectionUp"
        case .DirectionDown:
            return "DirectionDown"
        case .Success:
            return "Success"
        case .Failure:
            return "Failure"
        case .Retry:
            return "Retry"
        case .Start:
            return "Start"
        case .Stop:
            return "Stop"
        case .Click:
            return "Click"
        }
    }
}

extension InterfaceController: WCSessionDelegate {

    func session(session: WCSession, didReceiveMessage message: [String : AnyObject]) {

        print("receive message: \(message)")

        if let
            hapticTypeRawValue = message["hapticTypeRawValue"] as? Int,
            type = WKHapticType(rawValue: hapticTypeRawValue) {

                hapticTypeLabel.setText(type.name)

                WKInterfaceDevice.currentDevice().playHaptic(type)
        }
    }
}

