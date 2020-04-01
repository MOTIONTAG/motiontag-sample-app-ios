//
//  ViewController.swift
//  SampleApp
//
//  Created by Henrique Faria on 01.04.20.
//  Copyright © 2020 MotionTag GmbH. All rights reserved.
//

import UIKit

class ViewController: IndicatorUIViewController {
    private let jwtToken = "Your JWT token"
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
        initTrackingSwitch()
    }

    private func initTrackingSwitch() {
        let trackingLabel = buildTrackingLabel()
        let trackingSwitch = buildTrackingSwitch()

        let stackview = UIStackView()
        stackview.axis = .horizontal
        stackview.spacing = 20
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.addArrangedSubview(trackingLabel)
        stackview.addArrangedSubview(trackingSwitch)

        view.addSubview(stackview)
        stackview.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stackview.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }

    private func buildTrackingLabel() -> UILabel {
        let trackingLabel = UILabel()
        trackingLabel.text = "Tracking active"
        trackingLabel.translatesAutoresizingMaskIntoConstraints = false
        return trackingLabel
    }

    private func buildTrackingSwitch() -> UISwitch {
        let trackingSwitch = UISwitch()
        trackingSwitch.isEnabled = true
        trackingSwitch.isOn = appDelegate?.motionTag?.isTrackingActive ?? false
        trackingSwitch.addTarget(self, action: #selector(switchValueDidChange(sender:)), for: .valueChanged)
        trackingSwitch.translatesAutoresizingMaskIntoConstraints = false
        return trackingSwitch
    }

    @objc private func switchValueDidChange(sender: UISwitch!) {
        if  let motionTag = appDelegate?.motionTag {
            if sender.isOn {
                motionTag.start(withToken: jwtToken)
            } else {
                motionTag.stop()
            }
        }
    }
}
