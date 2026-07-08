//
//  LibraryLayer.swift
//  SampleApp
//
//  Created by Kian Mehravaran on 23.01.26.
//  Copyright © 2026 MotionTag GmbH. All rights reserved.
//

import UIKit
import MotionTagSDK
import CoreLocation

@MainActor
class LibraryLayer: ObservableObject {
    static let shared = LibraryLayer()
    
    @Published var isTrackingActive: Bool = false
    @Published var wifiOnlyDataTransfer: Bool = false
    
    private lazy var motionTag: MotionTag = {
        let motionTag = MotionTagCore.sharedInstance
        return motionTag
    }()
    
    func initialize(launchOptions: [UIApplication.LaunchOptionsKey : Any]?) {
        motionTag.initialize(using: self, launchOptions: launchOptions)
        wifiOnlyDataTransfer = motionTag.wifiOnlyDataTransfer
    }
    
    func processBackgroundSessionEvents(with identifier: String) async {
        await motionTag.processBackgroundSessionEvents(with: identifier)
    }
    
    func toggleTracking(_ enabled: Bool) {
        if enabled {
            motionTag.start()
        } else {
            motionTag.stop()
        }
    }
    
    func setWifiOnly(_ enabled: Bool) {
        wifiOnlyDataTransfer = enabled
        motionTag.wifiOnlyDataTransfer = enabled
    }
    
    func setToken(_ token: String) {
        motionTag.userToken = token
    }
    
    func clearData() {
        _ = motionTag.clearData()
    }
}

extension LibraryLayer: MotionTagDelegate {
    
    func trackingDidChange(isTracking: Bool) {
        print("MotionTag SDK trackingDidChange - isTracking: \(isTracking)")
        self.isTrackingActive = isTracking
    }
    
    func locationAuthorizationDidChange(status: CLAuthorizationStatus, isPrecise: Bool) {
        print("MotionTag SDK locationAuthorizationDidChange: \(status.rawValue) precise: \(isPrecise)")
    }
    
    func motionActivityAuthorizationDidChange(isAuthorized: Bool) {
        print("MotionTag SDK motionActivityAuthorizationDidChange: \(isAuthorized)")
    }
    
    func didUpdateLocation(_ location: CLLocation) {
        print("MotionTag SDK didUpdateLocation - CLLocation: \(location)")
    }
    
    func dataUploadDidComplete(from startDate: Date, to endDate: Date, error: (any Error)?) {
        let errorText = error == nil ? "successfully completed" : error.debugDescription
        print("MotionTag SDK dataUploadWithTracked - startDate: \(startDate), endDate: \(endDate)", errorText)
    }
}
