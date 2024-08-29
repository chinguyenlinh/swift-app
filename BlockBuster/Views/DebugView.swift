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
        }
        .padding()
        .navigationTitle("Debug View")
    }
}

#Preview {
    DebugView()
}
