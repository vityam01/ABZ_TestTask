//
//  ContentView.swift
//  abzTestTask
//
//  Created by Vitya Mandryk on 31.10.2024.
//

import SwiftUI



struct LaunchView: View {
    var body: some View {
        ZStack {
            AppColors.primary
            VStack {
                Image(APPImage.welcomeCat)
                    .imageScale(.large)
                
                Text("TESTTASK")
                    .font(AppFont.semiBold.font(size: 35))
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    LaunchView()
}



