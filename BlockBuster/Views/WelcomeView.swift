import SwiftUI

struct WelcomeView: View {
    @State private var username: String = ""
    @State private var isLoggedIn: Bool = false
    @StateObject private var userManager = UserManager()

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Welcome to BlockBuster!")
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom, 20)
                
                TextField("Enter your username", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button(action: {
                    handleLoginOrRegister()
                }) {
                    Text("Login / Register")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.horizontal)

                NavigationLink("Continue to Dashboard", value: isLoggedIn)
                    .opacity(0)
                    .disabled(true)
            }
            .padding()
            .navigationTitle("Welcome")
            .navigationDestination(isPresented: $isLoggedIn) {
                DashboardView(username: username)
            }
        }
    }

    private func handleLoginOrRegister() {
        guard !username.isEmpty else { return }

        if let existingUser = userManager.getUser(username: username) {
            print("User exists: \(existingUser)")
        } else {
            let newUser = User(
                username: username,
                totalScore: 0,
                numGame: 0,
                winRate: 0,
                history: [],
                milestone: Milestone(
                    over10Score: false,
                    over20Score: false,
                    over50Score: false,
                    firstGamePlayedOnEasy: false,
                    firstGamePlayedOnMedium: false,
                    firstGamePlayedOnHard: false
                ),
                achievement: Achievement(
                    explorersFirstStep: false,
                    strategicThinker: false,
                    persistentPlayer: false,
                    curiousMind: false,
                    precisionTraining: false,
                    quickLearner: false
                )
            )
            userManager.addUser(newUser)
            print("Created new user: \(newUser)")
        }

        isLoggedIn = true
    }
}

#Preview {
    WelcomeView()
}
