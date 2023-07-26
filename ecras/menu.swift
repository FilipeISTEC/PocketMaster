import SwiftUI

struct MenuView: View {
    @ObservedObject var userData: UserData
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    let loginManager = LoginManager()
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    NavigationLink(destination: BattleView(userData: userData)) {
                        Text("1 VS 1")
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.red)
                            .cornerRadius(10)
                    }
                    .isDetailLink(false)
                    
                    NavigationLink(destination: InvPokemonView(userData: userData)) {
                        Text("EQUIPA")
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.red)
                            .cornerRadius(10)
                    }
                    .isDetailLink(false)
                    
                    Button(action: {
                        loginManager.clearData(userData: userData)
                        presentationMode.wrappedValue.dismiss()
                        
                    }) {
                        Text("SAIR")
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.gray)
                            .cornerRadius(10)
                    }
                    .padding(.top, 20)
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
                .background(Color(red: 0.53, green: 0.15, blue: 0.26)) 
            }
            .navigationBarTitle("Bem-vindo")
        }
    }
}




struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView(userData: UserData())
    }
}




