
import Foundation
import SQLite3

class LoginManager {
    private let dbPath = "/Users/n0icn/Desktop/PocketMaster/PocketMaster/database/dbgym.db"
    private let treinador = "treinador"
    private let userColumn = "user"
    private let passwordColumn = "password"
    private let pokedexColumn = "pokedex"
    
    func verificarCredenciais(user: String, password: String) -> Bool {
        var db: OpaquePointer? = nil
        
        if sqlite3_open(dbPath, &db) == SQLITE_OK {
            let queryString = "SELECT COUNT(*) FROM \(treinador) WHERE \(userColumn) = ? AND \(passwordColumn) = ?"
            var statement: OpaquePointer?
            
            if sqlite3_prepare_v2(db, queryString, -1, &statement, nil) == SQLITE_OK {
                sqlite3_bind_text(statement, 1, NSString(string: user).utf8String, -1, nil)
                sqlite3_bind_text(statement, 2, NSString(string: password).utf8String, -1, nil)
                
                if sqlite3_step(statement) == SQLITE_ROW {
                    let count = sqlite3_column_int(statement, 0)
                    sqlite3_finalize(statement)
                    sqlite3_close(db)
                    return count > 0
                }
            }
        }

        sqlite3_close(db)
        return false
    }
    
    func getPokedexId(for user: String, password: String) -> Int? {
        var db: OpaquePointer? = nil
        var pokedexId: Int? = nil
        
        if sqlite3_open(dbPath, &db) == SQLITE_OK {
            let queryString = "SELECT \(pokedexColumn) FROM \(treinador) WHERE \(userColumn) = ? AND \(passwordColumn) = ?"
            var statement: OpaquePointer?
            
            if sqlite3_prepare_v2(db, queryString, -1, &statement, nil) == SQLITE_OK {
                sqlite3_bind_text(statement, 1, NSString(string: user).utf8String, -1, nil)
                sqlite3_bind_text(statement, 2, NSString(string: password).utf8String, -1, nil)
                
                if sqlite3_step(statement) == SQLITE_ROW {
                    pokedexId = Int(sqlite3_column_int(statement, 0))
                }
                sqlite3_finalize(statement)
            }
            sqlite3_close(db)
        }
        return pokedexId
    }
    
    func loadPokemonDetails(for pokedexId: Int) -> [PokemonDetails] {
        var pokemonDetails: [PokemonDetails] = []
        
        var db: OpaquePointer?
        
        if sqlite3_open(dbPath, &db) == SQLITE_OK {
            let queryString = "SELECT * FROM pokedex WHERE pokedex_id = ?"
            var statement: OpaquePointer?
            
            if sqlite3_prepare_v2(db, queryString, -1, &statement, nil) == SQLITE_OK {
                sqlite3_bind_int(statement, 1, Int32(pokedexId))
                
                if sqlite3_step(statement) == SQLITE_ROW {
                    var pokemonIds: [Int] = []
                    for i in 1...6 {
                        let pokemonId = Int(sqlite3_column_int(statement, Int32(i)))
                        pokemonIds.append(pokemonId)
                    }
                    
                    for pokemonId in pokemonIds {
                        if let pokemonData = loadPokemonData(for: pokemonId) {
                            pokemonDetails.append(pokemonData)
                        }
                    }
                }
                sqlite3_finalize(statement)
            }
            sqlite3_close(db)
        }
        return pokemonDetails
    }
    
