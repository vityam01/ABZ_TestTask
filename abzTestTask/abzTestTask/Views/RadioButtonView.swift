//
//  RadioButtonView.swift
//  abzTestTask
//
//  Created by Vitya Mandryk on 31.10.2024.
//

import Foundation
import SwiftUI



struct RadioButton: View {
    var position: Position
    @Binding var selectedPosition: Position?
    
    var body: some View {
        HStack {
            Image(selectedPosition?.id == position.id ? AppIcons.ellipseFill : AppIcons.ellipseEmpty)
                .foregroundColor(selectedPosition?.id == position.id ? AppColors.appBlue : Color.gray)
            Text(position.name)
                .font(AppFont.regular.font(size: 16))
                .foregroundColor(.black)
            Spacer()
        }
        .padding(.vertical)
        .frame(height: 30)
        .onTapGesture {
            selectedPosition = position
        }
    }
}

