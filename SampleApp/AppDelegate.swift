//
//  AppDelegate.swift
//  SampleApp
//
//  Created by Henrique Faria on 01.04.20.
//  Copyright © 2020 MotionTag GmbH. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
    lazy var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
    private var libraryLayer: LibraryLayer!

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        _ = LibraryLayer.shared
        setupView()
        return true
    }

    private func setupView() {
        if PersistenceLayer.isOnboardingOver {
            window?.rootViewController = MainViewController.viewController
        } else {
            let onboardingViewControler = OnboardingViewController.viewController
            onboardingViewControler.delegate = self
            window?.rootViewController = onboardingViewControler
        }
        window?.makeKeyAndVisible()
    }
}

extension AppDelegate: OnboardingCompleteDelegate {
    func onboardingDidEnd() {
        setupView()
    }
}
