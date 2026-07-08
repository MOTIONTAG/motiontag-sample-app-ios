//
//  OnboardingView.swift
//  SampleApp
//
//  Created by Kian Mehravaran on 23.01.26.
//  Copyright © 2026 MotionTag GmbH. All rights reserved.
//

import SwiftUI
import CoreLocation
import CoreMotion

struct OnboardingView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var viewModel = OnboardingViewModel()
    
    // Must be replaced with a valid token: https://api.motion-tag.de/developer/
    private let userToken = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Spacer()
                
                // Header
                VStack(spacing: 12) {
                    Image(systemName: "figure.walk.motion")
                        .font(.system(size: 80))
                        .foregroundColor(.blue)
                    
                    Text("Welcome to\nmotiontag")
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.center)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("We need a few permissions to track your movement and provide insights.")
                        .fixedSize(horizontal: false, vertical: true)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                Spacer()
                
                // Permission Buttons
                VStack(spacing: 16) {
                    PermissionButton(
                        title: "Location Access",
                        subtitle: "Required for tracking your travels",
                        icon: "location.fill",
                        status: viewModel.locationStatus,
                        isEnabled: !viewModel.locationRequested
                    ) {
                        viewModel.requestLocationPermission()
                    }
                    
                    PermissionButton(
                        title: "Motion Activity",
                        subtitle: "Required for detecting transport mode",
                        icon: "figure.run",
                        status: viewModel.activityStatus,
                        isEnabled: !viewModel.activityRequested
                    ) {
                        viewModel.requestMotionPermission()
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                // Continue Button
                Button {
                    appState.completeOnboarding()
                    LibraryLayer.shared.setToken(userToken)
                } label: {
                    Text("Get Started")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .buttonStyle(.borderedProminent)
                .disabled(!viewModel.allPermissionsGranted)
                .padding(.horizontal)
                .padding(.bottom, 32)
            }
            .navigationTitle("Setup")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Permission Button Component

struct PermissionButton: View {
    let title: String
    let subtitle: String
    let icon: String
    let status: PermissionStatus
    let isEnabled: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(status.color)
                    .frame(width: 44, height: 44)
                    .background {
                        Circle()
                            .fill(status.color.opacity(0.15))
                    }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(subtitle)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.leading)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: status.iconName)
                    .font(.title3)
                    .foregroundColor(status.color)
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
            }
        }
        .disabled(!isEnabled)
        .opacity(isEnabled ? 1.0 : 0.7)
    }
}

// MARK: - Permission Status

enum PermissionStatus {
    case pending
    case granted
    case denied
    
    var color: Color {
        switch self {
        case .pending: return .blue
        case .granted: return .green
        case .denied: return .red
        }
    }
    
    var iconName: String {
        switch self {
        case .pending: return "chevron.right"
        case .granted: return "checkmark.circle.fill"
        case .denied: return "xmark.circle.fill"
        }
    }
}

// MARK: - ViewModel

@MainActor
class OnboardingViewModel: NSObject, ObservableObject {
    @Published var locationStatus: PermissionStatus = .pending
    @Published var activityStatus: PermissionStatus = .pending
    @Published var locationRequested = false
    @Published var activityRequested = false
    
    var allPermissionsGranted: Bool {
        locationStatus == .granted && activityStatus == .granted
    }
    
    private var locationManager: CLLocationManager?
    
    private let motionManager = CMMotionActivityManager()
    
    private func getLocationManager() -> CLLocationManager {
        if let manager = locationManager {
            return manager
        }
        let manager = CLLocationManager()
        manager.delegate = self
        locationManager = manager
        return manager
    }
    
    func requestLocationPermission() {
        locationRequested = true
        getLocationManager().requestWhenInUseAuthorization()
    }
    
    func requestMotionPermission() {
        activityRequested = true
        motionManager.queryActivityStarting(from: Date(), to: Date(), to: OperationQueue.main) { [weak self] _, error in
            Task { @MainActor in
                if CMMotionActivityManager.isActivityAvailable() {
                    self?.activityStatus = error == nil ? .granted : .denied
                } else {
                    self?.activityStatus = .granted
                }
            }
        }
    }
}

extension OnboardingViewModel: CLLocationManagerDelegate {
    nonisolated func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        Task { @MainActor in
            switch status {
            case .authorizedAlways:
                locationStatus = .granted
            case .authorizedWhenInUse:
                // Request always authorization after when-in-use is granted
                manager.requestAlwaysAuthorization()
            case .denied, .restricted:
                locationStatus = .denied
            case .notDetermined:
                locationStatus = .pending
            @unknown default:
                locationStatus = .pending
            }
        }
    }
}

#Preview {
    OnboardingView()
        .environmentObject(AppState.shared)
}
