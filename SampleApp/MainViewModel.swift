//
//  MainViewModel.swift
//  SampleApp
//
//  Created by Kian Mehravaran on 23.01.26.
//  Copyright © 2026 MotionTag GmbH. All rights reserved.
//

import MotionTagSDK
import CoreLocation

class MainViewModel: NSObject, ObservableObject {
    static let shared = MainViewModel()
    
    @Published var isTrackingActive: Bool = false
    @Published var wifiOnlyDataTransfer: Bool = false
    
    private var motionTag: MotionTag {
        MotionTagCore.sharedInstance
    }
    
    override init() {
        super.init()
    }
    
    func configure() {
        isTrackingActive = motionTag.isTrackingActive
        wifiOnlyDataTransfer = motionTag.wifiOnlyDataTransfer
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
}

extension MainViewModel: MotionTagDelegate {
    
    func trackingStatusChanged(_ isTracking: Bool) {
        print("MotionTag SDK trackingStatusChanged: \(isTracking)")
        DispatchQueue.main.async {
            self.isTrackingActive = isTracking
        }
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
