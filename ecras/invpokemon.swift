import SwiftUI

struct InvPokemonView: View {
    let loginManager = LoginManager()
    @StateObject var userData: UserData
    
    @State private var pokemonData: [(nome: String, vida: Int, tipo: String, habilidade1: Int, habilidade2: Int, habilidade3: Int, habilidade4: Int, assentpokemon: String)] = []
    @State private var vitoria: Int?
    @State private var derrota: Int?
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                    .frame(height: 150)
                
                VStack {
                    HStack {
                        Text("Vitória")
                            .frame(width: geometry.size.width / 2, height: 50)
                            .border(Color.gray)
                        
                        Text("Derrota")
                            .frame(width: geometry.size.width / 2, height: 50)
                            .border(Color.gray)
                    }
                    .padding(.bottom, 10)
                    
                    HStack {
                        Text("\(vitoria ?? 0)")
                            .frame(width: geometry.size.width / 2, height: 50)
                            .border(Color.gray)
                        
                        Text("\(derrota ?? 0)")
                            .frame(width: geometry.size.width / 2, height: 50)
                            .border(Color.gray)
                    }
                }
                
                VStack {
                    ForEach(pokemonData.indices, id: \.self) { index in
                        let pokemon = pokemonData[index]
                        
                        HStack {
                            if let url = URL(string: pokemon.assentpokemon),
                               let imageData = try? Data(contentsOf: url),
                               let uiImage = UIImage(data: imageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .frame(width: 100, height: 50)
                                    .border(Color.gray)
                            }
                            Text(pokemon.nome)
                                .frame(width: 100, height: 50)
                                .border(Color.gray)
                            
                            Text("\(pokemon.vida)")
                                .frame(width: 100, height: 50)
                                .border(Color.gray)
                        }
                    }
                }
            }
            .navigationBarTitle("Estatisticas")
            .onAppear {
                let pokedexId = loginManager.getPokedexId(for: userData.username, password: userData.password)
                if let pokedexId = pokedexId {
                    let pokemonDetails = loginManager.loadPokemonDetails(for: pokedexId)
                    
                    pokemonData = pokemonDetails.map { pokemon in
                        return (nome: pokemon.nome, vida: pokemon.vida, tipo: pokemon.tipo, habilidade1: pokemon.habilidade1, habilidade2: pokemon.habilidade2, habilidade3: pokemon.habilidade3, habilidade4: pokemon.habilidade4, assentpokemon: pokemon.assentpokemon)
                    }
                    
                    let stats = loginManager.getUsersStats(for: userData.username, password: userData.password)
                    vitoria = stats?.vitoria
                    derrota = stats?.derrota
                }
            }
        }
        .background(Color(red: 136/255, green: 40/255, blue: 67/255))
        .edgesIgnoringSafeArea(.all)
    }
}

struct InvPokemonView_Previews: PreviewProvider {
    static var previews: some View {
        InvPokemonView(userData: UserData())
    }
}

