//
//  PaginationLinksModel.swift
//  abzTestTask
//
//  Created by Vitya Mandryk on 31.10.2024.
//

import Foundation



struct PaginationLinks: Decodable {
    let nextUrl: String?
    let prevUrl: String?
    
    private enum CodingKeys: String, CodingKey {
        case nextUrl = "next_url"
        case prevUrl = "prev_url"
    }
}
