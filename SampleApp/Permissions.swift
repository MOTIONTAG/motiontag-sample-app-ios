//
//  Permissions.swift
//  SampleApp
//
//  Created by Kian Mehravaran on 10/20/20.
//  Copyright © 2020 Henrique Faria. All rights reserved.
//

import CoreLocation
import CoreMotion

protocol LocationAuthorizationDelegate: class {
    func didObtainRequiredLocationAuthorization(result: Bool)
}

protocol ActivityAuthorizationDelegate: class {
    func didObtainRequiredActivityAuthorization(result: Bool)
}

class Permissions: NSObject {

    weak var locationDelegate: LocationAuthorizationDelegate?
    weak var activityDelegate: ActivityAuthorizationDelegate?

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
        motionManager.queryActivityStarting(from: Date(), to: Date(), to: OperationQueue.main) { [weak self] _, error in
            if let delegate = self?.activityDelegate {
                if CMMotionActivityManager.isActivityAvailable() {
                    delegate.didObtainRequiredActivityAuthorization(result: error == nil)
                } else {
                    delegate.didObtainRequiredActivityAuthorization(result: true)
                }
            }
        }
    }
}

extension Permissions: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if let delegate = locationDelegate {
            var result = false
            if case .authorizedAlways = status {
                result = true
            }
            delegate.didObtainRequiredLocationAuthorization(result: result)
        }
        if case .authorizedWhenInUse = status {
            locationManager.requestAlwaysAuthorization()
        }
    }
}
