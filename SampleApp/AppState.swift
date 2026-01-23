//
//  AppState.swift
//  SampleApp
//
//  Created by Kian Mehravaran on 23.01.26.
//  Copyright © 2026 MotionTag GmbH. All rights reserved.
//

import SwiftUI
import MotionTagSDK

class AppState: ObservableObject {
    static let shared = AppState()
    
    @Published var isOnboardingComplete: Bool
    @Published var isTracking: Bool = false
    
    private init() {
        isOnboardingComplete = PersistenceLayer.isOnboardingOver
    }
    
    func completeOnboarding(with userToken: String) {
        let motionTag = MotionTagCore.sharedInstance
        motionTag.userToken = userToken
        PersistenceLayer.isOnboardingOver = true
        isOnboardingComplete = true
    }
    
    func logout() {
        let motionTag = MotionTagCore.sharedInstance
        motionTag.stop()
        motionTag.clearData()
        PersistenceLayer.isOnboardingOver = false
        isOnboardingComplete = false
    }
    
    func updateTrackingStatus(_ isTracking: Bool) {
        DispatchQueue.main.async {
            self.isTracking = isTracking
        }
    }
}
