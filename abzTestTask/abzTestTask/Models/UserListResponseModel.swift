//
//  UserListResponseModel.swift
//  abzTestTask
//
//  Created by Vitya Mandryk on 31.10.2024.
//

import Foundation



struct UserListResponse: Decodable {
    let success: Bool
    let totalPages: Int
    let totalUsers: Int
    let count: Int
    let page: Int
    let links: PaginationLinks
    let users: [User]
    
    private enum CodingKeys: String, CodingKey {
        case success, count, page, users, links
        case totalPages = "total_pages"
        case totalUsers = "total_users"
    }
}
