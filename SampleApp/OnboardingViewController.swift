//
//  OnboardingViewController.swift
//  SampleApp
//
//  Created by Kian on 2020-10-19.
//  Copyright © 2020 Henrique Faria. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController {

    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var activityButton: UIButton!
    @IBOutlet weak var endOnboardingButton: UIButton!

    
    private lazy var permissions: Permissions = {
        let manager = Permissions()
        manager.locationDelegate = self
        manager.activityDelegate = self
        return manager
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Onboarding"
        view.backgroundColor = .white
    }
    
    @IBAction func locationAuthTapped(_ sender: Any) {
        locationButton.isEnabled = false
        permissions.obtainLocationPermission()
    }

    @IBAction func activityAuthTapped(_ sender: Any) {
        activityButton.isEnabled = false
        permissions.obtainMotionActivityPermission()
    }

    @IBAction func endOnboardingTapped(_ sender: Any) {
        
    }
}

extension OnboardingViewController: LocationAuthorizationDelegate {
    func didObtainRequiredLocationAuthorization(result: Bool) {
        locationButton.backgroundColor = result ? .green : .red
    }
}

extension OnboardingViewController: ActivityAuthorizationDelegate {
    func didObtainRequiredActivityAuthorization(result: Bool) {
        activityButton.backgroundColor = result ? .green : .red
    }
}
