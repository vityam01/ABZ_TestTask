//
//  ReusableScreenViewModel.swift
//  abzTestTask
//
//  Created by Vitya Mandryk on 01.11.2024.
//

import Foundation
import SwiftUI

class ReusableScreenViewModel: ObservableObject {
    @Published var image: Image
    @Published var mainText: String
    @Published var buttonText: String
    @Published var showCloseButton: Bool
    
    var buttonAction: () -> Void
    var closeAction: (() -> Void)?
    
    init(image: Image,
         mainText: String,
         buttonText: String,
         buttonAction: @escaping () -> Void,
         showCloseButton: Bool = false,
         closeAction: (() -> Void)? = nil
    ) {
        self.image = image
        self.mainText = mainText
        self.buttonText = buttonText
        self.buttonAction = buttonAction
        self.showCloseButton = showCloseButton
        self.closeAction = closeAction
    }
}
