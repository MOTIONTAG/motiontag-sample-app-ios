//
//  AppState.swift
//  SampleApp
//
//  Created by Kian Mehravaran on 23.01.26.
//  Copyright © 2026 MotionTag GmbH. All rights reserved.
//

import SwiftUI
import MotionTagSDK

@MainActor
class AppState: ObservableObject {
    static let shared = AppState()
    
    @Published var isOnboardingComplete: Bool
    
    private init() {
        isOnboardingComplete = PersistenceLayer.isOnboardingOver
    }
    
    func completeOnboarding() {
        PersistenceLayer.isOnboardingOver = true
        isOnboardingComplete = true
    }
    
    func logout() {
        PersistenceLayer.isOnboardingOver = false
        isOnboardingComplete = false
    }
}
