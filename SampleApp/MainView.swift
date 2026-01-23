//
//  MainView.swift
//  SampleApp
//
//  Created by Kian Mehravaran on 23.01.26.
//  Copyright © 2026 MotionTag GmbH. All rights reserved.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var appState: AppState
    @ObservedObject private var viewModel = MainViewModel.shared
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 40) {
                Spacer()
                
                // Tracking Status Card
                VStack(spacing: 16) {
                    Image(systemName: viewModel.isTrackingActive ? "location.fill" : "location.slash")
                        .font(.system(size: 60))
                        .foregroundColor(viewModel.isTrackingActive ? .green : .gray)
                        .animation(.easeInOut, value: viewModel.isTrackingActive)
                    
                    Text(viewModel.isTrackingActive ? "Tracking Active" : "Tracking Inactive")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(viewModel.isTrackingActive ? .primary : .secondary)
                }
                .padding(32)
                .background {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.ultraThinMaterial)
                }
                
                // Tracking Toggle
                Toggle(isOn: Binding(
                    get: { viewModel.isTrackingActive },
                    set: { viewModel.toggleTracking($0) }
                )) {
                    Label("Enable Tracking", systemImage: "antenna.radiowaves.left.and.right")
                        .font(.headline)
                }
                .toggleStyle(.switch)
                .tint(.green)
                .padding(.horizontal, 32)
                .padding(.vertical, 16)
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemGray6))
                }
                .padding(.horizontal)
                
                // WiFi Only Transfer Toggle
                Toggle(isOn: Binding(
                    get: { viewModel.wifiOnlyDataTransfer },
                    set: { viewModel.setWifiOnly($0) }
                )) {
                    Label("WiFi Only Data Transfer", systemImage: "wifi")
                        .font(.headline)
                }
                .toggleStyle(.switch)
                .tint(.blue)
                .padding(.horizontal, 32)
                .padding(.vertical, 16)
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemGray6))
                }
                .padding(.horizontal)
                
                Spacer()
                
                // Logout Button
                Button(role: .destructive) {
                    appState.logout()
                } label: {
                    Label("Logout", systemImage: "rectangle.portrait.and.arrow.right")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)
                .padding(.horizontal)
                .padding(.bottom, 32)
            }
            .navigationTitle("motiontag")
        }
    }
}

#Preview {
    MainView()
        .environmentObject(AppState.shared)
}
