//
//  ViewController.swift
//  SampleApp
//
//  Created by Henrique Faria on 01.04.20.
//  Copyright © 2020 MotionTag GmbH. All rights reserved.
//

import UIKit

class ViewController: IndicatorUIViewController {
    private var appDelegate: AppDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        showProgressIndicator()
        observeSetupCompleted()
    }

    private func observeSetupCompleted() {
        if let appDelegate = appDelegate {
            if appDelegate.isSetupComplete {
                setupCompleted()
            } else {
                NotificationCenter.default.addObserver(self, selector: #selector(setupCompleted),
                                                       name: Notification.Name(appDelegate.setupCompleteNotificationName), object: nil)
            }
        }
    }

    @objc private func setupCompleted() {
        hideProgressIndicator()
        addTrackingSwtich()
    }

    private func addTrackingSwtich() {
        let trackingSwitch = UISwitch()
        trackingSwitch.isEnabled = true
        trackingSwitch.isOn = appDelegate?.motionTag?.isTrackingActive ?? false
        trackingSwitch.translatesAutoresizingMaskIntoConstraints = false

        trackingSwitch.addTarget(self, action: #selector(switchValueDidChange(sender:)), for: .valueChanged)
        view.addSubview(trackingSwitch)

        NSLayoutConstraint.activate([
            trackingSwitch.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            trackingSwitch.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }

    @objc private func switchValueDidChange(sender: UISwitch!) {
        if let appDelegate = appDelegate, let motionTag = appDelegate.motionTag {
            if sender.isOn {
                motionTag.start(withToken: appDelegate.jwtToken)
            } else {
                motionTag.stop()
            }
        }
    }
}
