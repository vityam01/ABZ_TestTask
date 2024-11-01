//
//  UserResponseModel.swift
//  abzTestTask
//
//  Created by Vitya Mandryk on 31.10.2024.
//

import Foundation



struct UserResponse: Codable {
    let success: Bool
    let user: User?
    let message: String?
    let fails: [String: [String]]?
}
