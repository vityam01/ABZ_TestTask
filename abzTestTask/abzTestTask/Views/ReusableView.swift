//
//  ReusableView.swift
//  abzTestTask
//
//  Created by Vitya Mandryk on 31.10.2024.
//

import Foundation
import SwiftUI


struct ReusableScreen<Content: View>: View {
    let viewModel: ReusableScreenViewModel
    let content: Content
    
    init(viewModel: ReusableScreenViewModel, @ViewBuilder content: () -> Content) {
        self.viewModel = viewModel
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Spacer()
                    if viewModel.showCloseButton, let closeAction = viewModel.closeAction {
                        Button(action: closeAction) {
                            Image(AppIcons.closeBtn)
                                .padding()
                        }
                    }
                }
                .padding(.top,35)
                VStack(alignment: .center) {
                    Spacer()
                    viewModel.image
                        .scaledToFit()
                        .padding()
                    
                    Text(viewModel.mainText)
                        .font(AppFont.regular.font(size: 20))
                        .padding()
                    
                    content
                    
                    Button(action: viewModel.buttonAction) {
                        Text(viewModel.buttonText)
                            .padding()
                            .font(AppFont.semiBold.font(size: 18))
                            .background(AppColors.primary)
                            .foregroundColor(.black)
                            .cornerRadius(24)
                            .frame(width: 140, height: 48)
                            .padding(.vertical,24)
                    }
                    Spacer()
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(16)
            .shadow(radius: 10)
        }
        .edgesIgnoringSafeArea(.all)
    }
}




#Preview {
    let viewModel = ReusableScreenViewModel(
        image: APPImage.noInternet,
        mainText: "There is no internet connection",
        buttonText: "Try again",
        buttonAction: { print("Button tapped") },
        showCloseButton: false,
        closeAction: { print("Close button tapped") }
    )
    
    return ReusableScreen(viewModel: viewModel) {
        Text("Additional content goes here.")
    }
}


