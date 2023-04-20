//
// Copyright contributors to the IBM Security Verify Sample App for Passkey on iOS
//

import Foundation
import SwiftUI
import RelyingPartyKit

class Validation: ObservableObject {
    private let client = RelyingPartyClient(baseURL: URL(string: "https://\(relyingParty)")!)

    @AppStorage("token") var token: String = String()
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    
    @Published var prefix: String = "1234"
    @Published var transactionId: String = String()
    @Published var otp: String = String()
    @Published var errorMessage: String = String()
    @Published var navigate: Bool = false
    @Published var isPresentingErrorAlert: Bool = false
    
    @MainActor
    func validate() async {
        do {
            let result = try await client.validate(transactionId: transactionId, otp: otp)
            let data = try JSONEncoder().encode(result)
            
            self.token = String(data: data, encoding: .utf8)!
            self.isLoggedIn = true
            print("Token Response:\n\t\(token)")
            self.navigate.toggle()
        }
        catch let error {
            self.errorMessage = error.localizedDescription
            self.isPresentingErrorAlert.toggle()
        }
    }
}
