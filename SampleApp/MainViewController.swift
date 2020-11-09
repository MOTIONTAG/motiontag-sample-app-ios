//
//  MainViewController.swift
//  SampleApp
//
//  Created by Henrique Faria on 01.04.20.
//  Copyright © 2020 MotionTag GmbH. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var trackingSwitch: UISwitch!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        trackingSwitch.isEnabled = false
        LibraryLayer.shared.delegate = self
        if LibraryLayer.shared.isSetupFinished {
            didFinishSetup()
        }
    }

    @IBAction func trackingSwitchToggled(_ sender: Any) {
        if trackingSwitch.isOn {
            LibraryLayer.shared.start()
        } else {
            LibraryLayer.shared.stop()
        }
    }
}

extension MainViewController: LibraryLayerDelegate {

    func didChangeTrackingStatus(isTracking: Bool) {
        trackingSwitch.isOn = isTracking
    }

    func didFinishSetup() {
        activityIndicatorView.stopAnimating()
        trackingSwitch.isEnabled = true
    }
}

extension MainViewController {
    static var viewController: MainViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
    }
}
