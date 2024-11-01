//
//  PositionResponseModel.swift
//  abzTestTask
//
//  Created by Vitya Mandryk on 31.10.2024.
//

import Foundation



struct PositionResponse: Decodable {
    let success: Bool
    let positions: [Position]?
    let message: String?
}
