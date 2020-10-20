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
    func didObtainRequiredAuthorization(result: Bool)
}

protocol ActivityAuthorizationDelegate: class {
    func didObtainRequiredAuthorization(result: Bool)
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

    func obtainLocationPermission() {

    }

    func obtain
}

extension Permissions: CLLocationManagerDelegate {

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {

    }
}
