//
//  CustomTextFieldView.swift
//  abzTestTask
//
//  Created by Vitya Mandryk on 31.10.2024.
//

import Foundation
import SwiftUI



struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String
    var fieldType: FieldType
    var isError: Bool
    var errorMessage: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            TextField(placeholder, text: $text)
                .padding()
                .background(Color.white)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isError ? AppColors.appRed : Color.gray, lineWidth: 1)
                )
                .autocapitalization(fieldType == .email ? .none : .sentences)
                .textContentType(fieldType == .email ? .emailAddress : .none)
            
            if isError {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
    }
}


