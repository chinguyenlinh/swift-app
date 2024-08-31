import SwiftUI

struct GameSettingView: View {
    @State private var difficulty: String = "medium" // Default difficulty
    @State private var isGameViewPresented = false
    @State private var user: User?
    @StateObject private var userManager = UserManager()

    let username: String

    private func loadUser() {
        user = userManager.getUser(username: username)
    }

    var body: some View {
        NavigationStack {
            if let user = user {
                VStack(spacing: 20) {
                    Text("Choose Difficulty")
                        .font(.largeTitle)
                        .padding(.bottom, 20)
                    
                    // Difficulty Buttons
                    VStack(spacing: 15) {
                        Button(action: {
                            difficulty = "easy"
                        }) {
                            Text("Easy")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(difficulty == "easy" ? Color.blue : Color.gray.opacity(0.2))
                                .cornerRadius(10)
                                .foregroundColor(.black)
                        }
                        
                        Button(action: {
                            difficulty = "medium"
                        }) {
                            Text("Medium")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(difficulty == "medium" ? Color.blue : Color.gray.opacity(0.2))
                                .cornerRadius(10)
                                .foregroundColor(.black)
                        }
                        
                        Button(action: {
                            difficulty = "hard"
                        }) {
                            Text("Hard")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(difficulty == "hard" ? Color.blue : Color.gray.opacity(0.2))
                                .cornerRadius(10)
                                .foregroundColor(.black)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Submit Button
                    Button(action: {
                        isGameViewPresented = true
                    }) {
                        Text("Submit")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .cornerRadius(10)
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal)
                    .disabled(difficulty.isEmpty) // Ensure a difficulty is chosen before enabling the button
                    
                    Spacer()
                }
                .padding()
                .navigationTitle("Game Settings")
                .fullScreenCover(isPresented: $isGameViewPresented) {
                    GameView(difficulty: difficulty, username: user.username)
                }
            }
        }
        .onAppear {
            loadUser()
        }
    }
}

#Preview {
    GameSettingView(username: "Khang")
}
