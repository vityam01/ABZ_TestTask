//
//  MainView.swift
//  abzTestTask
//
//  Created by Vitya Mandryk on 31.10.2024.
//

import Foundation
import SwiftUI



struct MainView: View {
    @State private var selectedTab: Tab = .users
    
    var body: some View {
        NavigationStack {
            VStack {
                switch selectedTab {
                case .users:
                    UsersView(selectedTab: $selectedTab)
                case .signUp:
                    SignUpView(selectedTab: $selectedTab)
                }
            }
        }
    }
}

