import SwiftUI

struct BattleView: View {
    let loginManager = LoginManager()
    let userData: UserData
    @State private var userPokemon: PokemonDetails?
    @State private var enemyPokemon: PokemonDetails?
    @State private var isFleeing: Bool = false
    @State private var userImage: UIImage?
    @State private var enemyImage: UIImage?
    @State private var userPokemonMaxVida: Int = 0
    @State private var enemyPokemonMaxVida: Int = 0
    @State private var userPokemonCurrentVida: Int = 0
    @State private var enemyPokemonCurrentVida: Int = 0
    @State private var isBattleStarted: Bool = false
    @State private var isBattleFinished: Bool = false
    @State private var navigateToMenu: Bool = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    HStack {
                        Rectangle()
                            .fill(Color.red)
                            .frame(width: CGFloat(enemyPokemonCurrentVida) / CGFloat(enemyPokemonMaxVida) * 200, height: 10)
                            .padding()
                        
                        GeometryReader { geometry in
                            Image(uiImage: enemyImage ?? UIImage())
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width * 0.4, height: geometry.size.width * 0.4)
                                .padding()
                                .position(x: geometry.size.width * 0.5, y: geometry.size.height * 0.5)
                        }
                    }
                    .frame(maxHeight: UIScreen.main.bounds.height / 4)
                    
                    HStack {
                        GeometryReader { geometry in
                            Image(uiImage: userImage ?? UIImage())
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width * 0.4, height: geometry.size.width * 0.4)
                                .padding()
                                .position(x: geometry.size.width * 0.5, y: geometry.size.height * 0.5)
                            
                        }
                        
                        Rectangle()
                            .fill(Color.green)
                            .frame(width: CGFloat(userPokemonCurrentVida) / CGFloat(userPokemonMaxVida) * 200, height: 10)
                            .padding()
                    }
                    .frame(maxHeight: UIScreen.main.bounds.height / 4)
                }
                
                VStack {
                    if isBattleStarted {
                        if let userPokemon = userPokemon {
                            HStack {
                                Button(action: {
                                    if let abilityDetails = loginManager.getAbilityDetails(for: userPokemon.habilidade1) {
                                        let damage = abilityDetails.ataque
                                        enemyPokemonCurrentVida -= damage
                                        if enemyPokemonCurrentVida <= 0 {
                                            enemyPokemonCurrentVida = 0
                                            isBattleFinished = true
                                        }
                                        print("Habilidade 1: \(abilityDetails.nome), Dano: \(damage)")
                                        
                                        enemyAttack()
                                    }
                                }) {
                                    Text("\(loginManager.getAbilityDetails(for: userPokemon.habilidade1)?.nome ?? "Habilidade 1")")
                                        .padding()
                                        .foregroundColor(.white)
                                        .background(Color.red)
                                        .cornerRadius(10)
                                }
                                .padding()
                                
                                Button(action: {
                                    if let abilityDetails = loginManager.getAbilityDetails(for: userPokemon.habilidade2) {
                                        let damage = abilityDetails.ataque
                                        enemyPokemonCurrentVida -= damage
                                        if enemyPokemonCurrentVida <= 0 {
                                            enemyPokemonCurrentVida = 0
                                            isBattleFinished = true
                                        }
                                        print("Habilidade 2: \(abilityDetails.nome), Dano: \(damage)")
                                        
                                        enemyAttack()
                                    }
                                }) {
                                    Text("\(loginManager.getAbilityDetails(for: userPokemon.habilidade2)?.nome ?? "Habilidade 2")")
                                        .padding()
                                        .foregroundColor(.white)
                                        .background(Color.red)
                                        .cornerRadius(10)
                                }
                                .padding()
                                
                                Button(action: {
                                    if let abilityDetails = loginManager.getAbilityDetails(for: userPokemon.habilidade3) {
                                        let damage = abilityDetails.ataque
                                        enemyPokemonCurrentVida -= damage
                                        if enemyPokemonCurrentVida <= 0 {
                                            enemyPokemonCurrentVida = 0
                                            isBattleFinished = true
                                        }
                                        print("Habilidade 3: \(abilityDetails.nome), Dano: \(damage)")
                                        
                                        enemyAttack()
                                    }
                                }) {
                                    Text("\(loginManager.getAbilityDetails(for: userPokemon.habilidade3)?.nome ?? "Habilidade 3")")
                                        .padding()
                                        .foregroundColor(.white)
                                        .background(Color.red)
                                        .cornerRadius(10)
                                }
                                .padding()
                                
                                Button(action: {
                                    if let abilityDetails = loginManager.getAbilityDetails(for: userPokemon.habilidade4) {
                                        let damage = abilityDetails.ataque
                                        enemyPokemonCurrentVida -= damage
                                        if enemyPokemonCurrentVida <= 0 {
                                            enemyPokemonCurrentVida = 0
                                            isBattleFinished = true
                                        }
                                        print("Habilidade 4: \(abilityDetails.nome), Dano: \(damage)")
                                        
                                        enemyAttack()
                                    }
                                }) {
                                    Text("\(loginManager.getAbilityDetails(for: userPokemon.habilidade4)?.nome ?? "Habilidade 4")")
                                        .padding()
                                        .foregroundColor(.white)
                                        .background(Color.red)
                                        .cornerRadius(10)
                                }
                                .padding()
                            }
                        }
                    } else {
                        Button(action: {
                            startBattle()
                        }) {
                            Text("Iniciar Batalha")
                                .padding()
                                .foregroundColor(.white)
                                .background(Color.red)
                                .cornerRadius(10)
                        }
                        .padding()
                        
                        Button(action: {
                            navigateToMenu = true
                        }) {
                            Text("Voltar")
                                .padding()
                                .foregroundColor(.white)
                                .background(Color.gray)
                                .cornerRadius(10)
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $navigateToMenu) {
            MenuView(userData: userData)
        }
        .onChange(of: isBattleFinished) { finished in
            if finished {
                navigateToMenu = true
                if finished {
                    loginManager.increaseVictory(for: userData.username, password: userData.password)
                } else {
                    loginManager.increaseDefeat(for: userData.username, password: userData.password)
                }
                presentationMode.wrappedValue.dismiss()
            }
        }
        .onAppear {
            loadUserPokemon()
            loadEnemyPokemon()
        }
    }
    
    private func loadUserPokemon() {
        guard let pokedexId = loginManager.getPokedexId(for: userData.username, password: userData.password) else {
            return
        }
        
        let pokemonDetails = loginManager.loadPokemonDetails(for: pokedexId)
        if let userPokemon = pokemonDetails.first {
            userPokemonMaxVida = userPokemon.vida
            userPokemonCurrentVida = userPokemon.vida
            self.userPokemon = userPokemon
            if let url = URL(string: userPokemon.assentpokemon1) {
                downloadImage(from: url) { image in
                    DispatchQueue.main.async {
                        userImage = image
                    }
                }
            }
        }
    }
    
    private func loadEnemyPokemon() {
        guard let randomPokemonData = loginManager.storeRandomPokemonData() else {
            return
        }
        
        let enemyPokemon = PokemonDetails(
            nome: randomPokemonData.nome,
            vida: randomPokemonData.vida,
            tipo: randomPokemonData.tipo,
            habilidade1: randomPokemonData.habilidade1,
            habilidade2: randomPokemonData.habilidade2,
            habilidade3: randomPokemonData.habilidade3,
            habilidade4: randomPokemonData.habilidade4,
            assentpokemon: randomPokemonData.assentpokemon,
            assentpokemon1: randomPokemonData.assentpokemon1
        )
        
        enemyPokemonMaxVida = enemyPokemon.vida
        enemyPokemonCurrentVida = enemyPokemon.vida
        self.enemyPokemon = enemyPokemon
        if let url = URL(string: enemyPokemon.assentpokemon) {
            downloadImage(from: url) { image in
                DispatchQueue.main.async {
                    enemyImage = image
                }
            }
        }
    }
    
    private func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            completion(image)
        }.resume()
    }
    
    private func startBattle() {
        isBattleStarted = true
    }
    
    private func enemyAttack() {
        guard let enemyPokemon = enemyPokemon else {
            return
        }
        
        let randomAbilityId = [enemyPokemon.habilidade1, enemyPokemon.habilidade2, enemyPokemon.habilidade3, enemyPokemon.habilidade4].randomElement()
        
        if let abilityId = randomAbilityId {
            if let abilityDetails = loginManager.getAbilityDetails(for: abilityId) {
                let damage = abilityDetails.ataque
                userPokemonCurrentVida -= damage
                if userPokemonCurrentVida <= 0 {
                    userPokemonCurrentVida = 0
                    isBattleFinished = true
                }
                print("O Pokémon adversário usou \(abilityDetails.nome) e causou \(damage) de dano.")
            }
        }
    }
}

struct BattleView_Previews: PreviewProvider {
    static var previews: some View {
        BattleView(userData: UserData())
    }
}

