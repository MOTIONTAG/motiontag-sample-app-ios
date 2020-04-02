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
    let setupCompleteNotificationName = "SetupCompleteNotification"
    var isSetupComplete = false
    var motionTag: MotionTag?
    var window: UIWindow?
    private var viewController: ViewController?

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
        motionTag = MotionTagCore.sharedInstance(withToken: nil, settings: settings, completion: {
            self.isSetupComplete = true
            NotificationCenter.default.post(name: Notification.Name(self.setupCompleteNotificationName), object: nil)
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