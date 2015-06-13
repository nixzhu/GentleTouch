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

        if sessionEnabled {

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

}

