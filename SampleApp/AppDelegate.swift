//
//  AppDelegate.swift
//  SampleApp
//
//  Created by Kian Mehravaran on 23.01.26.
//  Copyright © 2026 MotionTag GmbH. All rights reserved.
//

import UIKit
import MotionTagSDK

class AppDelegate: NSObject, UIApplicationDelegate {

    private lazy var motionTag = MotionTagCore.sharedInstance

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // The SDK should be one of the first things initialized in the "didFinishLaunchingWithOptions" delegate
        motionTag.initialize(using: MainViewModel.shared, launchOption: launchOptions)
        MainViewModel.shared.configure()
        return true
    }

    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        // The SDK must also be called in the "handleEventsForBackgroundURLSession" delegate
        motionTag.processBackgroundSessionEvents(with: identifier, completionHandler: completionHandler)
    }
}
