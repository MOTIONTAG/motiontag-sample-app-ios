//
//  ViewController.swift
//  SampleApp
//
//  Created by Henrique Faria on 01.04.20.
//  Copyright © 2020 Henrique Faria. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var toggleTrackingButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        addToggleTrackingButton()
        setToggleTrackingButtonTarget()
        setToggleTrackingButtonConstraints()
    }

    func addToggleTrackingButton() {
        toggleTrackingButton = UIButton(type: .system)
        toggleTrackingButton.setTitle("Start Tracking", for: .normal)
        toggleTrackingButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(toggleTrackingButton)
    }

    func setToggleTrackingButtonTarget() {
        toggleTrackingButton.addTarget(self,
                                       action: #selector(handleToggleTrackingButtonTouchUpInside),
                                       for: .touchUpInside)
    }

    func setToggleTrackingButtonConstraints() {
        NSLayoutConstraint.activate([
            toggleTrackingButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            toggleTrackingButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }

    @objc func handleToggleTrackingButtonTouchUpInside() {
        print("ToggleTracking button has been tapped")
    }
}
