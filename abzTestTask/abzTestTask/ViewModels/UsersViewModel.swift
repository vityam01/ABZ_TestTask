//
//  UsersViewModel.swift
//  abzTestTask
//
//  Created by Vitya Mandryk on 31.10.2024.
//

import SwiftUI
import Combine



@MainActor
class UsersViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var isLoading = false
    @Published var hasMoreUsers = true
    @Published var selectedTab: Tab = .users
    
    private var userAPIManager = UserAPIManager()
    private var nextLink: String?
    
    func loadInitialUsers() async {
        users = []
        hasMoreUsers = true
        nextLink = nil
        await loadMoreUsers()
    }
    
    func loadMoreContentIfNeeded(currentUser: User) async {
        guard !isLoading, hasMoreUsers, currentUser == users.last else { return }
        await loadMoreUsers()
    }
    
    private func loadMoreUsers() async {
        guard !isLoading && hasMoreUsers else { return }
        
        isLoading = true
        let result = await userAPIManager.fetchUsers(nextLink: nextLink, count: 6)
        
        isLoading = false
        switch result {
        case .success(let response):
            if response.users.isEmpty {
                hasMoreUsers = false
            } else {
                nextLink = response.links.nextUrl
                let uniqueUsers = response.users.filter { newUser in
                    !users.contains { $0.id == newUser.id }
                }
                users.append(contentsOf: uniqueUsers)
                users.sort(by: { $0.registrationTimestamp > $1.registrationTimestamp })
            }
        case .failure(let error):
            print("Failed to fetch users: \(error)")
        }
    }
}

