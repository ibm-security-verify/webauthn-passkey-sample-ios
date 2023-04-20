//
// Copyright contributors to the IBM Security Verify Sample App for Passkey on iOS
//

import SwiftUI

struct PasskeyView: View {
    @StateObject var model: Passkey = Passkey()
    
    var body: some View {
        VStack {
            NavigationLink(isActive: $model.navigate, destination: { PasskeyLoginView() }) { EmptyView() }
            NavigationLink(isActive: $model.isReset, destination: { ContentView() }, label: { EmptyView() })
            
            Image(systemName: "person.fill")
                .imageScale(.large)
                .foregroundColor(.accentColor)
                .font(.system(size: 32))
            Text("Welcome, \($model.displayName.wrappedValue)")
                .font(.title2)
                .foregroundColor(.black)
                .padding(2)
            VStack {
                Button(action: {
                    self.model.logout()
                }) {
                    ZStack {
                        Text("Logout")
                            .frame(maxWidth:.infinity)
                    }
                }
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

struct PasskeyView_Previews: PreviewProvider {
    static var previews: some View {
        PasskeyView()
    }
}
