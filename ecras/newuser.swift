import SwiftUI

struct newUserView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var newUsername: String = ""
    @State private var newPassword: String = ""
    
    let loginManager = LoginManager()
    @ObservedObject var userData: UserData
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text("Criar Conta")
                    .font(.title)
                    .padding()
                
                TextField("Usuário", text: $newUsername)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                SecureField("Password", text: $newPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button(action: {
                    loginManager.createAccount(username: newUsername, password: newPassword)
                    
                    userData.username = newUsername
                    userData.password = newPassword
                    
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Criar")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.red)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Voltar")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.gray)
                        .cornerRadius(10)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(red: 136/255, green: 40/255, blue: 67/255))
            .edgesIgnoringSafeArea(.all)
        }
    }
}


struct newUserView_Previews: PreviewProvider {
    static var previews: some View {
        newUserView(userData: UserData())
    }
}
