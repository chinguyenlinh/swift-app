import SwiftUI
import Combine

class UserManager: ObservableObject {
    @AppStorage("users") private var storedUsersData: Data = Data()
    
    @Published var users: [User] = []

    init() {
        loadUsers()
    }
    
    func loadUsers() {
        if let decoded = try? JSONDecoder().decode([User].self, from: storedUsersData) {
            users = decoded
        }
    }

    func saveUsers() {
        if let encoded = try? JSONEncoder().encode(users) {
            storedUsersData = encoded
        }
    }

    func getUser(username: String) -> User? {
        return users.first { $0.username.lowercased() == username.lowercased() }
    }

    func addUser(_ user: User) {
        users.append(user)
        saveUsers()
    }
}
