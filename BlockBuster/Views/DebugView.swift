import SwiftUI

struct DebugView: View {
    @AppStorage("users") private var storedUsersData: Data = Data()

    var body: some View {
        VStack {
            if let decoded = try? JSONDecoder().decode([User].self, from: storedUsersData) {
                Text("Users: \(decoded.description)")
                    .padding()
            } else {
                Text("No users found or failed to decode.")
                    .padding()
            }
            
            Button(action: {
                clearAppStorage()
            }) {
                Text("Clear All Data")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(10)
            }
            .padding()
        }
        .padding()
        .navigationTitle("Debug View")
    }

    private func clearAppStorage() {
        storedUsersData = Data() // Clear stored data
        print("AppStorage data cleared") // Optional: Print a message to debug console
    }
}

#Preview {
    DebugView()
}
