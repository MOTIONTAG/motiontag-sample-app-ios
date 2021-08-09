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
        // The SDK should be one of the first things initialized in the "didFinishLaunchingWithOptions" delegate
        if (PersistenceLayer.isOnboardingOver) {
            libraryLayer = LibraryLayer.shared
        }
        setupView()
        return true
    }

    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        // The SDK must also be called in the "handleEventsForBackgroundURLSession" delegate
        libraryLayer.handleEvents(forBackgroundURLSession: identifier, completionHandler: completionHandler)
    }

    func setupView() {
        if PersistenceLayer.isOnboardingOver {
            window?.rootViewController = MainViewController.viewController
        } else {
            let onboardingViewController = OnboardingViewController.viewController
            onboardingViewController.delegate = self
            window?.rootViewController = onboardingViewController
        }
        window?.makeKeyAndVisible()
    }
}

extension AppDelegate: OnboardingCompleteDelegate {
    func onboardingDidEnd(with userToken: String) {
        libraryLayer = LibraryLayer.shared
        libraryLayer.userToken = userToken
        setupView()
    }
}
