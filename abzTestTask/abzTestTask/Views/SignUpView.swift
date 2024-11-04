//
//  SignUpView.swift
//  abzTestTask
//
//  Created by Vitya Mandryk on 31.10.2024.
//

import Foundation
import SwiftUI
import PhotosUI



struct SignUpView: View {
    @Binding var selectedTab: Tab
    @StateObject private var viewModel = SignUpViewModel()
    @ObservedObject private var networkManager = NetworkManager.shared
    @State private var showNoConnectionScreen = false
    @State private var showImagePicker = false
    @State private var imageSource: UIImagePickerController.SourceType = .photoLibrary
    @State private var showImageSourceActionSheet = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            if showNoConnectionScreen {
                ReusableScreen(
                    viewModel: ReusableScreenViewModel(
                        image: APPImage.noInternet,
                        mainText: viewModel.failureMessage.isEmpty ? "There is no internet connection" : viewModel.failureMessage,
                        buttonText: "Try again",
                        buttonAction: {
                            viewModel.showFailureScreen = false
                        },
                        showCloseButton: false,
                        closeAction: {
                            viewModel.showFailureScreen = false
                        }
                    )
                ) {
                    EmptyView()
                }
            } else {
                VStack(spacing: 0) {
                    HeaderView(title: "Working with POST request")
                        .navigationBarBackButtonHidden(true)
                    
                    Spacer()
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 10) {
                            VStack(spacing: 20) {
                                CustomTextField(
                                        placeholder: "Name",
                                        text: $viewModel.name,
                                        fieldType: .name,
                                        isError: viewModel.showError[.name] ?? false,
                                        errorMessage: viewModel.errorMessages[.name] ?? ""
                                    )
                                    CustomTextField(
                                        placeholder: "Email",
                                        text: $viewModel.email,
                                        fieldType: .email,
                                        isError: viewModel.showError[.email] ?? false,
                                        errorMessage: viewModel.errorMessages[.email] ?? ""
                                    )
                                    CustomTextField(
                                        placeholder: "+38 (XXX) XXX - XX - XX",
                                        text: $viewModel.phone,
                                        fieldType: .phone,
                                        isError: viewModel.showError[.phone] ?? false,
                                        errorMessage: viewModel.errorMessages[.phone] ?? ""
                                    )
                            }
                            .padding(.top, 32)
                            
                            Text("Select your position")
                                .font(AppFont.semiBold.font(size: 16))
                                .padding(.vertical)
                            
                            ForEach(viewModel.positions, id: \.id) { position in
                                RadioButton(position: position, selectedPosition: $viewModel.selectedPosition)
                            }
                            
                            
                            
                            VStack(alignment: .leading, spacing: 5) {
                                HStack {
                                    Text(viewModel.userImage != nil ? "Uploaded ✅" : "Upload your photo")
                                        .font(AppFont.regular.font(size: 16))
                                        .foregroundColor(viewModel.isPhotoMissing ? .red : .gray)
                                        .padding(.leading)
                                    Spacer()
                                    Button(action: {
                                        showImageSourceActionSheet = true
                                    }) {
                                        Text("Upload")
                                            .font(AppFont.semiBold.font(size: 16))
                                            .foregroundColor(AppColors.appBlue)
                                    }
                                    .padding(.trailing)
                                }
                                .frame(height: 56)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(viewModel.isPhotoMissing ? Color.red : Color.gray, lineWidth: 1)
                                )
                                
                                if viewModel.isPhotoMissing {
                                    Text("Photo is required")
                                        .font(.caption)
                                        .foregroundColor(.red)
                                }
                            }
                            
                            
                            Spacer()
                            
                            HStack {
                                Spacer()
                                Button(action: {
                                    viewModel.validateFields()
                                    if viewModel.allFieldsFilled {
                                        viewModel.performSignUp()
                                    }
                                }) {
                                    Text("Sign up")
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(viewModel.allFieldsFilled ? Color.yellow : AppColors.defaultBackgroundGray)
                                        .foregroundColor(viewModel.allFieldsFilled ? .black : AppColors.darkGray)
                                        .cornerRadius(24)
                                }
                                .frame(width: 140)
                                .padding(.bottom, 20)
                                Spacer()
                            }
                            
                        }
                        .padding(.horizontal)
                    }
                    
                    // Navigation buttons at the bottom
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            selectedTab = .users
                        }) {
                            HStack {
                                Image(selectedTab == .users ? AppIcons.peopleActive : AppIcons.peopleDefault)
                                    .frame(width: 22, height: 17)
                                Text("Users")
                                    .foregroundColor(selectedTab == .users ? AppColors.appBlue : AppColors.darkGray)
                                    .font(AppFont.semiBold.font(size: 16))
                            }
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            selectedTab = .signUp
                        }) {
                            HStack {
                                Image(selectedTab == .signUp ? AppIcons.signUpActive : AppIcons.signUpDefault)
                                    .frame(width: 22, height: 17)
                                Text("Sign up")
                                    .foregroundColor(selectedTab == .signUp ? AppColors.appBlue : AppColors.darkGray)
                                    .font(AppFont.semiBold.font(size: 16))
                            }
                        }
                        
                        
                        Spacer()
                    }
                    .padding(.top)
                    .background(AppColors.lightGray)
                }
            }
            
            // Success and failure screens
            if viewModel.showSuccessScreen {
                ReusableScreen(
                    viewModel: ReusableScreenViewModel(
                        image: Image(APPImage.successfulyRegistered),
                        mainText: "User successfully registered",
                        buttonText: "Got it",
                        buttonAction: {
                            viewModel.showSuccessScreen = false
                            selectedTab = .users
                        },
                        showCloseButton: true,
                        closeAction: {
                            viewModel.showSuccessScreen = false
                        }
                    )
                ) {
                    EmptyView()
                }
            }
            
            if viewModel.showFailureScreen {
                ReusableScreen(
                    viewModel: ReusableScreenViewModel(
                        image: Image(APPImage.alreadyRegistered),
                        mainText: viewModel.failureMessage.isEmpty ? "An error occurred" : viewModel.failureMessage,
                        buttonText: "Try again",
                        buttonAction: {
                            viewModel.showFailureScreen = false
                        },
                        showCloseButton: true,
                        closeAction: {
                            viewModel.showFailureScreen = false
                        }
                    )
                ) {
                    EmptyView()
                }
            }
            
        }
        .onAppear {
            viewModel.fetchTokenOnAppear()
            viewModel.fetchPositions()
            showNoConnectionScreen = !networkManager.isConnected
        }
        .actionSheet(isPresented: $showImageSourceActionSheet) {
            ActionSheet(
                title: Text("Select Photo Source"),
                buttons: [
                    .default(Text("Camera")) {
                        imageSource = .camera
                        showImagePicker = true
                    },
                    .default(Text("Photo Library")) {
                        imageSource = .photoLibrary
                        showImagePicker = true
                    },
                    .cancel()
                ]
            )
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(sourceType: imageSource, selectedImage: $viewModel.userImage)
        }
        .onAppear {
            viewModel.fetchTokenOnAppear()
            showNoConnectionScreen = !networkManager.isConnected
        }
        .onChange(of: networkManager.isConnected) { isConnected in
            showNoConnectionScreen = !isConnected
            
        }
        .onChange(of: viewModel.showFailureScreen) { newValue in
            print("showFailureScreen changed to: \(newValue)")
        }
    }
}
