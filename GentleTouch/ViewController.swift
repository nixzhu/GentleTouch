//
//  ViewController.swift
//  GentleTouch
//
//  Created by NIX on 15/6/13.
//  Copyright © 2015年 nixWork. All rights reserved.
//

import UIKit
import WatchConnectivity

class ViewController: UIViewController {

    lazy var session: WCSession = {
        let session = WCSession.defaultSession()
        session.delegate = self
        return session
        }()

    var sessionEnabled: Bool {
        return session.paired && session.watchAppInstalled && session.reachable
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        session.activateSession()
    }

    // MARK: Actions

    @IBAction func touch(sender: UIButton) {

        let hapticTypeRawValue: Int

        if let title = sender.titleLabel?.text {
            switch title {
            case "Notification":
                hapticTypeRawValue = 0
            case "DirectionUp":
                hapticTypeRawValue = 1
            case "DirectionDown":
                hapticTypeRawValue = 2
            case "Success":
                hapticTypeRawValue = 3
            case "Failure":
                hapticTypeRawValue = 4
            case "Retry":
                hapticTypeRawValue = 5
            case "Start":
                hapticTypeRawValue = 6
            case "Stop":
                hapticTypeRawValue = 7
            case "Click":
                hapticTypeRawValue = 8
            default:
                hapticTypeRawValue = 8
            }

        } else {
            hapticTypeRawValue = 8
        }

        sendHapticMessageWithRawValue(hapticTypeRawValue)
    }

    func sendHapticMessageWithRawValue(hapticTypeRawValue: Int) {

        if sessionEnabled {

            let message: [String: AnyObject] = [
                "hapticTypeRawValue": hapticTypeRawValue,
            ]

            session.sendMessage(message, replyHandler: nil, errorHandler: { error in
                print(error)
            })

            print("send message: \(message)")
        }
    }
}

extension ViewController: WCSessionDelegate {

    func delay(time: NSTimeInterval, work: dispatch_block_t) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(time * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
            work()
        }
    }

    func session(session: WCSession, didReceiveMessage message: [String : AnyObject]) {

        print("receive message: \(message)")

        if let randomTouchTimes = message["randomTouchTimes"] as? Int {

            for i in 0..<randomTouchTimes {

                let seconds = NSTimeInterval(i)

                delay(seconds) {
                    let hapticTypeRawValue = Int(arc4random() % 9)

                    self.sendHapticMessageWithRawValue(hapticTypeRawValue)
                }
            }
        }
    }
}

