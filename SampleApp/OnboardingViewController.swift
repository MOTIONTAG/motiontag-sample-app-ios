//
//  OnboardingViewController.swift
//  SampleApp
//
//  Created by Kian Mehravaran on 2020-10-19.
//  Copyright © 2020 MotionTag GmbH. All rights reserved.
//

import UIKit

protocol OnboardingCompleteDelegate: class {
    func onboardingDidEnd()
}

class OnboardingViewController: UIViewController {

    // Must be replaced with a valid token: https://api.motion-tag.de/developer/
    private let userJwtToken = "User's JWT token"

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var activityButton: UIButton!
    @IBOutlet weak var endOnboardingButton: UIButton!

    weak var delegate: OnboardingCompleteDelegate?
    private var permissionsSet: Set<AuthorizationType> = []

    private lazy var permissions: PermissionsManager = {
        let manager = PermissionsManager()
        manager.delegate = self
        return manager
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Onboarding"
        view.backgroundColor = .white
        endOnboardingButton.isEnabled = false
        endOnboardingButton.alpha = 0.5
    }

    @IBAction func loginTapped(_ sender: Any) {
        loginButton.isEnabled = false
        didObtainRequiredAuthorization(result: true, type: .login)
        PersistenceLayer.token = userJwtToken
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
        PersistenceLayer.isOnboardingOver = true
        delegate?.onboardingDidEnd()
    }
}

extension OnboardingViewController: AuthorizationDelegate {
    func didObtainRequiredAuthorization(result: Bool, type: AuthorizationType) {
        switch type {
        case .location:
            locationButton.backgroundColor = result ? .green : .red
        case .activity:
            activityButton.backgroundColor = result ? .green : .red
        case .login:
            loginButton.backgroundColor = result ? .green : .red
        }
        if result {
            permissionsSet.insert(type)
            if permissionsSet.count == AuthorizationType.allCases.count {
                endOnboardingButton.alpha = 1.0
                endOnboardingButton.isEnabled = true
            }
        }
    }
}

extension OnboardingViewController {
    static var viewController: OnboardingViewController {
        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "OnboardingViewController") as! OnboardingViewController
    }
}
