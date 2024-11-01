//
//  abzTestTaskApp.swift
//  abzTestTask
//
//  Created by Vitya Mandryk on 31.10.2024.
//

import SwiftUI


@main
struct abzTestTaskApp: App {
    @State private var showLaunchView = true

    var body: some Scene {
        WindowGroup {
            if showLaunchView {
                LaunchView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            showLaunchView = false
                        }
                    }
            } else {
                MainView()
            }
        }
    }
}


