//
// Copyright contributors to the IBM Security Verify Sample App for Passkey on iOS
//

import SwiftUI

struct ContentView: View {
    @AppStorage("token") private var token = String()
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @AppStorage("isRegistered") private var isRegistered: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                if self.isRegistered && !self.isLoggedIn {
                    PasskeyLoginView()
                }
                else if !self.isRegistered && self.isLoggedIn {
                    RegisterView()
                }
                else if self.token.isEmpty {
                    LoginView()
                }
                else {
                    PasskeyView()
                }
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
