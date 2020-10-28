//
//  AppDelegate.swift
//  SampleApp
//
//  Created by Henrique Faria on 01.04.20.
//  Copyright © 2020 MotionTag GmbH. All rights reserved.
//

import UIKit
import MotionTagSDK

protocol SetupFinishDelegate: class {
    func didFinishSetup()
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var isSetupFinished = false
    var motionTag: MotionTag?
    lazy var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
    weak var setupFinishDelegate: SetupFinishDelegate?

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        initMotionTagSDK()
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

    private func initMotionTagSDK() {
        let settings: [String: AnyObject] = [kMTDataTransferMode: DataTransferMode.wifiAnd3G.rawValue as AnyObject,
                                             kMTBatterySavingsMode: true as AnyObject]
        let token = PersistenceLayer.token
        motionTag = MotionTagCore.sharedInstance(withToken: token, settings: settings, completion: {
            // The SDK initialization can take some time to finish (e.g.: database migration) therefore it is recommended to use a delegate here to notify when it is done
            self.isSetupFinished = true
            self.setupFinishDelegate?.didFinishSetup()
        })
        motionTag?.delegate = self
    }
}

// MARK: MotionTagDelegate

extension AppDelegate: MotionTagDelegate {
    func locationManager(_: CLLocationManager, didChange: CLAuthorizationStatus) {
        NSLog("MotionTag SDK locationManager - CLAuthorizationStatus: \(didChange.rawValue)")
    }

    func didTrackLocation(_ location: CLLocation) {
        NSLog("MotionTag SDK didTrackLocation - CLLocation: \(location)")
    }

    func didTransmitData(timestamp: Date, lastEventTimestamp: Date) {
        NSLog("MotionTag SDK didTransmitData - timestamp: \(timestamp), lastEventTimestamp: \(lastEventTimestamp)")
    }
}

extension AppDelegate: OnboardingCompleteDelegage {
    func onboardingDidEnd() {
        setupView()
    }
}
