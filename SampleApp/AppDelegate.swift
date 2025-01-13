//
//  AppDelegate.swift
//  SampleApp
//
//  Created by Henrique Faria on 01.04.20.
//  Copyright © 2020 MotionTag GmbH. All rights reserved.
//

import UIKit
import MotionTagSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    lazy var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
    private lazy var mainViewController: MainViewController = MainViewController.viewController
    private lazy var motionTag = MotionTagCore.sharedInstance

    func application(_: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // The SDK should be one of the first things initialized in the "didFinishLaunchingWithOptions" delegate
        motionTag.initialize(using: self, launchOption: launchOptions)
        setupView()
        return true
    }

    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        // The SDK must also be called in the "handleEventsForBackgroundURLSession" delegate
        motionTag.processBackgroundSessionEvents(with: identifier, completionHandler: completionHandler)
    }

    func setupView() {
        if PersistenceLayer.isOnboardingOver {
            window?.rootViewController = mainViewController
        } else {
            let onboardingViewController = OnboardingViewController.viewController
            onboardingViewController.delegate = self
            window?.rootViewController = onboardingViewController
        }
        window?.makeKeyAndVisible()
    }

    private func postDidChangeTrackingStatus(isTracking: Bool) {
        let isTrackingInfo: [String: Bool] = ["isTracking": isTracking]
        NotificationCenter.default.post(name: .didChangeTrackingStatusNotification, object: nil, userInfo: isTrackingInfo)
    }
}

extension AppDelegate: MotionTagDelegate {

    func trackingStatusChanged(_ isTracking: Bool) {
        print("MotionTag SDK trackingStatusChanged: \(isTracking)")
        mainViewController.updateTrackingSwitch(isTracking: isTracking)
    }

    func locationAuthorizationStatusDidChange(_ status: CLAuthorizationStatus, precise: Bool) {
        print("MotionTag SDK CLAuthorizationStatus: \(status.rawValue) precise: \(precise)")
    }

    func motionActivityAuthorized(_ authorized: Bool) {
        print("MotionTag SDK motionActivityAuthorized: \(authorized)")
    }

    func didTrackLocation(_ location: CLLocation) {
        print("MotionTag SDK didTrackLocation - CLLocation: \(location)")
    }

    func dataUploadWithTracked(from startDate: Date, to endDate: Date, didCompleteWithError error: Error?) {
        let errorText = error == nil ? "successfully completed" : error.debugDescription
        print("MotionTag SDK dataUploadWithTracked - startDate: \(startDate), endDate: \(endDate)", errorText)
    }
}

extension AppDelegate: OnboardingCompleteDelegate {
    func onboardingDidEnd(with userToken: String) {
        motionTag.userToken = userToken
        setupView()
    }
}

extension Notification.Name {
    static let didChangeTrackingStatusNotification = Notification.Name(rawValue: "didChangeTrackingStatus")
}
