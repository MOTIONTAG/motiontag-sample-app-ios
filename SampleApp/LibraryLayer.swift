//
//  LibraryLayer.swift
//  SampleApp
//
//  Created by Kian Mehravaran on 2020-11-09.
//  Copyright © 2020 MotionTag GmbH. All rights reserved.
//

import MotionTagSDK

protocol LibraryLayerDelegate: AnyObject {
    func didChangeTrackingStatus(isTracking: Bool)
}

class LibraryLayer: NSObject {

    private(set) var trackingStatus = false

    static var shared = LibraryLayer()

    private var motionTag: MotionTag!
    weak var delegate: LibraryLayerDelegate?

    var userToken: String {
        get {
            motionTag.userToken
        }
        set {
            motionTag.userToken = newValue
        }
    }

    func start() {
        motionTag.start()
        print("after motionTag.start motionTag.isTrackingActive \(motionTag.isTrackingActive)")
    }

    func stop() {
        motionTag.stop()
        print("after motionTag.stop motionTag.isTrackingActive \(motionTag.isTrackingActive)")
    }

    //Connect to your UI if needed. Not used in the Sample App
    var wifiOnlyTransmission: Bool {
        get {
            motionTag.wifiOnlyDataTransfer
        }
        set {
            motionTag.wifiOnlyDataTransfer = newValue
        }
    }

    func clearUserData(completionHandler: @escaping () -> Void) {
        motionTag.clearData {
            print("cleared user data")
            completionHandler()
        }
    }

    //call from the AppDelegate application(_:handleEventsForBackgroundURLSession:completionHandler:) method
    func handleEvents(forBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        motionTag.handleEvents(forBackgroundURLSession: identifier, completionHandler: completionHandler)
    }

    private override init() {
        super.init()
        motionTag = MotionTagCore.sharedInstance
        motionTag.delegate = self
        trackingStatus = MotionTagCore.sharedInstance.isTrackingActive
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

    func dataUploadWithTracked(from startDate: Date, to endDate: Date, didCompleteWithError error: Error?) {
        let errorString = (error != nil) ? error.debugDescription : "no error"
        print("MotionTag SDK didTransmitData - Events starting at: \(startDate), and ending at: \(endDate) with: \(errorString)")
     }
}
