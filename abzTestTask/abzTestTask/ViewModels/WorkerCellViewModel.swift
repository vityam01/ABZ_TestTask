//
//  WorkerCellViewModel.swift
//  abzTestTask
//
//  Created by Vitya Mandryk on 31.10.2024.
//

import Foundation
import SwiftUI

class WorkerCellViewModel: ObservableObject {
    @Published var image: String
    @Published var name: String
    @Published var position: String
    @Published var email: String
    @Published var phoneNumber: String
    
    init(user: User) {
        self.image = user.photo
        self.name = user.name
        self.position = user.position
        self.email = user.email
        self.phoneNumber = user.phone
    }
}
