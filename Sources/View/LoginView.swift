//
// Copyright contributors to the IBM Security Verify Sample App for Passkey on iOS
//

import SwiftUI

struct LoginView: View {
    @StateObject var model: Login = Login()
    @StateObject var signupModel: Signup = Signup()
    @State var isSigninProcessing: Bool = false
    @State var isSignupProcessing: Bool = false
    
    var body: some View {
        VStack {
            NavigationLink(isActive: $model.navigate, destination: { RegisterView() }) { EmptyView() }
            NavigationLink(isActive: $signupModel.navigate, destination: { SignupValidationView(model: signupModel.validation) }) { EmptyView() }
            
            Text("Sample App for Passkey")
                .padding(10)
                .font(.title)
                .multilineTextAlignment(.center)
            Image(systemName: "person.badge.key.fill")
                .imageScale(.large)
                .foregroundColor(.accentColor)
                .font(.system(size: 32))
            
            VStack {
                TextField("Username", text: $model.username)
                    .frame(minHeight: 28)
                    .padding(10)
                    .overlay(RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(.systemGray5), lineWidth: 1))
                SecureField("Password", text: $model.password)
                    .frame(minHeight: 28)
                    .padding(10)
                    .overlay(RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(.systemGray5), lineWidth: 1))
                    .padding([.bottom], 10)
                
                Button(action: {
                    Task {
                        self.isSigninProcessing.toggle()
                        await model.login()
                        self.isSigninProcessing.toggle()
                    }
                }) {
                    ZStack {
                        Image("busy")
                            .rotationEffect(.degrees(self.isSigninProcessing ? 360.0 : 0.0))
                            .animation(.linear(duration: 1).repeatForever(autoreverses: false), value: self.isSigninProcessing)
                            .opacity(self.isSigninProcessing ? 1 : 0)
                        
                        Text("Sign-in")
                            .opacity(self.isSigninProcessing ? 0 : 1)
                            .frame(maxWidth:.infinity)
                    }
                }
                .disabled(self.isSigninProcessing)
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
                
                Text("Or")
                    .padding(20)
                TextField("Username", text: $signupModel.username)
                    .frame(minHeight: 28)
                    .padding(10)
                    .overlay(RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(.systemGray5), lineWidth: 1))
                TextField("E-mail", text: $signupModel.email)
                    .frame(minHeight: 28)
                    .padding(10)
                    .overlay(RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(.systemGray5), lineWidth: 1))
                    .padding([.bottom], 10)
                
                Button(action: {
                    Task {
                        self.isSignupProcessing.toggle()
                        await signupModel.signup()
                        self.isSignupProcessing.toggle()
                    }
                }) {
                    ZStack {
                        Image("busy")
                            .rotationEffect(.degrees(self.isSignupProcessing ? 360.0 : 0.0))
                            .animation(.linear(duration: 1).repeatForever(autoreverses: false), value: self.isSignupProcessing)
                            .opacity(self.isSignupProcessing ? 1 : 0)
                        
                        Text("Sign-up")
                            .opacity(self.isSignupProcessing ? 0 : 1)
                            .frame(maxWidth:.infinity)
                    }
                }
                .disabled(self.isSignupProcessing)
                .alert(isPresented: $signupModel.isPresentingErrorAlert,
                       content: {
                    Alert(title: Text("Alert"),
                          message: Text(signupModel.errorMessage),
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

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
