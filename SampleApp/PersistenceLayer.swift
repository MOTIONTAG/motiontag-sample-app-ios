//
//  PersistenceLayer.swift
//  SampleApp
//
//  Created by Kian Mehravaran on 23.01.26.
//  Copyright © 2026 MotionTag GmbH. All rights reserved.
//


import Foundation


struct PersistenceLayer {
    static private let MT_USER_TOKEN_KEY = "MT_USER_TOKEN_KEY"
    static private let MT_ONBOARDING_OVER_KEY = "MT_ONBOARDING_OVER_KEY"

    static var token: String? {
        get {
            UserDefaults.standard.string(forKey: MT_USER_TOKEN_KEY)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: MT_USER_TOKEN_KEY)
        }
    }

    static var isOnboardingOver: Bool {
        get {
            UserDefaults.standard.bool(forKey: MT_ONBOARDING_OVER_KEY)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: MT_ONBOARDING_OVER_KEY)
        }
    }
}
