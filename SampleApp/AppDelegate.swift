//
//  AppDelegate.swift
//  SampleApp
//
//  Created by Henrique Faria on 01.04.20.
//  Copyright © 2020 MotionTag GmbH. All rights reserved.
//

import MotionTagSDK
import UIKit

protocol SetupFinishDelegate: class {
    func didFinishSetup()
}

struct Constants {
    static let MT_USER_TOKEN_KEY = "MT_USER_TOKEN_KEY"
    static let MT_ONBOARDING_OVER_KEY = "MT_ONBOARDING_OVER_KEY"
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var isSetupFinished = false
    var motionTag: MotionTag?
    lazy var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
    weak var setupFinishDelegate: SetupFinishDelegate?

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        initMotionTagSDK()
        initMainWindow()
        return true
    }

    private func initMainWindow() {
        if UserDefaults.standard.bool(forKey: Constants.MT_ONBOARDING_OVER_KEY) {
            let viewController = MainViewController()
            window?.rootViewController = viewController
        } else {
            let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "OnboardingViewController") as! OnboardingViewController
            viewController.delegate = self
            window?.rootViewController = viewController
        }
        window?.makeKeyAndVisible()
    }

    private func initMotionTagSDK() {
        let settings: [String: AnyObject] = [kMTDataTransferMode: DataTransferMode.wifiAnd3G.rawValue as AnyObject,
                                             kMTBatterySavingsMode: true as AnyObject]
        let token = UserDefaults.standard.string(forKey: Constants.MT_USER_TOKEN_KEY)
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
        UserDefaults.standard.set(true, forKey: Constants.MT_ONBOARDING_OVER_KEY)
        initMainWindow()
    }
}
