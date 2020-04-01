//
//  AppDelegate.swift
//  SampleApp
//
//  Created by Henrique Faria on 01.04.20.
//  Copyright © 2020 MotionTag GmbH. All rights reserved.
//

import MotionTagSDK
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    let jwtToken = "Your JWT token"
    let setupCompleteNotificationName = "SetupCompleteNotification"
    var isSetupComplete = false
    var window: UIWindow?
    var motionTag: MotionTag?
    var viewController: ViewController?

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        initMainWindow()
        initMotionTagSDK()
        return true
    }

    private func initMainWindow() {
        window = UIWindow(frame: UIScreen.main.bounds)
        viewController = ViewController()
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }

    private func initMotionTagSDK() {
        let settings: [String: AnyObject] = [kMTDataTransferMode: DataTransferMode.wifiAnd3G.rawValue as AnyObject,
                                             kMTBatterySavingsMode: true as AnyObject]
        motionTag = MotionTagCore.sharedInstance(withToken: jwtToken, settings: settings, completion: {
            self.isSetupComplete = true
            NotificationCenter.default.post(name: Notification.Name(self.setupCompleteNotificationName), object: nil)
        })
        motionTag?.delegate = self
    }
}

// MARK: MotionTagDelegate

extension AppDelegate: MotionTagDelegate {
    func locationManager(_: CLLocationManager, didChange _: CLAuthorizationStatus) {
        NSLog("MotionTag SDK locationManager callback.")
    }

    func didTrackLocation(_: CLLocation) {
        NSLog("MotionTag SDK didTrackLocation callback.")
    }

    func didTransmitData(_: Date, lastEventTimestamp _: Date) {
        NSLog("MotionTag SDK didTransmitData callback.")
    }
}
