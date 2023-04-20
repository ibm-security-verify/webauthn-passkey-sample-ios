//
// Copyright contributors to the IBM Security Verify Sample App for Passkey on iOS
//

import SwiftUI

class Passkey: ObservableObject {
    @AppStorage("token") var token: String = String()
    @AppStorage("displayName") var displayName: String = String()
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @AppStorage("isRegistered") var isRegistered: Bool = false
    
    @Published var isReset: Bool = false
    @Published var navigate: Bool = false
    
    @MainActor
    func logout() {
        self.isLoggedIn = false
        self.navigate = true
    }
    
    @MainActor
    func reset() {
        self.isLoggedIn = false
        self.isRegistered = false
        self.token = String()
        self.isReset = true
    }
}