    func loadPokemonData(for pokemonId: Int) -> PokemonDetails? {
        var pokemonData: PokemonDetails? = nil
        var db: OpaquePointer?
        
        if sqlite3_open(dbPath, &db) == SQLITE_OK {
            let queryString = "SELECT * FROM pokemon WHERE pokemon_id = ?"
            var statement: OpaquePointer?
            
            if sqlite3_prepare_v2(db, queryString, -1, &statement, nil) == SQLITE_OK {
                sqlite3_bind_int(statement, 1, Int32(pokemonId))
                
                if sqlite3_step(statement) == SQLITE_ROW {
                    let nome = String(cString: sqlite3_column_text(statement, 1))
                    let vida = Int(sqlite3_column_int(statement, 2))
                    let tipo = String(cString: sqlite3_column_text(statement, 3))
                    let habilidade1 = Int(sqlite3_column_int(statement, 4))
                    let habilidade2 = Int(sqlite3_column_int(statement, 5))
                    let habilidade3 = Int(sqlite3_column_int(statement, 6))
                    let habilidade4 = Int(sqlite3_column_int(statement, 7))
                    let assentpokemon: String
                    if let cString = sqlite3_column_text(statement, 8) {
                        assentpokemon = String(cString: cString)
                    } else {
                        assentpokemon = ""
                    }
                    let assentpokemon1: String
                    if let cString = sqlite3_column_text(statement, 9) {
                        assentpokemon1 = String(cString: cString)
                    } else {
                        assentpokemon1 = ""
                    }
                    pokemonData = PokemonDetails(nome: nome, vida: vida, tipo: tipo, habilidade1: habilidade1, habilidade2: habilidade2, habilidade3: habilidade3, habilidade4: habilidade4, assentpokemon: assentpokemon, assentpokemon1: assentpokemon1)
                }
                sqlite3_finalize(statement)
            }
            sqlite3_close(db)
        }
        return pokemonData
    }
    
    func storeRandomPokemonData() -> RandomPokemonData? {
        var randomPokemonData: RandomPokemonData? = nil
        var db: OpaquePointer?
        
        if sqlite3_open(dbPath, &db) == SQLITE_OK {
            let queryString = "SELECT * FROM pokemons ORDER BY RANDOM() LIMIT 1"
            var statement: OpaquePointer?
            
            if sqlite3_prepare_v2(db, queryString, -1, &statement, nil) == SQLITE_OK {
                if sqlite3_step(statement) == SQLITE_ROW {
                    let nome = String(cString: sqlite3_column_text(statement, 1))
                    let vida = Int(sqlite3_column_int(statement, 2))
                    let tipo = String(cString: sqlite3_column_text(statement, 3))
                    let habilidade1 = Int(sqlite3_column_int(statement, 4))
                    let habilidade2 = Int(sqlite3_column_int(statement, 5))
                    let habilidade3 = Int(sqlite3_column_int(statement, 6))
                    let habilidade4 = Int(sqlite3_column_int(statement, 7))
                    let assentpokemon = String(cString: sqlite3_column_text(statement, 8))
                    let assentpokemon1 = String(cString: sqlite3_column_text(statement, 9))
                    
                    randomPokemonData = RandomPokemonData(nome: nome, vida: vida, tipo: tipo, habilidade1: habilidade1, habilidade2: habilidade2, habilidade3: habilidade3, habilidade4: habilidade4, assentpokemon: assentpokemon, assentpokemon1: assentpokemon1)
                }
                sqlite3_finalize(statement)
            }
            sqlite3_close(db)
        }
        return randomPokemonData
    }
    
    func getAbilityDetails(for abilityID: Int) -> (nome: String, ataque: Int)? {
        var abilityDetails: (nome: String, ataque: Int)? = nil
        var db: OpaquePointer?
        
        if sqlite3_open(dbPath, &db) == SQLITE_OK {
            let queryString = "SELECT habilidade_nome, ataque FROM habilidades WHERE habilidade_id = ?"
            var statement: OpaquePointer?
            
            if sqlite3_prepare_v2(db, queryString, -1, &statement, nil) == SQLITE_OK {
                sqlite3_bind_int(statement, 1, Int32(abilityID))
                
                if sqlite3_step(statement) == SQLITE_ROW {
                    let nome = String(cString: sqlite3_column_text(statement, 0))
                    let ataque = Int(sqlite3_column_int(statement, 1))
                    abilityDetails = (nome: nome, ataque: ataque)
                }
                sqlite3_finalize(statement)
            }
            sqlite3_close(db)
        }
        return abilityDetails
    }
    
