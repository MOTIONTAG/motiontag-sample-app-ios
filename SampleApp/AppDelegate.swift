//
//  AppDelegate.swift
//  SampleApp
//
//  Created by Kian Mehravaran on 23.01.26.
//  Copyright © 2026 MotionTag GmbH. All rights reserved.
//

import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {

    private lazy var libraryLayer = LibraryLayer.shared

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // The SDK should be one of the first things initialized in the "didFinishLaunchingWithOptions" delegate
        libraryLayer.initialize(launchOptions: launchOptions)
        return true
    }
    
    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String) async {
        // The SDK must also be called in the "handleEventsForBackgroundURLSession" delegate
        await libraryLayer.processBackgroundSessionEvents(with: identifier)
    }
}
