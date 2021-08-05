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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        LibraryLayer.shared.delegate = self
        trackingSwitch.isOn = LibraryLayer.shared.trackingStatus
    }

    @IBAction func trackingSwitchToggled(_ sender: Any) {
        if trackingSwitch.isOn {
            LibraryLayer.shared.start()
        } else {
            LibraryLayer.shared.stop()
        }
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        LibraryLayer.shared.stop()
        LibraryLayer.shared.clearUserData {
            DispatchQueue.main.async {
                PersistenceLayer.isOnboardingOver = false
                (UIApplication.shared.delegate as! AppDelegate).setupView()
            }
        }
    }
}

extension MainViewController: LibraryLayerDelegate {

    func didChangeTrackingStatus(isTracking: Bool) {
        trackingSwitch.isOn = isTracking
    }
}

extension MainViewController {
    static var viewController: MainViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
    }
}
