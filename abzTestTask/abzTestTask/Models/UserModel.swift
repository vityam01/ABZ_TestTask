//
//  UserModel.swift
//  abzTestTask
//
//  Created by Vitya Mandryk on 31.10.2024.
//

import Foundation


struct User: Identifiable, Codable, Equatable {
    let id: Int
    let name: String
    let email: String
    let phone: String
    let positionId: Int
    let position: String
    let photo: String
    let registrationTimestamp: Int

    private enum CodingKeys: String, CodingKey {
        case id, name, email, phone, position, photo
        case positionId = "position_id"
        case registrationTimestamp = "registration_timestamp"
    }
}
