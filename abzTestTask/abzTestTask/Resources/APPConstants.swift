//
//  APPConstants.swift
//  abzTestTask
//
//  Created by Vitya Mandryk on 31.10.2024.
//

import Foundation
import SwiftUI

//MARK: FieldType
enum FieldType {
    case name, email, phone
}

//MARK: Tab
enum Tab {
    case users, signUp
}

//MARK: AppIcons
enum AppIcons {
    static let peopleActive = "people_selected_symbol"
    static let peopleDefault = "people_default_symbol"
    static let signUpDefault = "singUp_default_symbol"
    static let signUpActive = "singUp_selected_symbol"
    static let ellipseFill = "Ellipse_fill"
    static let ellipseEmpty = "Ellipse_empty"
    static let closeBtn = "close"
}

//MARK: APPImage
enum APPImage {
    static let noInternet = Image("no_internet_image")
    static let alreadyRegistered = "already_registered_image"
    static let people = "people_image"
    static let successfulyRegistered = "successfuly_registered_image"
    static let welcomeCat = "welcome_cat_image"
    
}

//MARK: AppFont
enum AppFont: String {
    case regular = "Nunito-Regular"
    case semiBold = "Nunito-SemiBold"
    
    func font(size: CGFloat) -> Font {
        return .custom(self.rawValue, size: size)
    }
}

//MARK: AppColors
enum AppColors {
    static let primary = Color(hex: "#F4E041")
    static let appBlue = Color(hex: "#00BDD3")
    static let lightGray = Color(hex: "#F8F8F8")
    static let darkGray = Color(hex: "#6E6E6E")
    static let appRed = Color(hex: "#CB3D40")
    static let defaultBackgroundGray = Color(hex: "#DEDEDE")
}


//MARK: PositionInCompany
enum PositionInCompany: Int, CaseIterable, Identifiable {
    case frontend = 1
    case backend
    case designer
    case qa

    var id: Int { rawValue }
    
    var title: String {
            switch self {
            case .frontend: return "Frontend Developer"
            case .backend: return "Backend Developer"
            case .designer: return "Designer"
            case .qa: return "QA"
            }
        }
}


//MARK: Endpoints
enum Endpoints: String {
    case base = "https://frontend-test-assignment-api.abz.agency/api/v1"
    case token = "/token"
    case users = "/users"
    case positions = "/positions"
}

//MARK: HTTPHeader
enum HTTPHeader {
    case contentType(String)
    case accept(String)
    case token(String)

    var keyValue: (String, String) {
        switch self {
        case .contentType(let value): return ("Content-Type", value)
        case .accept(let value): return ("Accept", value)
        case .token(let value): return ("Token", value)
        }
    }
}


//MARK: APIError
enum APIError: Error, LocalizedError {
    case invalidURL
    case decodingError
    case serverError(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL is invalid."
        case .decodingError:
            return "Failed to decode the response."
        case .serverError(let message):
            return message
        }
    }
}
