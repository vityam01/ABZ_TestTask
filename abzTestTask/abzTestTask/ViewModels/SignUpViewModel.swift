//
//  SignUpViewModel.swift
//  abzTestTask
//
//  Created by Vitya Mandryk on 31.10.2024.
//

import Foundation
import SwiftUI
import Combine



class SignUpViewModel: ObservableObject {
    @Published var name = ""
    @Published var email = ""
    @Published var phone = ""
    @Published var selectedPosition: Position?
    @Published var positions: [Position] = []
    @Published var showError: [FieldType: Bool] = [.name: false, .email: false, .phone: false]
    @Published var userImage: UIImage? = nil
    @Published var isLoading = false
    @Published var showSuccessScreen = false
    @Published var showFailureScreen = false
    @Published var failureMessage = ""
    @Published var isPhotoUploaded = false
    @Published var isPhotoMissing = false
    @Published var errorMessages: [FieldType: String] = [:] 
    private var cancellables = Set<AnyCancellable>()
    @Published var users: [User] = []
    @Published var hasMoreUsers = true
    private var userAPIManager = UserAPIManager()
    private var page = 1
    
    private var authToken: String?
    private var tokenCreationDate: Date?
    
    private var token: String?
    
    var allFieldsFilled: Bool {
        return isValidName(name) && isValidEmail(email) && isValidPhone(phone) && userImage != nil
    }
    
    private func isValidName(_ name: String) -> Bool {
        return name.count >= 2 && name.count <= 60
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }

    
    private func isValidPhone(_ phone: String) -> Bool {
        let phoneRegex = "^\\+380[0-9]{9}$"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phonePredicate.evaluate(with: phone)
    }
    
    private func isValidPhoto(_ image: UIImage?) -> Bool {
        guard let image = image, let imageData = image.jpegData(compressionQuality: 1.0) else { return false }
        
        let maxFileSize = 5 * 1024 * 1024
        let minResolution: CGFloat = 70.0
        
        guard imageData.count <= maxFileSize else { return false }
        guard image.size.width >= minResolution && image.size.height >= minResolution else { return false }
        
        return true
    }
    
    func validateFields() {
        showError[.name] = !isValidName(name)
        showError[.email] = !isValidEmail(email)
        showError[.phone] = !isValidPhone(phone)
        
        
        
        isPhotoMissing = userImage == nil
        errorMessages[.name] = showError[.name] == true ? "Required field" : ""
        errorMessages[.email] = showError[.email] == true ? "Invalid email format" : ""
        errorMessages[.phone] = showError[.phone] == true ? "Required field" : ""
    }
    
    func togglePhotoUpload() {
        isPhotoUploaded.toggle()
    }
    
    // MARK: - Token Fetch on Appear
    func fetchTokenOnAppear() {
        UserAPIManager.shared.fetchTokenIfNeeded { [weak self] result in
            switch result {
            case .success(let fetchedToken):
                self?.token = fetchedToken
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.failureMessage = error.localizedDescription
                    self?.showFailureScreen = true
                }
            }
        }
    }
    //MARK: fetchPositions
    func fetchPositions() {
            userAPIManager.fetchPositions { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let fetchedPositions):
                        self?.positions = fetchedPositions
                    case .failure(let error):
                        self?.failureMessage = error.localizedDescription
                        self?.showFailureScreen = true
                    }
                }
            }
        }
    
    // MARK: - Sign Up Action
    func performSignUp() {
        guard let positionId = selectedPosition?.id, let imageData = userImage?.jpegData(compressionQuality: 0.8), let token = token else {
            failureMessage = "Token not available. Please retry."
            showFailureScreen = true
            return
        }
        
        isLoading = true
        showSuccessScreen = false
        showFailureScreen = false
        
        submitSignUpData(token: token, positionId: positionId, imageData: imageData)
    }
    
    private func submitSignUpData(token: String, positionId: Int, imageData: Data) {
        UserAPIManager.shared.registerUser(
            name: name, email: email, phone: phone, positionId: positionId,
            photoData: imageData, token: token
        ) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                switch result {
                case .success:
                    self.showSuccessScreen = true
                case .failure(let error):
                    self.failureMessage = error.localizedDescription
                    self.showFailureScreen = true
                }
            }
        }
    }
}


