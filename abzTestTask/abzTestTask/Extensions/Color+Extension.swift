//
//  Color+Extension.swift
//  abzTestTask
//
//  Created by Vitya Mandryk on 31.10.2024.
//

import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.hasPrefix("#") ? String(hex.dropFirst()) : hex
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        
        let red = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgbValue & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }
}

