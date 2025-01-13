//
//  MainViewController.swift
//  SampleApp
//
//  Created by Henrique Faria on 01.04.20.
//  Copyright © 2020 MotionTag GmbH. All rights reserved.
//

import UIKit
import MotionTagSDK

class MainViewController: UIViewController {

    @IBOutlet weak var trackingSwitch: UISwitch!

    private lazy var motionTag = MotionTagCore.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didChangeTrackingStatusReceived(_:)),
                                               name: NSNotification.Name.didChangeTrackingStatusNotification,
                                               object: nil)
        trackingSwitch.isOn = motionTag.isTrackingActive
    }

    @IBAction func trackingSwitchToggled(_ sender: Any) {
        if trackingSwitch.isOn {
            motionTag.start()
        } else {
            motionTag.stop()
        }
    }

    @IBAction func logoutButtonTapped(_ sender: Any) {
        motionTag.stop()
        motionTag.clearData()
        PersistenceLayer.isOnboardingOver = false
        (UIApplication.shared.delegate as! AppDelegate).setupView()
    }

    func updateTrackingSwitch(isTracking: Bool) {
        if trackingSwitch == nil {
            return
        }
        trackingSwitch.isOn = isTracking
    }
}

extension MainViewController {
    static var viewController: MainViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
    }
}

extension MainViewController {

    @objc private func didChangeTrackingStatusReceived(_ notification: Notification) {
        guard let userInfo = notification.userInfo, let isTracking = (userInfo["isTracking"] as? Bool) else {
            return
        }
        DispatchQueue.main.async {
            self.updateTrackingSwitch(isTracking: isTracking)
        }
    }
}
