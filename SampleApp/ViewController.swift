//
//  ViewController.swift
//  SampleApp
//
//  Created by Henrique Faria on 01.04.20.
//  Copyright © 2020 MotionTag GmbH. All rights reserved.
//

import UIKit

class ViewController: IndicatorUIViewController {
    var appDelegate: AppDelegate?
    let trackingButton: UIButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        ovserveSetupCompleted()
    }

    private func ovserveSetupCompleted() {
        if let appDelegate = appDelegate {
            if appDelegate.isSetupComplete {
                setupCompleted()
            } else {
                showProgressIndicator()
                NotificationCenter.default.addObserver(self, selector: #selector(setupCompleted),
                                                       name: Notification.Name(appDelegate.setupCompleteNotificationName), object: nil)
            }
        }
    }

    @objc private func setupCompleted() {
          hideProgressIndicator()
          addTrackingButton()
      }

    private func addTrackingButton() {
        let title = getTrackingButtonTitle()
        trackingButton.translatesAutoresizingMaskIntoConstraints = false
        trackingButton.setTitle(title, for: .normal)
        trackingButton.addTarget(self,
                                 action: #selector(handleTrackingButtonTouchUpInside),
                                 for: .touchUpInside)
        view.addSubview(trackingButton)
        NSLayoutConstraint.activate([
            trackingButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            trackingButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }

    private func getTrackingButtonTitle() -> String {
        if let motionTag = appDelegate?.motionTag {
            return motionTag.isTrackingActive ? "Stop Tracking" : "Start Tracking"
        } else {
            return "MotionTag SDK not initialized"
        }
    }

    @objc private func handleTrackingButtonTouchUpInside() {
        if let appDelegate = appDelegate, let motionTag = appDelegate.motionTag {
            if motionTag.isTrackingActive {
                motionTag.stop()

            } else {
                motionTag.start(withToken: appDelegate.jwtToken)
            }
            let title = getTrackingButtonTitle()
            trackingButton.setTitle(title, for: .normal)
        }
    }
}
