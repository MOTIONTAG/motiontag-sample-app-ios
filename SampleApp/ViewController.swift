//
//  ViewController.swift
//  SampleApp
//
//  Created by Henrique Faria on 01.04.20.
//  Copyright © 2020 MotionTag GmbH. All rights reserved.
//

import UIKit

class ViewController: IndicatorViewController, SetupFinishDelegate {

    // Must be replaced with a valid token: https://api.motion-tag.de/developer/
    private let userJwtToken = "User's JWT token"
    private var appDelegate: AppDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        showProgressIndicator()
        setSetupFinishDelegate()
    }

    private func setSetupFinishDelegate() {
        if let appDelegate = appDelegate {
            if appDelegate.isSetupFinished {
                didFinishSetup()
            } else {
                appDelegate.setupFinishDelegate = self
            }
        }
    }

    func didFinishSetup() {
        hideProgressIndicator()
        initTrackingControls()
    }

    private func initTrackingControls() {
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
        trackingLabel.textColor = .black
        trackingLabel.text = "Tracking active"
        trackingLabel.translatesAutoresizingMaskIntoConstraints = false
        return trackingLabel
    }

    private func buildTrackingSwitch() -> UISwitch {
        let trackingSwitch = UISwitch()
        trackingSwitch.isOn = appDelegate?.motionTag?.isTrackingActive ?? false
        trackingSwitch.addTarget(self, action: #selector(switchValueDidChange(sender:)), for: .valueChanged)
        trackingSwitch.translatesAutoresizingMaskIntoConstraints = false
        return trackingSwitch
    }

    @objc private func switchValueDidChange(sender: UISwitch!) {
        if let motionTag = appDelegate?.motionTag {
            if sender.isOn {
                UserDefaults.standard.set(userJwtToken, forKey: Constants.MT_USER_TOKEN_KEY)
                motionTag.start(withToken: userJwtToken)
                print("after motionTag.start motionTag.isTrackingActive \(motionTag.isTrackingActive)")
            } else {
                motionTag.stop()
                print("after motionTag.stop motionTag.isTrackingActive \(motionTag.isTrackingActive)")
            }
        }
    }
}
