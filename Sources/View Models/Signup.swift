//
// Copyright contributors to the IBM Security Verify Sample App for Passkey on iOS
//

import Foundation
import SwiftUI
import RelyingPartyKit

@MainActor class Signup: ObservableObject {
    private let client = RelyingPartyClient(baseURL: URL(string: "https://\(relyingParty)")!)
    
    @Published var username: String = String()
    @Published var email: String = String()
    @Published var errorMessage: String = String()
    @Published var navigate: Bool = false
    @Published var isPresentingErrorAlert: Bool = false
    @Published var validation: Validation = Validation()
    
    func signup() async {
        do {
            let result = try await client.signup(name: username, email: email)
            validation.transactionId = result.transactionId
            validation.prefix = result.correlation
            
            print(result)
            
            self.navigate.toggle()
        }
        catch let error {
            self.errorMessage = error.localizedDescription
            self.isPresentingErrorAlert.toggle()
        }
    }
}
