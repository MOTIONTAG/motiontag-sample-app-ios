//
//  MainViewController.swift
//  SampleApp
//
//  Created by Henrique Faria on 01.04.20.
//  Copyright © 2020 MotionTag GmbH. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    private lazy var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var trackingSwitch: UISwitch!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        if appDelegate.isSetupFinished {
            didFinishSetup()
        } else {
            appDelegate.setupFinishDelegate = self
        }
    }
    
    @IBAction func trackingSwitchToggled(_ sender: Any) {
        guard let motionTag = appDelegate.motionTag else {
            return
        }
        if trackingSwitch.isOn {
            motionTag.start(withToken: PersistenceLayer.token)
            print("after motionTag.start motionTag.isTrackingActive \(motionTag.isTrackingActive)")
        } else {
            motionTag.stop()
            print("after motionTag.stop motionTag.isTrackingActive \(motionTag.isTrackingActive)")
        }
    }
    
}

extension MainViewController: SetupFinishDelegate {
    func didFinishSetup() {
        activityIndicatorView.stopAnimating()
        trackingSwitch.isOn = appDelegate.motionTag?.isTrackingActive ?? false
    }
}
