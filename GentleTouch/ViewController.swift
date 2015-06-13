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

    var touchCount = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        session.activateSession()
    }

    // MARK: Actions

    @IBAction func touch(sender: UIButton) {

        if sessionEnabled {

            let message = ["touchCount": ++touchCount]
            
            session.sendMessage(message, replyHandler: nil, errorHandler: { error in
                print(error)
            })

            print("send touchCount")
        }
    }
}

extension ViewController: WCSessionDelegate {

}