//
//  PermissionsManager.swift
//  SampleApp
//
//  Created by Kian Mehravaran on 10/20/20.
//  Copyright © 2020 MotionTag GmbH. All rights reserved.
//

import CoreLocation
import CoreMotion

enum AuthorizationType: CaseIterable {
    case location
    case activity
}

protocol AuthorizationDelegate: AnyObject {
    func didObtainRequiredAuthorization(result: Bool, type: AuthorizationType)
}

class PermissionsManager: NSObject {

    weak var delegate: AuthorizationDelegate?

    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.allowsBackgroundLocationUpdates = true
        manager.delegate = self
        return manager
    }()

    private lazy var motionManager: CMMotionActivityManager = {
        let manager = CMMotionActivityManager()
        return manager
    }()

    func obtainLocationPermission() {
        if #available(iOS 13.0, *) {
            locationManager.requestWhenInUseAuthorization()
        } else {
            locationManager.requestAlwaysAuthorization()
        }
    }

    func obtainMotionActivityPermission() {
        motionManager.queryActivityStarting(from: Date(), to: Date(), to: OperationQueue.main) { [unowned self] _, error in
            if CMMotionActivityManager.isActivityAvailable() {
                self.delegate?.didObtainRequiredAuthorization(result: error == nil, type: .activity)
            } else {
                self.delegate?.didObtainRequiredAuthorization(result: true, type: .activity)
            }
        }
    }
}

extension PermissionsManager: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        var result = false
        if case .authorizedAlways = status {
            result = true
        }
        delegate?.didObtainRequiredAuthorization(result: result, type: .location)
        if case .authorizedWhenInUse = status {
            locationManager.requestAlwaysAuthorization()
        }
    }
}