    func getUsersStats(for user: String, password: String) -> PokemonValues? {
        var pokemonValues: PokemonValues? = nil
        var db: OpaquePointer?
        
        if sqlite3_open(dbPath, &db) == SQLITE_OK {
            let queryString = "SELECT vitoria, derrota FROM pokedex WHERE pokedex_id = (SELECT pokedex FROM \(treinador) WHERE \(userColumn) = ? AND \(passwordColumn) = ?)"
            var statement: OpaquePointer?
            
            if sqlite3_prepare_v2(db, queryString, -1, &statement, nil) == SQLITE_OK {
                sqlite3_bind_text(statement, 1, NSString(string: user).utf8String, -1, nil)
                sqlite3_bind_text(statement, 2, NSString(string: password).utf8String, -1, nil)
                
                if sqlite3_step(statement) == SQLITE_ROW {
                    let vitoria = Int(sqlite3_column_int(statement, 0))
                    let derrota = Int(sqlite3_column_int(statement, 1))
                    
                    pokemonValues = PokemonValues(vitoria: vitoria, derrota: derrota)
                }
                sqlite3_finalize(statement)
            }
            sqlite3_close(db)
        }
        return pokemonValues
    }
    
    func increaseVictory(for user: String, password: String) {
        guard let pokedexId = getPokedexId(for: user, password: password) else {
            print("Failed to get pokedex ID.")
            return
        }
        
        var db: OpaquePointer?
        
        if sqlite3_open(dbPath, &db) == SQLITE_OK {
            let queryString = "UPDATE pokedex SET vitoria = vitoria + 1 WHERE pokedex_id = ?"
            var statement: OpaquePointer?
            
            if sqlite3_prepare_v2(db, queryString, -1, &statement, nil) == SQLITE_OK {
                sqlite3_bind_int(statement, 1, Int32(pokedexId))
                
                if sqlite3_step(statement) == SQLITE_DONE {
                    print("Victory value increased successfully.")
                }
                
                sqlite3_finalize(statement)
            }
            
            sqlite3_close(db)
        }
    }
    
    func increaseDefeat(for user: String, password: String) {
        guard let pokedexId = getPokedexId(for: user, password: password) else {
            print("Failed to get pokedex ID.")
            return
        }
        
        var db: OpaquePointer?
        
        if sqlite3_open(dbPath, &db) == SQLITE_OK {
            let queryString = "UPDATE pokedex SET derrota = derrota + 1 WHERE pokedex_id = ?"
            var statement: OpaquePointer?
            
            if sqlite3_prepare_v2(db, queryString, -1, &statement, nil) == SQLITE_OK {
                sqlite3_bind_int(statement, 1, Int32(pokedexId))
                
                if sqlite3_step(statement) == SQLITE_DONE {
                    print("Defeat value increased successfully.")
                }
                
                sqlite3_finalize(statement)
            }
            
            sqlite3_close(db)
        }
    }
    
