//
//  RadioButtonTabView.swift
//  abzTestTask
//
//  Created by Vitya Mandryk on 31.10.2024.
//

import Foundation
import SwiftUI

struct RadioButtonTab: View {
    @Binding var selectedTab: Tab
    var label: String
    var iconDefault: String
    var iconActive: String
    var tab: Tab
    
    var body: some View {
        Button(action: {
            selectedTab = tab
        }) {
            HStack {
                Image(selectedTab == tab ? iconActive : iconDefault)
                    .frame(width: 22, height: 17)
                Text(label)
                    .foregroundColor(selectedTab == tab ? AppColors.appBlue : AppColors.darkGray)
                    .font(AppFont.semiBold.font(size: 16))
            }
        }
    }
}
