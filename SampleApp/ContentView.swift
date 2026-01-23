//
//  ContentView.swift
//  SampleApp
//
//  Created by Kian Mehravaran on 23.01.26.
//  Copyright © 2026 MotionTag GmbH. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        if appState.isOnboardingComplete {
            MainView()
        } else {
            OnboardingView()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AppState.shared)
}
