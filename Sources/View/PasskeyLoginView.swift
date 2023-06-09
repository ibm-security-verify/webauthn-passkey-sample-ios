//
// Copyright contributors to the IBM Security Verify Sample App for Passkey on iOS
//

import SwiftUI

struct PasskeyLoginView: View {
    @StateObject var model: PasskeyLogin = PasskeyLogin()
    @State var isProcessing: Bool = false
    
    var body: some View {
        VStack {
            NavigationLink(isActive: $model.navigate, destination: { PasskeyView() }, label: { EmptyView() })
            NavigationLink(isActive: $model.isReset, destination: { ContentView() }, label: { EmptyView() })
            
            Image(systemName: "person.badge.key.fill")
                .imageScale(.large)
                .foregroundColor(.accentColor)
                .font(.system(size: 32))
            
            VStack {
                Button(action: {
                    Task {
                        self.isProcessing.toggle()
                        await model.passwordless()
                        self.isProcessing.toggle()
                    }
                }) {
                    ZStack {
                        Image("busy")
                            .rotationEffect(.degrees(self.isProcessing ? 360.0 : 0.0))
                            .animation(.linear(duration: 1).repeatForever(autoreverses: false), value: self.isProcessing)
                            .opacity(self.isProcessing ? 1 : 0)
                        
                        Text("Login with Passkey")
                            .opacity(self.isProcessing ? 0 : 1)
                            .frame(maxWidth:.infinity)
                    }
                }
                .disabled(self.isProcessing)
                .alert(isPresented: $model.isPresentingErrorAlert,
                       content: {
                    Alert(title: Text("Alert"),
                          message: Text(model.errorMessage),
                          dismissButton: .cancel(Text("OK")))
                })
                .padding()
                .foregroundColor(.white)
                .background(.blue)
                .cornerRadius(8)
                
                Button {
                    self.model.reset()
                } label: {
                    Text("Reset")
                        .fontWeight(.medium)
                        .foregroundColor(.red)
                        .frame(maxWidth:.infinity)
                }
                .padding(.top)
            }
            .padding()
        }
        .padding(16)
    }
}

struct PasskeyLoginView_Previews: PreviewProvider {
    static var previews: some View {
        PasskeyLoginView()
    }
}
