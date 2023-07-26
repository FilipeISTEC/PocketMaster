import SwiftUI

class UserData: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
}

struct ContentView: View {
    @StateObject private var userData = UserData()
    @State private var loginSuccess: Bool = false
    @State private var showSignUp: Bool = false
    let loginManager = LoginManager()
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                VStack {
                    Text("Pocket Master")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top, 50)
                    
                    TextField("Usuário", text: $userData.username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                    
                    SecureField("Password", text: $userData.password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                    
                    Button(action: {
                        loginSuccess = loginManager.verificarCredenciais(user: userData.username, password: userData.password)
                    }, label: {
                        Text("Login")
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.red)
                            .cornerRadius(10)
                    })
                    .sheet(isPresented: $loginSuccess, content: {
                        MenuView(userData: userData)
                    })
                    
                    Button(action: {
                        showSignUp = true
                    }, label: {
                        Text("Nova Conta")
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.gray)
                            .cornerRadius(10)
                    })
                    .sheet(isPresented: $showSignUp, content: {
                        newUserView(userData: userData)
                    })
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(red: 136/255, green: 40/255, blue: 67/255))
                .edgesIgnoringSafeArea(.all)
                .navigationBarBackButtonHidden(true)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
