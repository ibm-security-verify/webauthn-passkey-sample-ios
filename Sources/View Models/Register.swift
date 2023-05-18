//
// Copyright contributors to the IBM Security Verify Sample App for Passkey on iOS
//

import Foundation
import SwiftUI
import AuthenticationServices
import RelyingPartyKit

class Register: NSObject, ObservableObject {
    private let client = RelyingPartyClient(baseURL: URL(string: "https://\(relyingParty)")!)
    
    @AppStorage("token") var token: String = String()
    @AppStorage("isRegistered") var isRegistered: Bool = false
    @AppStorage("displayName") var displayName: String = String()
    
    @Published var nickname: String = String()
    @Published var errorMessage: String = String()
    @Published var navigate: Bool = false
    @Published var isPresentingErrorAlert: Bool = false
    
    @MainActor
    func register() async {
        let result: CredentialRegistrationOptions
        do {
            result = try await fetchAttestationChallenge()
            self.displayName = result.user.displayName
        }
        catch let error {
            self.errorMessage = error.localizedDescription
            self.isPresentingErrorAlert = true
            return
        }
        
        print("UserID hex encoded: \(result.user.id.map { String(format: "%02hhx", $0) }.joined())")
        
        let provider = ASAuthorizationPlatformPublicKeyCredentialProvider(relyingPartyIdentifier: relyingParty)
        let request = provider.createCredentialRegistrationRequest(challenge: result.challenge, name: result.user.name, userID: result.user.id)
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
    func fetchAttestationChallenge() async throws -> CredentialRegistrationOptions {
        guard let token = Login.fetchTokenInfo(token: token) else {
            throw "Invalid access token."
        }
        
        return try await client.challenge(displayName: self.nickname, token: token)
    }
    
    func createCredential(registration: ASAuthorizationPlatformPublicKeyCredentialRegistration) async throws {
        guard let token = Login.fetchTokenInfo(token: token) else {
            throw "Invalid access token."
        }
        
        print(String(decoding: registration.rawClientDataJSON, as: UTF8.self))
        
        try await client.register(nickname: self.nickname,
                                               clientDataJSON: registration.rawClientDataJSON,
                                               attestationObject: registration.rawAttestationObject!,
                                               credentialId: registration.credentialID,
                                               token: token)
    }
}

extension Register: ASAuthorizationControllerDelegate {
    @MainActor
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let credential = authorization.credential as? ASAuthorizationPlatformPublicKeyCredentialRegistration {
            // After the server verifies the registration and creates the user account, sign in the user with the new account.
            Task {
                do {
                    try await createCredential(registration: credential)
                     
                    self.isRegistered = true
                    self.navigate = true
                }
                catch let error {
                    print("Attestation Result Response:\n\t\(error.localizedDescription)")
                    self.errorMessage = error.localizedDescription
                    self.isPresentingErrorAlert = true
                }
            }
        }
    }

    @MainActor
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        guard let authorizationError = error as? ASAuthorizationError else {
            self.errorMessage = error.localizedDescription
            self.isPresentingErrorAlert = true
            return
        }

        if authorizationError.code == .canceled {
            // Either the system doesn't find any credentials and the request ends silently, or the user cancels the request.
            // This is a good time to show a traditional login form, or ask the user to create an account.
            self.errorMessage = "Request canceled."
        }
        else {
            // Another ASAuthorization error.
            // Note: The userInfo dictionary contains useful information.
            self.errorMessage = error.localizedDescription
        }
        
        self.isPresentingErrorAlert = true
    }
}

extension Register: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return ASPresentationAnchor()
    }
}
