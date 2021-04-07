//
//  LibraryLayer.swift
//  SampleApp
//
//  Created by Kian Mehravaran on 2020-11-09.
//  Copyright © 2020 MotionTag GmbH. All rights reserved.
//

import MotionTagSDK

protocol LibraryLayerDelegate: class {
    func didChangeTrackingStatus(isTracking: Bool)
}

class LibraryLayer: NSObject {

    private(set) var trackingStatus = false

    static var shared = LibraryLayer()

    private var motionTag: MotionTag!
    weak var delegate: LibraryLayerDelegate?

    func start() {
        motionTag.start(withToken: PersistenceLayer.token)
        print("after motionTag.start motionTag.isTrackingActive \(motionTag.isTrackingActive)")
    }

    func stop() {
        motionTag.stop()
        print("after motionTag.stop motionTag.isTrackingActive \(motionTag.isTrackingActive)")
    }
    
    private override init() {
        super.init()
        let settings = [kMTDataTransferMode: DataTransferMode.wifiAnd3G.rawValue as AnyObject, kMTBatterySavingsMode: true as AnyObject]
        motionTag = MotionTagCore.sharedInstance(withSettings: settings)
        motionTag.delegate = self
    }
}

// MARK: MotionTagDelegate

extension LibraryLayer: MotionTagDelegate {

    func trackingStatusChanged(_ isTracking: Bool) {
        print("MotionTag SDK trackingStatusChanged: \(isTracking)")
        delegate?.didChangeTrackingStatus(isTracking: isTracking)
        trackingStatus = isTracking
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

    func didTransmitData(timestamp: Date, lastEventTimestamp: Date) {
        print("MotionTag SDK didTransmitData - timestamp: \(timestamp), lastEventTimestamp: \(lastEventTimestamp)")
    }
}
