//
//  TokenResponseModel.swift
//  abzTestTask
//
//  Created by Vitya Mandryk on 31.10.2024.
//

import Foundation


struct TokenResponse: Decodable {
    let success: Bool
    let token: String
}
