//
//  MainViewController.swift
//  SampleApp
//
//  Created by Henrique Faria on 01.04.20.
//  Copyright © 2020 MotionTag GmbH. All rights reserved.
//

import UIKit

class MainViewController: IndicatorViewController {

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

    @IBAction func trackingSwitchToggled(_ sender: Any) {
        if let motionTag = appDelegate?.motionTag {
            if trackingSwitch.isOn {
                motionTag.start(withToken: PersistenceLayer.token)
                print("after motionTag.start motionTag.isTrackingActive \(motionTag.isTrackingActive)")
            } else {
                motionTag.stop()
                print("after motionTag.stop motionTag.isTrackingActive \(motionTag.isTrackingActive)")
            }
        }
    }
}

extension MainViewController: SetupFinishDelegate {
    func didFinishSetup() {
        hideProgressIndicator()
        trackingSwitch.isOn = appDelegate?.motionTag?.isTrackingActive ?? false
    }
}
