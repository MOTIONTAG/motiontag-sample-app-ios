//
//  MainViewController.swift
//  SampleApp
//
//  Created by Henrique Faria on 01.04.20.
//  Copyright © 2020 MotionTag GmbH. All rights reserved.
//

import UIKit

class MainViewController: IndicatorViewController {

    // Must be replaced with a valid token: https://api.motion-tag.de/developer/
    private let userJwtToken = "User's JWT token"
    private var appDelegate: AppDelegate?

    @IBOutlet weak var trackingSwitch: UISwitch!

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

    @IBAction func trackingSwitchToggled(_ sender: Any) {
        
    }
}

extension MainViewController: SetupFinishDelegate {
    func didFinishSetup() {
        hideProgressIndicator()
        trackingSwitch.isOn = appDelegate?.motionTag?.isTrackingActive ?? false
    }
}
