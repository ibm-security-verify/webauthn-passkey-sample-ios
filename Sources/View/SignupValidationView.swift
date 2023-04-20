//
// Copyright contributors to the IBM Security Verify Sample App for Passkey on iOS
//

import SwiftUI

struct SignupValidationView: View {
    @StateObject var model: Validation
    @State var isProcessing: Bool = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            NavigationLink(isActive: $model.navigate, destination: { RegisterView() }) { EmptyView() }
            
            Text("Check your email for the one-time password to complete the sign-up.")
                .multilineTextAlignment(.center)
                .foregroundColor(colorScheme == .dark ? .white : .black)
                .padding(20)
            VStack {
                HStack {
                    Text(model.prefix + " - ")
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                    TextField("One-time password", text: $model.otp)
                        .frame(minHeight: 28)
                        .padding(10)
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                        .overlay(RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(.systemGray5), lineWidth: 1))
                } .padding([.bottom], 100)
                
                Button(action: {
                    Task {
                        self.isProcessing.toggle()
                        await self.model.validate()
                        self.isProcessing.toggle()
                    }
                }) {
                    ZStack {
                        Image("busy")
                            .rotationEffect(.degrees(self.isProcessing ? 360.0 : 0.0))
                            .animation(.linear(duration: 1).repeatForever(autoreverses: false), value: self.isProcessing)
                            .opacity(self.isProcessing ? 1 : 0)
                        
                        Text("Validate")
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
            }
            .padding()
        }
        .padding(16)
    }
}

struct SignupValidationView_Previews: PreviewProvider {
    static var previews: some View {
        SignupValidationView(model: Validation())
    }
}
