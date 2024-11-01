//
//  UsersView.swift
//  abzTestTask
//
//  Created by Vitya Mandryk on 31.10.2024.
//

import Foundation
import SwiftUI



struct UsersView: View {
    @Binding var selectedTab: Tab
    @StateObject private var viewModel = UsersViewModel()
    @ObservedObject private var networkManager = NetworkManager.shared
    @State private var showNoConnectionScreen = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            if showNoConnectionScreen {
                ReusableScreen(
                    viewModel: ReusableScreenViewModel(
                        image: APPImage.noInternet,
                        mainText: "There is no internet connection",
                        buttonText: "Try again",
                        buttonAction: {
                            Task {
                                if networkManager.isConnected {
                                    showNoConnectionScreen = false
                                    await viewModel.loadInitialUsers()
                                }
                            }
                        },
                        showCloseButton: false,
                        closeAction: { }
                    )
                ) {
                    Text("Additional content goes here.")
                }
            } else {
                VStack {
                    HeaderView(title: "Working with GET request")
                        .navigationBarBackButtonHidden(true)
                    
                    VStack(spacing: 0) {
                        if viewModel.users.isEmpty && !viewModel.isLoading {
                            VStack {
                                Image(APPImage.people)
                                    .scaledToFit()
                                Text("There are no users yet")
                                    .font(AppFont.regular.font(size: 20))
                                    .foregroundColor(.black)
                                    .padding(.top, 24)
                            }
                            .frame(maxHeight: .infinity)
                        } else {
                            List {
                                ForEach(viewModel.users, id: \.id) { user in
                                    WorkerCell(viewModel: WorkerCellViewModel(user: user))
                                        .task {
                                            await viewModel.loadMoreContentIfNeeded(currentUser: user)
                                        }
                                }
                                .listRowInsets(EdgeInsets())
                                .listRowSeparator(.hidden)
                                
                                if viewModel.isLoading {
                                    ProgressView("Loading...")
                                }
                            }
                            .listStyle(PlainListStyle())
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                        
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
            }
        }
        .task {
            await viewModel.loadInitialUsers()
            showNoConnectionScreen = !networkManager.isConnected
        }
        .onChange(of: networkManager.isConnected) { isConnected in
            Task {
                showNoConnectionScreen = !isConnected
                if isConnected {
                    await viewModel.loadInitialUsers()
                }
            }
        }
    }
}







