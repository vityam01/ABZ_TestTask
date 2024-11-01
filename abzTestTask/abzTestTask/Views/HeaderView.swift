//
//  HeaderView.swift
//  abzTestTask
//
//  Created by Vitya Mandryk on 31.10.2024.
//

import Foundation
import SwiftUI

struct HeaderView: View {
    let title: String

    var body: some View {
        AppColors.primary
            .frame(height: 56)
            .overlay(
                Text(title)
                    .font(AppFont.regular.font(size: 20))
                    .foregroundColor(.black)
            )
    }
}

#Preview {
    HeaderView(title: "Working with GET request")
}