    func createAccount(username: String, password: String) {
        var db: OpaquePointer?
        
        if sqlite3_open(dbPath, &db) == SQLITE_OK {
            let insertPokedexQuery = "INSERT INTO pokedex (vitoria, derrota) VALUES (0, 0)"
            var insertPokedexStatement: OpaquePointer?
            
            if sqlite3_prepare_v2(db, insertPokedexQuery, -1, &insertPokedexStatement, nil) == SQLITE_OK {
                if sqlite3_step(insertPokedexStatement) == SQLITE_DONE {
                    print("New pokedex entry created successfully.")
                }
                
                sqlite3_finalize(insertPokedexStatement)
            }
            
            let pokedexId = Int(sqlite3_last_insert_rowid(db))
            
            let insertTreinadorQuery = "INSERT INTO treinador (\(userColumn), \(passwordColumn), \(pokedexColumn)) VALUES (?, ?, ?)"
            var insertTreinadorStatement: OpaquePointer?
            
            if sqlite3_prepare_v2(db, insertTreinadorQuery, -1, &insertTreinadorStatement, nil) == SQLITE_OK {
                sqlite3_bind_text(insertTreinadorStatement, 1, NSString(string: username).utf8String, -1, nil)
                sqlite3_bind_text(insertTreinadorStatement, 2, NSString(string: password).utf8String, -1, nil)
                sqlite3_bind_int(insertTreinadorStatement, 3, Int32(pokedexId))
                
                if sqlite3_step(insertTreinadorStatement) == SQLITE_DONE {
                    print("Account created successfully.")
                }
                
                sqlite3_finalize(insertTreinadorStatement)
            }
            
            let selectPokemonQuery = "SELECT * FROM pokemons LIMIT 1"
            var selectPokemonStatement: OpaquePointer?
            
            if sqlite3_prepare_v2(db, selectPokemonQuery, -1, &selectPokemonStatement, nil) == SQLITE_OK {
                if sqlite3_step(selectPokemonStatement) == SQLITE_ROW {
                    let nome = String(cString: sqlite3_column_text(selectPokemonStatement, 1))
                    let vida = Int(sqlite3_column_int(selectPokemonStatement, 2))
                    let tipo = String(cString: sqlite3_column_text(selectPokemonStatement, 3))
                    let habilidade1 = Int(sqlite3_column_int(selectPokemonStatement, 4))
                    let habilidade2 = Int(sqlite3_column_int(selectPokemonStatement, 5))
                    let habilidade3 = Int(sqlite3_column_int(selectPokemonStatement, 6))
                    let habilidade4 = Int(sqlite3_column_int(selectPokemonStatement, 7))
                    let assentpokemon = String(cString: sqlite3_column_text(selectPokemonStatement, 8))
                    let assentpokemon1 = String(cString: sqlite3_column_text(selectPokemonStatement, 9))
                    
                    let insertPokemonQuery = "INSERT INTO pokemon (nome, vida, tipo, habilidade1, habilidade2, habilidade3, habilidade4, assentpokemon, assentspokemon1) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)"
                    var insertPokemonStatement: OpaquePointer?
                    
                    if sqlite3_prepare_v2(db, insertPokemonQuery, -1, &insertPokemonStatement, nil) == SQLITE_OK {
                        sqlite3_bind_text(insertPokemonStatement, 1, NSString(string: nome).utf8String, -1, nil)
                        sqlite3_bind_int(insertPokemonStatement, 2, Int32(vida))
                        sqlite3_bind_text(insertPokemonStatement, 3, NSString(string: tipo).utf8String, -1, nil)
                        sqlite3_bind_int(insertPokemonStatement, 4, Int32(habilidade1))
                        sqlite3_bind_int(insertPokemonStatement, 5, Int32(habilidade2))
                        sqlite3_bind_int(insertPokemonStatement, 6, Int32(habilidade3))
                        sqlite3_bind_int(insertPokemonStatement, 7, Int32(habilidade4))
                        sqlite3_bind_text(insertPokemonStatement, 8, NSString(string: assentpokemon).utf8String, -1, nil)
                        sqlite3_bind_text(insertPokemonStatement, 9, NSString(string: assentpokemon1).utf8String, -1, nil)
                        
                        if sqlite3_step(insertPokemonStatement) == SQLITE_DONE {
                            print("New pokemon entry created successfully.")
                        }
                        
                        sqlite3_finalize(insertPokemonStatement)
                    }
                    
                    let pokemonId = Int(sqlite3_last_insert_rowid(db))
                    
                    let updatePokedexQuery = "UPDATE pokedex SET pokemon1 = ? WHERE pokedex_id = ?"
                    var updatePokedexStatement: OpaquePointer?
                    
                    if sqlite3_prepare_v2(db, updatePokedexQuery, -1, &updatePokedexStatement, nil) == SQLITE_OK {
                        sqlite3_bind_int(updatePokedexStatement, 1, Int32(pokemonId))
                        sqlite3_bind_int(updatePokedexStatement, 2, Int32(pokedexId))
                        
                        if sqlite3_step(updatePokedexStatement) == SQLITE_DONE {
                            print("Updated pokedex entry successfully.")
                        }
                        
                        sqlite3_finalize(updatePokedexStatement)
                    }
                }
                
                sqlite3_finalize(selectPokemonStatement)
            }
            
            sqlite3_close(db)
        }
    }
    func clearData(userData: UserData) {
        userData.username = ""
        userData.password = ""
    }
}
